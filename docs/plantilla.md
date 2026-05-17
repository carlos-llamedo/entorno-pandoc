# Variables de la plantilla `memoir.tex`

Referencia completa de todas las variables YAML que acepta la plantilla. Las variables marcadas como **pandoc** son estándar y están documentadas en el manual de pandoc; las marcadas como **propio** son específicas de esta plantilla.

---

## Clase y página

| Variable | Tipo | Defecto | Origen |
|---|---|---|---|
| `fontsize` | string | `12pt` | pandoc |
| `papersize` | string | `a4paper` | pandoc |
| `classoption` | lista | `twoside` | pandoc |
| `geometry` | lista | véase abajo | pandoc |

Si `geometry` no está declarado, la plantilla aplica: superior e inferior `0.5in`, izquierdo y derecho `1in`, con `includeheadfoot`. Para sobrescribir parcial o totalmente:

```yaml
geometry:
  - top=2cm
  - left=3cm
  - right=2.5cm
  - bottom=2cm
```

---

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
| `titlefont` | string | — | propio |
| `titlefontoptions` | lista | — | propio |
| `titlesans` | booleano | — | propio |
| `bodysans` | booleano | — | propio |

`titlefont` define una familia tipográfica alternativa para títulos, encabezados, folios e índice. Permite combinar dos serifs distintas (p. ej., `titlefont: Bodoni MT` con `mainfont: Arno Pro`). Tiene prioridad sobre `titlesans`.

`titlesans` activa la familia sans-serif en esos mismos elementos. Si ninguna de las dos está declarada, los títulos van en la misma familia que el cuerpo.

`bodysans` conmuta la familia por defecto del documento entero a sans-serif.

Los fallbacks de glifos están definidos en el preámbulo: `Source Serif 4` para la serif y `Source Sans 3` para la sans. Para modificarlos usar `header-includes`.

Ejemplo con variantes no estándar:

```yaml
mainfont: Warnock Pro
mainfontoptions:
  - BoldFont=Warnock Pro Semibold
  - BoldItalicFont=Warnock Pro Semibold Italic
```

---

## Tipografía del cuerpo

| Variable | Tipo | Defecto | Origen |
|---|---|---|---|
| `linestretch` | número | `1.5` | pandoc |
| `parindent` | medida LaTeX | `0.5in` | propio |
| `noindent` | booleano | — | propio |
| `smallsize` | comando LaTeX | `\small` | propio |

`parindent` controla la sangría de primera línea y actúa como medida central de la plantilla: el margen izquierdo del primer nivel de listas, el cuelgue de la bibliografía y el sangrado de las notas al pie son proporcionales a este valor. Acepta cualquier unidad LaTeX: `0.5in`, `1.27cm`, `1cm`, `1em`.

Por defecto la plantilla usa sangría de primera línea sin espacio entre párrafos (convención tipográfica europea). `noindent: true` invierte el comportamiento: elimina la sangría y añade espacio entre párrafos (`0.5\baselineskip`). Nota: `\ParIndent` conserva su valor en ambos modos y sigue usándose para listas e índice.

`smallsize` controla el tamaño tipográfico de los elementos secundarios: notas al pie, citas exentas, captions y bloques de código. Acepta cualquier comando de tamaño LaTeX:

```yaml
smallsize: \small        # defecto — aprox. 10.95 pt con cuerpo a 12 pt
smallsize: \footnotesize # más pequeño
smallsize: \normalsize   # uniforme con el cuerpo (convención Chicago estricta)
```

---

## Numeración y estructura

| Variable | Tipo | Defecto | Origen |
|---|---|---|---|
| `numbersections` | booleano | — | pandoc |
| `secnumdepth` | entero | `5` | pandoc |
| `toc` | booleano | — | pandoc |
| `toc-title` | string | `Índice` | pandoc |
| `toc-depth` | entero | `3` | pandoc |
| `lof` | booleano | — | pandoc |
| `lot` | booleano | — | pandoc |

---

## Encabezados y folios

Por defecto el encabezado verso lleva el nombre del autor en cursiva y el recto lleva el título de sección activo en cursiva. El folio va en el exterior superior de cada página.

| Variable | Tipo | Efecto | Origen |
|---|---|---|---|
| `headscaps` | booleano | Encabezados en versalitas en lugar de cursiva | propio |
| `headtitlesec` | booleano | Verso: título del documento; recto: sección activa | propio |
| `headsecsec` | booleano | Ambas páginas: sección activa | propio |
| `folioonly` | booleano | Solo folio, sin texto de encabezado | propio |
| `authorrecto` | booleano | Autor en recto en lugar de verso | propio |
| `headrule` | booleano | Filete bajo el encabezado | propio |
| `nofolio` | booleano | Suprime el folio en páginas de inicio de capítulo | propio |

---

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
| `dedicatoria` | string | propio |
| `epigraphtext` | string | propio |
| `epigraphauthor` | string | propio |
| `epigraphwork` | string | propio |

`title` y `author` se usan tanto para los metadatos del PDF como para la portada cuando `maketitle: true`. Para un valor distinto en los metadatos (sin formato LaTeX, sin notas al pie), declarar `title-meta` y `author-meta` explícitamente.

`maketitle` activa la portada. Si no está declarado, el título existe como metadato pero no se imprime. Esto permite titular un documento en Zettlr o para los encabezados sin generar una portada.

`abstract` activa una página de resumen. Si `keywords` está declarado, las palabras clave se añaden al final.

`dedicatoria` genera una página de dedicatoria: texto en cursiva, alineado a la derecha en la mitad inferior.

`epigraphtext` genera una página de epígrafe en la mitad inferior derecha. Se complementa con `epigraphauthor` (en versalitas) y `epigraphwork` (en cursiva).

---

## Notas al pie

La plantilla usa la API nativa de memoir, sin `footmisc`.

| Variable | Tipo | Efecto | Origen |
|---|---|---|---|
| `footnoindent` | booleano | Suprime la sangría de primera línea en notas | propio |
| `footinline` | booleano | Número en línea (seguido de punto) en lugar de superíndice | propio |
| `footrule` | booleano | Filete separador en todas las páginas | propio |
| `nofootrule` | booleano | Suprime el filete incluso en páginas de continuación | propio |

Por defecto el filete aparece solo en páginas donde una nota continúa desde la página anterior.

---

## Citas exentas

| Variable | Tipo | Efecto | Origen |
|---|---|---|---|
| `quotesymmetric` | booleano | Mismo sangrado derecho e izquierdo (por defecto solo izquierdo) | propio |

---

## Numeración romana

Por defecto los números romanos de las páginas preliminares van en versalitas.

| Variable | Tipo | Efecto | Origen |
|---|---|---|---|
| `romansmall` | booleano | Minúsculas ordinarias | propio |
| `romancaps` | booleano | Mayúsculas | propio |

---

## Hipervínculos

| Variable | Tipo | Defecto | Origen |
|---|---|---|---|
| `linkcolor` | color xcolor | `linkblue` (RGB 0,70,150) | pandoc |
| `urlcolor` | color xcolor | `linkblue` | pandoc |
| `citecolor` | color xcolor | `linkblue` | pandoc |
| `filecolor` | color xcolor | `black` | pandoc |
| `toccolor` | color xcolor | `black` (fijo) | pandoc |
| `colorlinks` | booleano | `true` (fijo) | pandoc |
| `links-as-notes` | booleano | Imprime los enlaces como notas al pie | pandoc |
| `urlstyle` | string | `\normalfont` | pandoc |
| `lang` | string | `es-ES` | pandoc |
| `subject` | string | — | pandoc |

Los superíndices de nota al pie van siempre en negro, independientemente de `linkcolor`. El color de los enlaces del índice se controla mediante `toccolor`; si no está declarado, los enlaces del índice van en negro.

`urlstyle` acepta: `tt` (monoespacio), `rm` (serif), `sf` (sans), `same` (igual al contexto). Por defecto las URLs van en la misma fuente que el texto circundante.

---

## Impresión

| Variable | Tipo | Efecto | Origen |
|---|---|---|---|
| `impresion` | booleano | Cada capítulo abre en página recto; inserta páginas en blanco donde sea necesario | propio |

---

## Extensibilidad

| Variable | Tipo | Origen |
|---|---|---|
| `header-includes` | bloque raw LaTeX | pandoc |
| `include-before` | bloque raw LaTeX | pandoc |
| `include-after` | bloque raw LaTeX | pandoc |

`header-includes` se inyecta al final del preámbulo, antes de `\begin{document}`. Es el mecanismo correcto para cargar paquetes adicionales o redefinir comportamientos sin modificar la plantilla.
