--[[
suprimir-citas – Quita las citas del texto y las deja solo en la bibliografía.

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

-- Con `suppress-citations: true`, quita las citas del texto y las pasa a
-- `nocite`, para que solo aparezcan en la bibliografía. Debe ir antes de
-- citeproc.
local ocultas = {}

local function Inlines (inls)
  local res = pandoc.Inlines{}
  for _, el in ipairs(inls) do
    if el.t == 'Cite' then
      for _, c in ipairs(el.citations) do ocultas[#ocultas + 1] = c end
      -- quita el espacio que precedía a la cita
      if #res > 0 and (res[#res].t == 'Space' or res[#res].t == 'SoftBreak') then
        res:remove(#res)
      end
    elseif el.t == 'Note' and pandoc.utils.stringify(el.content) == '' then
      -- nota que solo contenía la cita: se quita entera
    else
      res:insert(el)
    end
  end
  return res
end

function Pandoc (doc)
  if not doc.meta['suppress-citations'] then return nil end
  doc = doc:walk{Inlines = Inlines}
  if #ocultas > 0 then
    local nocite = doc.meta.nocite
    local inls = pandoc.Inlines{}
    if nocite then inls:extend(pandoc.utils.type(nocite) == 'Inlines' and nocite
      or pandoc.utils.blocks_to_inlines(nocite)) end
    inls:insert(pandoc.Cite({}, ocultas))
    doc.meta.nocite = pandoc.MetaInlines(inls)
  end
  return doc
end
