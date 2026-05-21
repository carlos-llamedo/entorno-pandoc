--[[
noindent – Convierte divs con clase "noindent" en un grupo LaTeX sin sangría.

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

Sintaxis en el Markdown:
  ::: {.noindent}
  Párrafo sin sangría de primera línea.
  :::

Se usa {\parindent0pt … } en lugar de \noindent porque \noindent solo 
actúa sobre el párrafo inmediatamente siguiente.

Si el div contuviera varios párrafos, 
los sucesivos recuperarían la sangría normal,lo que 
produciría un comportamiento inesperado.

Inspirado en el trabajo de Thomas J. Duck:
https://github.com/tomduck/pandoc-latex-extensions/blob/master/pandoclatexextensions/plugins/noindent.py

]]

function Div(el)
  if el.classes:includes("noindent") then
    return {
      pandoc.RawBlock("latex", "{\\parindent0pt"),
      table.unpack(el.content),
      pandoc.RawBlock("latex", "}")
    }
  end
end
