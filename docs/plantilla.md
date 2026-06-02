# Variables de la plantilla `memoir.tex`

Referencia completa de todas las variables YAML que acepta la plantilla. Las variables marcadas como `pandoc` son estándar y están documentadas en el manual de Pandoc; las marcadas como `propio` son específicas de esta plantilla.

* * *

## Estándar del PDF

| Variable | Tipo | Origen |
|---|---|---|
| `pdfstandard` | mapa | pandoc |
| `pdfstandard.version` | string | pandoc |
| `pdfstandard.standards` | lista | pandoc |
| `pdfstandard.tagging` | booleano | pandoc |

Si `pdfstandard` está declarado, la plantilla emite `\DocumentMetadata{…}` con los valores correspondientes. El idioma del PDF se toma de `lang`; si no está declarado, se aplica `es-ES`. `xmp=true` se activa siempre que el bloque esté presente. `pdfstandard.version` acepta valores como `1.7` o `2.0`; `pdfstandard.standards` acepta identificadores de conformidad como `a-4f` (PDF/A con fuentes embebidas), `ua-2` (accesibilidad) o `x-4` (PDF/X). Para accesibilidad académica la combinación habitual es `a-4f` con `tagging: true`.

* * *

## Clase y página

| Variable | Tipo | Defecto | Origen |
|---|---|---|---|
| `fontsize` | string | `12pt` | pandoc |
| `papersize` | string | `a4paper` | pandoc |
| `classoption` | lista | `twoside, openany` | pandoc |
| `geometry` | lista | véase abajo | pandoc |

Los valores habituales de `fontsize` son `10pt`, `11pt` y `12pt`. `papersize` acepta los nombres que reconoce la clase `book`: `a4paper` (defecto), `letterpaper` (carta estadounidense, 8,5 × 11 in), `a5paper`, `b5paper`. `classoption` admite cualquier opción de la clase; los valores más relevantes son `twoside` / `oneside` para documentos de una o dos caras, y `openright` / `openany` para controlar en qué página se abre cada capítulo.

Si `geometry` no está declarado, la plantilla aplica márgenes de `3cm` en los cuatro lados, con `headheight = 14pt`, `headsep` igual a la mitad del margen superior menos la altura del encabezado, y `footskip = 1.5cm`. Para sobrescribir, hay que declarar siempre `headheight`, `headsep` y `footskip` junto con los márgenes para evitar advertencias de fancyhdr. Ejemplo con márgenes anglosajones de una pulgada:

```yaml
geometry:
  - top=1in
  - bottom=1in
  - left=1in
  - right=1in
  - headheight=14pt
  - headsep=0.5in - 14pt
  - footskip=0.5in
```

* * *

## Fuentes

Las fuentes toman el nombre del sistema tal como lo reconoce fontspec. Las variantes (`Bold`, `Italic`, `BoldItalic`) se resuelven automáticamente desde los metadatos OpenType. Si una fuente usa nombres no estándar (p. ej., `Semibold` en lugar de `Bold`), declararlos en las opciones correspondientes.

| Variable | Tipo | Defecto | Origen |
|---|---|---|---|
| `mainfont` | string | `Arno Pro` | pandoc |
| `mainfontoptions` | lista | — | pandoc |
| `sansfont` | string | `Myriad Pro` | pandoc |
| `sansfontoptions` | lista | — | pandoc |
| `monofont` | string | `Source Code Pro` | pandoc |
| `monofontoptions` | lista | — | pandoc |
| `mathfont` | string | `IBM Plex Math` | pandoc |
| `mathfontoptions` | lista | — | pandoc |
| `titlefont` | string | — | propio |
| `titlefontoptions` | lista | — | propio |
| `titlesans` | booleano | — | propio |
| `bodysans` | booleano | — | propio |
| `microtypeoptions` | lista | `protrusion=true` | pandoc |

`titlefont` define una familia tipográfica alternativa para títulos, encabezados, folios e índice. Permite combinar dos serifs distintas (p. ej., `titlefont: Bodoni MT` con `mainfont: Arno Pro`). Tiene prioridad sobre `titlesans`.

`titlesans` activa la familia sans-serif en esos mismos elementos. Si ninguna de las dos está declarada, los títulos van en la misma familia que el cuerpo.

`bodysans` conmuta la familia por defecto del documento entero a sans-serif.

Los fallbacks de glifos están definidos en el preámbulo: `Source Serif 4` para la serif y `Source Sans 3` para la sans. Para modificarlos usar `header-includes`.

`microtypeoptions` permite pasar opciones al paquete `microtype`. Por defecto solo se activa la protrusión.

Ejemplo con variantes no estándar y ligaduras adicionales:

```yaml
mainfont: Warnock Pro
mainfontoptions:
  - BoldFont=Warnock Pro Semibold
  - BoldItalicFont=Warnock Pro Semibold Italic
  - Ligatures=TeX              # ligaduras estándar (ff, fi, fl…); declarar primero
  - Ligatures=Historic         # ligaduras históricas (ſt, ſi…)
  - Ligatures=Discretionary    # ligaduras discrecionales (Th, ct…)
```

Las opciones de ligaduras deben declararse como entradas separadas de la lista; `Ligatures=TeX,Discretionary` en una sola cadena no funciona con fontspec. `Ligatures=TeX` activa las ligaduras estándar de metal (ff, fi, fl, ffi, ffl) y es el punto de partida habitual. `Ligatures=Discretionary` añade las que el diseñador marcó como opcionales (Th, ct, st…) y depende de cada fuente; es una adición razonable para texto académico. `Ligatures=Historic` activa formas con s larga (ſt, ſi…) y solo tiene sentido en ediciones de fuentes antiguas o reproducciones paleográficas: declarar las tres a la vez es poco habitual. Otras opciones OpenType frecuentes son `Numbers=OldStyle` para cifras elzevirianos, `Numbers=Lining` para cifras de caja alta, y `RawFeature=+hist` para activar características OpenType arbitrarias.

* * *

## Tipografía del cuerpo

| Variable | Tipo | Defecto | Origen |
|---|---|---|---|
| `linestretch` | número | `1.5` | pandoc |
| `parindent` | medida LaTeX | `1cm` | propio |
| `noindent` | booleano | — | propio |
| `smallsize` | comando LaTeX | `\normalsize` | propio |
| `cancel` | booleano | — | pandoc |
| `strikeout` | booleano | — | pandoc |

`parindent` controla la sangría de primera línea y actúa como medida central de la plantilla: el margen izquierdo del primer nivel de listas, el cuelgue de la bibliografía y el sangrado de las notas al pie son proporcionales a este valor. Acepta cualquier unidad LaTeX; los valores más habituales:

```yaml
parindent: 1cm     # defecto
parindent: 0.5in   # sangría de primera línea anglosajona
parindent: 1.27cm  # equivalente en centímetros a la anglosajona
parindent: 2em     # relativo al cuerpo de texto; escala con el tamaño de fuente
```

Por defecto la plantilla usa sangría de primera línea sin espacio entre párrafos (convención tipográfica europea). `noindent: true` invierte el comportamiento: elimina la sangría y añade espacio entre párrafos (`0.25\baselineskip`). Nota: `\ParIndent` conserva su valor en ambos modos y sigue usándose para listas, notas al pie e índice.

`smallsize` controla el tamaño tipográfico de los elementos secundarios: notas al pie, citas exentas, pies de foto, encabezados y pies de página y bloques de código. Acepta cualquier comando de tamaño LaTeX estándar. Con un cuerpo de `12pt` los tamaños aproximados son:

```yaml
smallsize: \tiny         # 6 pt
smallsize: \scriptsize   # 8 pt
smallsize: \footnotesize # 10 pt
smallsize: \small        # 10.95 pt
smallsize: \normalsize   # 12 pt — defecto; uniforme con el cuerpo
smallsize: \large        # 14.4 pt — desaconsejado para elementos secundarios
```

`cancel` carga el paquete `cancel` para notación matemática con tachado. `strikeout` carga `luacolor` y `lua-ul` (con la opción `soul`) para tachado en texto corriente; lo activa pandoc automáticamente cuando el documento contiene texto tachado.

* * *

## Numeración y estructura

| Variable | Tipo | Defecto | Origen |
|---|---|---|---|
| `numbersections` | booleano | — | pandoc |
| `secnumdepth` | entero | `5` | pandoc |
| `toc` | booleano | — | pandoc |
| `toc-title` | string | `Índice` | pandoc |
| `toc-depth` | entero | `2` | pandoc |
| `lof` | booleano | — | pandoc |
| `lot` | booleano | — | pandoc |

* * *

## Encabezados y folios

Por defecto el encabezado verso lleva el nombre del autor en cursiva (o el título si no hay autor declarado) y el recto lleva el título del capítulo activo en cursiva. El folio va en el exterior superior de cada página.

| Variable | Tipo | Efecto | Origen |
|---|---|---|---|
| `headscaps` | booleano | Encabezados en versalitas (*serif*) o mayúsculas (*sans*) en lugar de cursiva | propio |
| `folioonly` | booleano | Solo folio, sin texto de encabezado | propio |
| `headrule` | booleano | Filete bajo el encabezado | propio |
| `nofolio` | booleano | Suprime el folio en páginas de inicio de capítulo | propio |

* * *

## Páginas preliminares y paratexto

| Variable | Tipo | Origen |
|---|---|---|
| `title` | string | pandoc |
| `title-meta` | string | pandoc |
| `subtitle` | string | pandoc |
| `author` | string o lista | pandoc |
| `author-meta` | string | pandoc |
| `date` | string | pandoc |
| `thanks` | string | pandoc |
| `abstract` | string | pandoc |
| `keywords` | lista | pandoc |
| `maketitle` | booleano | propio |
| `dedication` | string | propio |
| `epigraphtext` | string | propio |
| `epigraphauthor` | string | propio |
| `epigraphwork` | string | propio |

`title`, `subtitle` y `author` se usan tanto para los metadatos del PDF como para la portada cuando `maketitle: true`. En los metadatos, el subtítulo se añade al título separado por punto y espacio. Para un valor distinto en los metadatos (sin formato LaTeX, sin notas al pie), declarar `title-meta` y `author-meta` explícitamente; en ese caso `subtitle` no se añade al `pdftitle` automáticamente.

`maketitle` activa la portada. Si no está declarado, el título existe como metadato pero no se imprime. Esto permite titular un documento sin generar una portada.

`abstract` activa una página de resumen con el encabezado «Resumen» en negrita. Si `keywords` está declarado, las palabras clave se añaden al final con el encabezado «Palabras clave:».

`thanks` genera un capítulo sin numerar de agradecimientos, situado después de los índices y antes del cuerpo principal.

`dedication` genera una página de dedicatoria: texto en cursiva, alineado a la derecha en la mitad inferior.

`epigraphtext` genera una página de epígrafe en la mitad inferior derecha. Se complementa con `epigraphauthor` (en versalitas) y `epigraphwork` (en cursiva). Los tres campos son independientes: pueden combinarse en cualquier proporción.

* * *

## Notas al pie

| Variable | Tipo | Efecto | Origen |
|---|---|---|---|
| `footinline` | booleano | Número en línea (seguido de punto) en lugar de superíndice | propio |
| `footrule` | booleano | Filete separador en todas las páginas | propio |
| `nofootrule` | booleano | Suprime el filete incluso en páginas de continuación | propio |

Por defecto el filete aparece solo en páginas donde una nota continúa desde la página anterior (comportamiento de `norule` + `splitrule` de `footmisc`). `footrule: true` activa el filete en todas las páginas (`splitrule` solo). `nofootrule: true` lo suprime por completo (`norule` solo).

La sangría de las notas al pie sigue el valor de `parindent` cuando el documento usa sangría de primera línea. En modo `noindent` las notas van sin sangría.

Hay una interacción conocida entre `pandoc-crossref` y `multibib.lua` que obliga al contador de numeración de notas al pie a reiniciarse en cada capítulo. Si se quiere evitar este comportamiento, hay que añadir un bloque `header-includes` en el YAML del documento:

```yaml
header-includes:
  - |
      \usepackage{chngcntr}
      \counterwithout{footnote}{chapter}
```

* * *

## Citas exentas

| Variable | Tipo | Efecto | Origen |
|---|---|---|---|
| `quotesymmetric` | booleano | Mismo sangrado derecho e izquierdo (por defecto solo izquierdo) | propio |

Las citas exentas van en el tamaño `\textsmall` y con el sangrado izquierdo igual a `\parindent`. Por defecto el margen derecho es cero; `quotesymmetric: true` lo iguala al izquierdo.

* * *

## Numeración romana

Por defecto los números romanos de las páginas preliminares van en versalitas (o en mayúsculas si la fuente que les aplica es *sans*).

| Variable | Tipo | Efecto | Origen |
|---|---|---|---|
| `romansmall` | booleano | Romanitos | propio |

* * *

## Hipervínculos

| Variable | Tipo | Defecto | Origen |
|---|---|---|---|
| `colorlinks` | booleano | — | pandoc |
| `linkcolor` | color xcolor | `purpleblue` (RGB 72, 61, 139) | pandoc |
| `urlcolor` | color xcolor | `purpleblue` | pandoc |
| `citecolor` | color xcolor | `purpleblue` | pandoc |
| `filecolor` | color xcolor | `black` | pandoc |
| `toccolor` | color xcolor | `black` | pandoc |
| `boxlinks` | booleano | — | pandoc |
| `links-as-notes` | booleano | — | pandoc |
| `urlstyle` | string | `same` | pandoc |
| `verbatim-in-note` | booleano | — | pandoc |
| `lang` | string | `es-ES` | pandoc |
| `subject` | string | — | pandoc |
| `hyperrefoptions` | lista | — | pandoc |

Si `colorlinks` no está declarado y `boxlinks` tampoco, los enlaces se ocultan con `hidelinks` (sin color ni recuadro, pero siguen siendo clicables). `boxlinks: true` activa los recuadros de hyperref sin color.

Los colores por defecto son `purpleblue` (RGB 72, 61, 139). También está definido en la plantilla `linkblue` (RGB 0, 70, 150) como alternativa. Los superíndices de nota al pie van siempre en negro, independientemente de `linkcolor`.

El color de los enlaces del índice se controla mediante `toccolor`; si no está declarado, los enlaces del índice van en negro.

`urlstyle` acepta: `tt` (monoespacio), `rm` (serif), `sf` (sans), `same` (igual al contexto). Por defecto las URL van en la misma fuente que el texto circundante.

`lang` acepta etiquetas BCP 47. Los valores más habituales en este flujo de trabajo son `es-ES` (español de España, defecto), `en-GB`, `en-US` y `fr-FR`. El valor afecta a los metadatos del PDF, a la configuración de hyperref y, a través de babel, a la silabación.

`verbatim-in-note` activa `\VerbatimFootnotes` de `fancyvrb` para permitir verbatim dentro de notas al pie.

`hyperrefoptions` pasa opciones adicionales al paquete `hyperref` mediante `\PassOptionsToPackage`.

* * *

## Bibliografía

| Variable | Tipo | Efecto | Origen |
|---|---|---|---|
| `nocite-ids` | lista | Incluye referencias en la bibliografía sin citarlas en el texto | pandoc |

`nocite-ids` se coloca en el `\backmatter`, antes de los elementos finales. Equivale a `\nocite{clave1, clave2, …}`.

* * *

## Extensibilidad

| Variable | Tipo | Origen |
|---|---|---|
| `header-includes` | bloque raw LaTeX | pandoc |
| `include-before` | bloque raw LaTeX | pandoc |
| `include-after` | bloque raw LaTeX | pandoc |

`header-includes` se inyecta al final del preámbulo, antes de `\begin{document}`. Es el mecanismo correcto para cargar paquetes adicionales o redefinir comportamientos sin modificar la plantilla.

`include-before` se inserta en el `\frontmatter`, después de los índices y los agradecimientos, antes del `\mainmatter`. `include-after` se inserta en el `\backmatter`, después de `nocite-ids`.
