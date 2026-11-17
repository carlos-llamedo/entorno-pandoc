--[[
ajustes-citeproc – Ajustes al resultado de citeproc.

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

-- Debe ir después de citeproc. Cada ajuste actúa
-- sobre el texto de las citas que ha generado citeproc.
--
-- Rangos de los localizadores. Citeproc imprime los rangos de los
-- localizadores que no son de páginas (párrafo, sección, capítulo…) con
-- semirraya, sin consultar al locale ni a lo escrito, y los de páginas con
-- el `page-range-delimiter` del locale (`formatPageRange` y `pageRange` en
-- Citeproc/Eval.hs). Este ajuste pone entre las dos cifras de cada rango
-- el signo que el autor escribió en el localizador, guion o semirraya;
-- lo demás (el término, la abreviatura del rango) sigue siendo de citeproc.

local SEMIRRAYA = '\u{2013}'
local MARCA = '\1'
local RANGO = '(%w+)([%-\1])(%w+)'

local function marcar (texto) return (texto:gsub(SEMIRRAYA, MARCA)) end
local function desmarcar (texto) return (texto:gsub(MARCA, SEMIRRAYA)) end

-- Una cifra es abreviatura de la otra («28» de «328») o la misma.
local function compatibles (x, y)
  return x:sub(-#y) == y or y:sub(-#x) == x
end

-- Rangos escritos en los sufijos de las citas: {inicio, fin, signo}.
local function rangos_escritos (citations)
  local res = {}
  for _, c in ipairs(citations) do
    local sufijo = marcar(pandoc.utils.stringify(c.suffix))
    sufijo = sufijo:gsub('(%w)%s*([%-\1])%s*(%w)', '%1%2%3')
    for a, signo, b in sufijo:gmatch(RANGO) do
      res[#res + 1] = {a, b, signo}
    end
  end
  return res
end

local function signo_escrito (escritos, a, b)
  for _, r in ipairs(escritos) do
    if r[1] == a and compatibles(r[2], b) then return r[3] end
  end
end

function Cite (cite)
  local escritos = rangos_escritos(cite.citations)
  if #escritos == 0 then return nil end
  cite.content = cite.content:walk{
    Str = function (s)
      local texto = marcar(s.text):gsub(RANGO, function (a, signo, b)
        local escrito = signo_escrito(escritos, a, b)
        if escrito and escrito ~= signo then return a .. escrito .. b end
      end)
      texto = desmarcar(texto)
      if texto ~= s.text then return pandoc.Str(texto) end
    end,
  }
  return cite
end
