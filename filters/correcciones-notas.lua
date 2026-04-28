-- correcciones-notas.lua
-- Correcciones tipográficas dentro de notas al pie.
--
-- 1. "párr." → "§"
--    Sustituye el abreviado castellano de párrafo por el símbolo bibliográfico.
--
-- 2. Semirraya → guion en rangos numéricos tras §.
--    Después de §, las semirrayas (–) que separan rangos de páginas o
--    párrafos se normalizan a guion simple para seguir la convención
--    tipográfica habitual en referencias académicas.
--    Ejemplo: § 12–15 → § 12-15.
--
-- Las dos correcciones comparten el mismo recorrido de inlines y el estado
-- "after_section", por lo que se procesan en un único pase.

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
