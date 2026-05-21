--[[
correcciones-notas – Correcciones tipográficas dentro de notas al pie.

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

1. "párr." → "§"
   Sustituye el abreviado castellano de párrafo por el símbolo bibliográfico.

2. Semirraya → guion en rangos numéricos tras §.
   Después de §, las semirrayas (–) que separan rangos de páginas o
   párrafos se normalizan a guion simple para seguir la convención
   tipográfica habitual en referencias académicas.
   Ejemplo: § 12–15 → § 12-15.

Las dos correcciones comparten el mismo recorrido de inlines y el estado
"after_section", por lo que se procesan en un único pase.

]]

local function fix_inlines(inlines)
  -- Paso 1: "párr." → "§"
  for _, el in ipairs(inlines) do
    if el.t == "Str" and el.text == "párr." then el.text = "§" end
  end

  -- Paso 2: semirraya → guion en rangos tras §
  local state = "normal"
  for _, el in ipairs(inlines) do
    if el.t == "Space" or el.t == "SoftBreak" then
      -- sin cambio de estado
    elseif el.t == "Str" then
      if state == "after_section" then
        el.text = el.text:gsub("([%a%d%.]+)–(%d)", "%1-%2")
        if not el.text:match("[%a%d%.]$") and el.text ~= "y" and el.text ~= "and" then
          state = "normal"
        end
      end
      if el.text:match("§") then state = "after_section"
      elseif state ~= "after_section" then state = "normal" end
    else
      state = "normal"
    end
  end
end

local function Note(el)
  for _, block in ipairs(el.content) do
    if block.t == "Para" then fix_inlines(block.content) end
  end
  return el
end

return {
  { Note = Note }
}
