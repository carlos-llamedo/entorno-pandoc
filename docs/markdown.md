---
author: Carlos Llamedo
date: 2026-07
---

# El Markdown de Pandoc

El Markdown de Pandoc es un superconjunto del original de Gruber, ampliado con extensiones propias que cubren necesidades de escritura académica (notas al pie, citas, tablas, bloques de metadatos, LaTeX crudo).

Cada extensión puede activarse o desactivarse por separado, anteponiendo `+` o `-` al nombre tras el formato (`markdown+raw_tex`, por ejemplo). El argumento `--list-extensions[=FORMATO]` lista cuáles están disponibles para cada formato, precedidas de `+` o `-` según estén activas por defecto; sin `FORMATO`, se listan las del Markdown de Pandoc.

Lo que sigue documenta las extensiones activas en el **lector** de Markdown en este flujo de trabajo, no las del escritor.

## Extensiones predeterminadas

Esta configuración mantiene las activas por defecto, que se listan con `+` como prefijo:

- `all_symbols_escapable`. Permite que todos los caracteres se escapen precediéndolos de `\`, tratándose de manera literal. La norma original de Markdown solo permite escapar los caracteres ``\`*_{}[]()>#+-.!``.
- `auto_identifiers`. En cada sección del documento se puede declarar un identificador del mismo añadiendo `{#identificador}` tras su título, y se utilizará para generar enlaces a las secciones en el índice y para hacer una remisión en el propio texto. Esta extensión asigna un identificador automáticamente a aquellos títulos sin uno explícitamente declarado. Se elimina todo formato, pies de página y caracteres no alfanuméricos (excepto puntos, guiones y guiones bajos); los espacios se convierten en guiones y todo se pone en minúscula. Un título como «*Quo vadis?* Viajes y distancias en el Imperio» se convierte en `#quo-vadis-viajes-y-distancias-en-el-imperio`. En un documento largo y formal, aún así, es recomendable declarar los identificadores explícitamente, puesto que si los títulos cambian, los enlaces que se apoyen en identificadores implícitos generados automáticamente se romperán.
- `backtick_code_blocks`. Permite delimitar bloques de código con una línea de tres o más comillas inversas (` ``` `) en lugar de sangrado. La línea de cierre debe tener al menos tantas comillas como la de apertura. Es la variante preferible a `fenced_code_blocks` cuando el código puede contener virgulillas (`~~~`), y es la que se usa en la práctica en cualquier editor Markdown moderno.
- `blank_before_blockquote`. Exige una línea en blanco antes del inicio de una cita en bloque (líneas que empiezan por `>`) para que se reconozca como tal.
- `blank_before_header`. Exige una línea en blanco antes de un encabezado ATX (`#`, `##`, etc.) para que se reconozca como tal.
- `bracketed_spans`. Permite crear un *span* —un fragmento de texto en línea al que se le puede asignar atributos— encerrando el texto entre corchetes y añadiendo los atributos entre llaves a continuación: `[texto]{.clase #identificador atributo=valor}`. Es el mecanismo, por ejemplo, para marcar un fragmento en versalitas (`[texto]{.smallcaps}`) o en un idioma distinto al del documento (`[texto]{lang=en-GB}`).
- `citations`. Activa la sintaxis de citas bibliográficas de Pandoc, `[@clave]`, que `citeproc` resuelve durante la compilación. Es la extensión sobre la que se apoya toda la gestión automática de bibliografía.
- `definition_lists`. Permite crear listas de definición, donde un término va seguido de una o más definiciones marcadas con `:` en la línea siguiente:

  ```
  Término
  : Definición del término.
  ```

- `escaped_line_breaks`. Permite forzar un salto de línea (sin crear un párrafo nuevo) terminando la línea con una barra invertida.
- `example_lists`. Permite crear listas numeradas cuyos elementos se pueden referenciar en el propio texto. Cada elemento se marca con `(@etiqueta)`, y la remisión se hace con `(@etiqueta)` en cualquier otro punto del documento; Pandoc sustituye ambas apariciones por el número correlativo correspondiente.
- `fancy_lists`. Permite en listas ordenadas usar números romanos o letras como marcadores y paréntesis (los dos o solo el decierre) como separadores (`a)`, `(B)`, `i.`).
- `fenced_code_attributes`. Permite añadir atributos a un bloque de código delimitado (lenguaje para resaltado de sintaxis, identificador, clases, numeración de líneas) entre llaves tras las comillas de apertura: ` ```{#ejemplo .lua .numberLines startFrom="100"} `.
- `fenced_code_blocks`. Permite delimitar bloques de código con una línea de tres o más virgulillas (`~~~`) en lugar de sangrado.
- `fenced_divs`. Permite crear un *div* —un bloque de contenido al que se le puede asignar atributos— delimitándolo con líneas de al menos tres dos puntos (`:::`) y declarando los atributos entre llaves tras la primera. Puede haber un espacio entre los dos puntos y las llaves o no.
- `footnotes`. Activa la sintaxis de notas al pie de Pandoc: una llamada numerada entre corchetes en el texto (`[^1]`) y su contenido declarado en cualquier punto del documento (`[^1]: Texto de la nota.`). Por legibilidad del texto, lo mejor sería que las notas al pie se pusiesen inmediatamente después del párrafo en el que se introduce la llamada.
- `grid_tables`. Permite crear tablas dibujando manualmente los bordes de celdas y filas con guiones, signos igual y barras verticales. Es la sintaxis de tabla más verbosa, pero la única capaz de representar celdas con contenido de varios párrafos o bloques complejos sin recurrir a LaTeX crudo.
- `header_attributes`. Permite declarar atributos en un encabezado (identificador, clases, pares clave-valor) entre llaves tras el texto del título: `## Título {#id .clase}`. Es el mecanismo para declarar identificadores explícitos de sección, recomendado frente a los generados automáticamente por `auto_identifiers` en documentos largos.
- `implicit_figures`. Convierte un párrafo compuesto exclusivamente por una imagen en una figura numerada con pie, usando el texto alternativo de la imagen como pie de figura.
- `implicit_header_references`. Permite crear un enlace a una sección usando su texto literal como referencia, sin necesidad de conocer el identificador generado: `[Texto del título]` enlaza a la sección «Texto del título» si existe.
- `inline_code_attributes`. Permite añadir atributos a un fragmento de código en línea de la misma manera que a un bloque delimitado: `` `código`{.lua} ``.
- `inline_notes`. Permite declarar el contenido de una nota al pie directamente en el punto donde se referencia, sin una etiqueta ni una declaración separada: `^[Texto de la nota.]`.
- `intraword_underscores`. Impide que un guion bajo dentro de una palabra (sin espacios a los lados) se interprete como marca de énfasis, de modo que `nombre_de_variable` no se convierte en cursiva parcial.
- `latex_macros`. Hace que Pandoc interprete y expanda las macros de LaTeX declaradas con `\newcommand`, `\renewcommand` o `\def` en el propio documento Markdown, en lugar de pasarlas sin más al escritor de salida.
- `line_blocks`. Permite marcar líneas cuyos saltos y la sangría inicial deben conservarse literalmente, anteponiendo una barra vertical y un espacio a cada una. Es la sintaxis pensada para versos o direcciones postales.
- `link_attributes`. Permite añadir atributos a un enlace o a una imagen entre llaves a continuación de su sintaxis habitual, incluyendo dimensiones (`width`, `height`) en el caso de las imágenes.
- `markdown_in_html_blocks`. Permite que el contenido de un bloque HTML crudo dentro del documento se procese además como Markdown, en lugar de tratarse como texto literal.
- `multiline_tables`. Permite crear tablas cuyas celdas ocupan varias líneas de texto envuelto, delimitadas por líneas de guiones sin necesidad de marcar los bordes de cada celda individualmente, a diferencia de las tablas de rejilla.
- `native_divs`. Hace que los *divs* HTML crudos del documento se conserven como elementos nativos de Pandoc en el árbol de sintaxis abstracta, en lugar de convertirse en bloques de HTML sin analizar. Esto permite que filtros posteriores puedan inspeccionar y transformar su contenido.
- `native_spans`. Análogo a `native_divs` para los *spans* HTML crudos.
- `pandoc_title_block`. Permite declarar título, autor y fecha al principio del documento con una sintaxis específica de tres líneas iniciadas por `%`, previa al bloque de metadatos YAML.
- `pipe_tables`. Permite crear tablas delimitando columnas con barras verticales y la fila de encabezado de las demás con una línea de guiones. Es la sintaxis de tabla más extendida y la más legible en el archivo fuente sin renderizar.
- `raw_attribute`. Permite marcar un fragmento en línea o un bloque como contenido crudo de un formato de salida concreto, envolviéndolo entre acentos graves con el atributo `{=formato}`: `` `\textbf{texto}`{=latex} ``.
- `raw_html`. Permite que las etiquetas HTML sueltas dentro del documento Markdown se conserven como HTML crudo en el árbol de sintaxis abstracta, en lugar de tratarse como texto literal.
- `raw_tex`. Permite introducir bloques de código LaTeX crudo en el documento sin ninguna declaración particular.
- `shortcut_reference_links`. Pandoc implemente enlaces de referencia, donde se da un identificador al enlace y, en otro punto del documento, se asocia el identificador con la ruta del enlace. Esta extensión permite que si el texto del enlace coincide con la etiqueta de referencia, no haya que repetirlo.
- `simple_tables`. Permite crear tablas donde el ancho de cada columna se determina por la anchura de la fila de guiones bajo el encabezado, sin marcar los bordes de las celdas.
- `smart`. Convierte las comillas rectas en tipográficas, los guiones dobles y triples en semirraya y raya, y los puntos suspensivos en el carácter unicode correspondiente.
- `space_in_atx_header`. Exige un espacio entre las almohadillas de un encabezado ATX y su texto (`# Título`, no `#Título`) para que se reconozca como encabezado.
- `startnum`. Permite que una lista ordenada empiece a numerar a partir del valor declarado en su primer elemento, en lugar de siempre desde 1.
- `strikeout`. Permite marcar texto tachado encerrándolo entre virgulillas dobles: `~~texto~~`.
- `subscript`. Permite marcar subíndices encerrando el texto entre virgulillas: `~texto~`.
- `superscript`. Permite marcar superíndices encerrando el texto entre acentos circunflejos: `^texto^`.
- `task_lists`. Permite crear listas de tareas con casillas de verificación, marcando cada elemento con `[ ]` o `[x]` tras el marcador de lista.
- `table_captions`. Permite añadir un pie a una tabla mediante una línea que empieza por `:` o `Table:`, situada antes o después de la tabla.
- `tex_math_dollars`. Permite delimitar fórmulas matemáticas en TeX con signos de dólar: uno para matemáticas en línea (`$x^2$`), dos para matemáticas centradas en bloque (`$$x^2$$`).
- `yaml_metadata_block`. Permite declarar metadatos del documento —título, autor, fecha, y cualquier variable de plantilla o de filtro— en un bloque YAML delimitado por dos líneas que solo contengan `---`, al principio del documento.

## Extensiones activas no predeterminadas

- `rebase_relative_paths`. Reescribe las rutas de remisiones e imágenes para que sean relativas al directorio de trabajo.
