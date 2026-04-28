-- fusionar-citas.lua
-- Fusiona BlockQuotes consecutivos en un único entorno quoting de LaTeX.
--
-- Pandoc modela la diferencia entre:
--
--   > Párrafo uno        →  línea en blanco DENTRO del ">": un solo BlockQuote
--   >                        con dos Para en su interior.
--   > Párrafo dos
--
--   > Párrafo uno        →  línea en blanco FUERA del ">": dos BlockQuote
--                            independientes, uno tras otro en la lista de bloques.
--   > Párrafo dos
--
-- En el primer caso pandoc ya entrega un único BlockQuote con dos párrafos;
-- convert_blockquote lo vuelca directamente como un entorno quoting con dos
-- párrafos, y el segundo lleva sangría de primera línea (comportamiento normal
-- del entorno quoting tras \par).
--
-- En el segundo caso pandoc entrega dos BlockQuote consecutivos. Aquí se fusionan
-- en un único entorno quoting con \quotingbreak entre ellos: la macro \quotingbreak
-- cierra el párrafo, inserta el espaciado entre citas y suprime la sangría del
-- párrafo siguiente, imitando el comportamiento de inicio de cita (sin sangría
-- en primera línea, norma Chicago).
--
-- \quotingbreak debe definirse en la plantilla LaTeX:
--   \newcommand{\quotingbreak}{\par\noindent}

local function convert_blockquote(block)
  local inner = pandoc.write(pandoc.Pandoc(block.content), "latex")
  return pandoc.RawBlock("latex", "\\begin{quoting}\n" .. inner .. "\\end{quoting}")
end

local function Blocks(blocks)
  local result = pandoc.Blocks({})
  local i = 1
  while i <= #blocks do
    local bl = blocks[i]
    if bl.t == "BlockQuote" then
      local group = {bl}
      local j = i + 1
      while j <= #blocks and blocks[j].t == "BlockQuote" do
        group[#group+1] = blocks[j]
        j = j + 1
      end
      if #group == 1 then
        result:insert(convert_blockquote(bl))
      else
        local parts = {}
        for _, bq in ipairs(group) do
          parts[#parts+1] = pandoc.write(pandoc.Pandoc(bq.content), "latex")
        end
        local inner = table.concat(parts, "\n\\quotingbreak\n")
        result:insert(pandoc.RawBlock("latex",
          "\\begin{quoting}\n" .. inner .. "\\end{quoting}"))
      end
      i = j
    else
      result:insert(bl)
      i = i + 1
    end
  end
  return result
end

return {
  { Blocks = Blocks }
}
