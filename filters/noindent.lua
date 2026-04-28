-- noindent.lua - Convierte divs con clase "noindent" en un grupo LaTeX sin sangría.
--
-- Sintaxis en el Markdown:
--   ::: {.noindent}
--   Párrafo sin sangría de primera línea.
--   :::
--
-- Se usa {\parindent0pt … } en lugar de \noindent porque \noindent solo 
-- actúa sobre el párrafo inmediatamente siguiente.
--
-- Si el div contuviera varios párrafos, 
-- los sucesivos recuperarían la sangría normal,lo que 
-- produciría un comportamiento inesperado.
--
-- Inspirado en el trabajo de Thomas J. Duck:
-- https://github.com/tomduck/pandoc-latex-extensions/blob/master/pandoclatexextensions/plugins/noindent.py

function Div(el)
  if el.classes:includes("noindent") then
    return {
      pandoc.RawBlock("latex", "{\\parindent0pt"),
      table.unpack(el.content),
      pandoc.RawBlock("latex", "}")
    }
  end
end
