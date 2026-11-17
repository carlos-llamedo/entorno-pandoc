--[[
dividir-bibliografia – Divide en grupos la bibliografía que genera citeproc.

Copyright © 2026 Carlos Llamedo
https://github.com/carlos-llamedo/entorno-pandoc

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the ‘Software’),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED ‘AS IS’, WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
]]

-- Debe ir después de citeproc. Divide en grupos el div #refs que ha
-- llenado citeproc, según los grupos declarados en `reference-sections`:
--
--   reference-sections:
--     - title: Legislación
--       file: legislación.json   # cadena o lista; solo se leen las claves
--     - title: Bibliografía      # sin file: lo que no esté en los anteriores
--
-- Cada entrada va al primer grupo cuyos archivos contienen su clave; si no
-- está en ninguno, al primer grupo sin `file`. Dentro de cada grupo se
-- mantiene el orden de citeproc. Un grupo con `id` se coloca en el div
-- `refs-<id>` del documento, si existe; los demás se generan en el sitio
-- de #refs, cada uno con un encabezado sin numerar.

local stringify = pandoc.utils.stringify

local FORMATOS = {
  json = 'csljson', yaml = 'markdown', yml = 'markdown',
  bib = 'biblatex', ris = 'ris',
}

local function avisar (mensaje)
  pandoc.log.warn('dividir-bibliografia: ' .. mensaje)
end

-- Lista de cadenas a partir de un valor de metadatos (cadena o lista).
local function lista (valor)
  if valor == nil then return {} end
  if pandoc.utils.type(valor) == 'List' then
    return valor:map(stringify)
  end
  return {stringify(valor)}
end

local function como_inlines (valor)
  local tipo = pandoc.utils.type(valor)
  if tipo == 'Inlines' then return valor end
  if tipo == 'Blocks' then return pandoc.utils.blocks_to_inlines(valor) end
  return pandoc.Inlines(stringify(valor or ''))
end

-- Claves de un archivo de bibliografía, que se busca como lo hace pandoc
-- (en el `resource-path`).
local function claves (ruta)
  local ext = (ruta:match('%.([^./]+)$') or ''):lower()
  local formato = FORMATOS[ext]
  if not formato then
    error('dividir-bibliografia: formato de archivo no admitido: ' .. ruta, 0)
  end
  local ok, _, contenido = pcall(pandoc.mediabag.fetch, ruta)
  if not ok then
    error('dividir-bibliografia: no se encuentra el archivo ' .. ruta, 0)
  end
  if formato == 'markdown' then
    -- CSL YAML: un bloque de metadatos con `references`.
    contenido = contenido:gsub('^%-%-%-%s*\n', ''):gsub('\n[%-%.][%-%.][%-%.]%s*$', '')
    contenido = '---\n' .. contenido .. '\n---\n'
  end
  local res = {}
  for _, ref in ipairs(pandoc.read(contenido, formato).meta.references or {}) do
    res[stringify(ref.id)] = true
  end
  return res
end

local function leer_grupos (meta)
  local grupos = {}
  for i, g in ipairs(meta['reference-sections'] or {}) do
    local archivos = lista(g.file)
    local miembros
    if #archivos > 0 then
      miembros = {}
      for _, ruta in ipairs(archivos) do
        for clave in pairs(claves(ruta)) do miembros[clave] = true end
      end
    end
    grupos[i] = {
      titulo = como_inlines(g.title),
      id = g.id and stringify(g.id) or nil,
      miembros = miembros,   -- nil: grupo para el resto
      entradas = pandoc.Blocks{},
    }
  end
  return grupos
end

local function es_entrada (bloque)
  return bloque.t == 'Div' and bloque.identifier:match('^ref%-') ~= nil
end

-- Atributos de los divs de cada grupo: los que citeproc puso en #refs,
-- con el estilo de párrafo de Word u ODT que pandoc da a la bibliografía.
local function atributos (refs, id)
  local copia = {}
  for k, v in pairs(refs.attributes) do copia[k] = v end
  local attr = pandoc.Attr(id, refs.classes:clone(), copia)
  if FORMAT == 'docx' or FORMAT == 'odt' then
    attr.attributes['custom-style'] = attr.attributes['custom-style'] or 'Bibliography'
  end
  return attr
end

function Pandoc (doc)
  local declarados = doc.meta['reference-sections']
  if pandoc.utils.type(declarados) ~= 'List' or #declarados == 0 then return nil end
  local grupos = leer_grupos(doc.meta)

  -- Primer recorrido: el #refs de citeproc y los divs refs-<id> que haya.
  local refs
  local propios = {}
  doc:walk{
    Div = function (div)
      if div.identifier == 'refs' then
        refs = refs or div
      elseif div.identifier:match('^refs%-') then
        propios[div.identifier] = true
      end
    end,
  }
  if not refs then return nil end

  -- Reparto de las entradas.
  local resto
  for _, g in ipairs(grupos) do
    if not g.miembros then resto = g; break end
  end
  local sin_grupo = pandoc.Blocks{}
  for _, bloque in ipairs(refs.content) do
    if es_entrada(bloque) then
      local clave = bloque.identifier:sub(5)
      local destino = resto
      for _, g in ipairs(grupos) do
        if g.miembros and g.miembros[clave] then destino = g; break end
      end
      if destino then destino.entradas:insert(bloque) else sin_grupo:insert(bloque) end
    end
  end
  if #sin_grupo > 0 then
    local claves_sueltas = sin_grupo:map(function (b) return b.identifier:sub(5) end)
    avisar('sin grupo, se dejan al final: ' .. table.concat(claves_sueltas, ', '))
  end

  -- Grupos que van en un div propio, por su id.
  local en_propio = {}
  for _, g in ipairs(grupos) do
    if g.id and propios['refs-' .. g.id] then en_propio['refs-' .. g.id] = g end
  end

  -- #refs reconstruido: su contenido inicial, los grupos generados y lo
  -- que no tiene grupo. `previo` es el bloque anterior a #refs.
  local function reconstruir (previo)
    local inicial = refs.content:filter(function (b) return not es_entrada(b) end)
    local nivel = 0
    for _, b in ipairs(inicial) do
      if b.t == 'Header' then nivel = b.level end
    end
    if nivel == 0 and previo and previo.t == 'Header' then nivel = previo.level end
    local res = pandoc.Blocks(inicial)
    for n, g in ipairs(grupos) do
      local propio = g.id and en_propio['refs-' .. g.id]
      if not propio and #g.entradas > 0 then
        res:insert(pandoc.Header(nivel + 1, g.titulo, pandoc.Attr('', {'unnumbered'})))
        res:insert(pandoc.Div(g.entradas, atributos(refs, 'refs-' .. (g.id or n))))
      end
    end
    if #sin_grupo > 0 then
      res:insert(pandoc.Div(sin_grupo, atributos(refs, 'refs')))
    end
    return res
  end

  -- Segundo recorrido: sustituir #refs y llenar los divs propios.
  return doc:walk{
    Blocks = function (bloques)
      local res = pandoc.Blocks{}
      for _, b in ipairs(bloques) do
        if b.t == 'Div' and b.identifier == 'refs' then
          local nuevo = reconstruir(res[#res])
          if #nuevo == 0 and #res > 0 and res[#res].t == 'Header'
             and res[#res].identifier == 'bibliography' then
            res:remove(#res)   -- el encabezado de citeproc, sin nada debajo
          end
          res:extend(nuevo)
        elseif b.t == 'Div' and en_propio[b.identifier] then
          local g = en_propio[b.identifier]
          local attr = atributos(refs, b.identifier)
          for _, c in ipairs(b.classes) do
            if not attr.classes:includes(c) then attr.classes:insert(c) end
          end
          for k, v in pairs(b.attributes) do attr.attributes[k] = v end
          res:insert(pandoc.Div(b.content .. g.entradas, attr))
        else
          res:insert(b)
        end
      end
      return res
    end,
  }
end
