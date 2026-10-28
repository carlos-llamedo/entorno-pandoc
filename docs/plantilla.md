---
author: Carlos Llamedo
date: 2026-10
---

# Variables de la plantilla `pandoc.tex`

[`pandoc.tex`](../templates/pandoc.tex) es la capa que convierte el documento de Pandoc en LaTeX. No contiene decisiones de aspecto: las delega en un paquete de estilo, por defecto [`memoria.sty`](memoria.md). Cualquier otro paquete que cumpla el [contrato](#contrato-con-el-estilo) puede sustituirlo sin tocar la plantilla.

Las variables marcadas como `pandoc` son estándar y están documentadas en el manual de Pandoc; las marcadas como `propio` son específicas de esta plantilla. El manual de Pandoc incluye [una sección](https://pandoc.org/MANUAL.html#extension-yaml_metadata_block) que detalla cómo declarar estas opciones. Algunas variables de comportamiento las gestiona un filtro, no la plantilla, y están documentadas en [`filtros`](filtros.md).

* * *

## Estilo

| Variable | Tipo | Valor por defecto | Origen |
|---|---|---|---|
| `style` | cadena | `memoria` | propio |
| `styleoptions` | mapa | — | propio |

`style` es el nombre del paquete de estilo (sin `.sty`), que LaTeX debe encontrar en su árbol TEXMF. `styleoptions` se le pasa tal cual como opciones: cada clave se convierte en `clave={valor}`. Las opciones de `memoria` están en [`memoria`](memoria.md).

```yaml
styleoptions:
  headscaps: true
  smallsize: \footnotesize
  tocstyle: columna
```

* * *

## Estándar del PDF

| Variable | Tipo | Origen |
|---|---|---|
| `pdfstandard` | mapa | pandoc |
| `pdfstandard.version` | cadena | pandoc |
| `pdfstandard.standards` | lista | pandoc |
| `pdfstandard.tagging` | booleano | pandoc |

Si `pdfstandard` está declarado, la plantilla emite `\DocumentMetadata{…}` con los valores correspondientes. El idioma del PDF se toma de `lang`. `pdfstandard.version` acepta valores como `1.7` o `2.0`; `pdfstandard.standards` acepta identificadores de conformidad como `a-4f` (PDF/A con fuentes embebidas), `ua-2` (accesibilidad) o `x-4` (PDF/X). Para accesibilidad académica la combinación habitual es `a-4f` con `tagging: true`.

* * *

## Clase y página

| Variable | Tipo | Valor por defecto | Origen |
|---|---|---|---|
| `documentclass` | cadena | `book` o `article` | pandoc |
| `fontsize` | cadena | `12pt` | pandoc |
| `papersize` | cadena | `a4` | pandoc |
| `classoption` | lista | — | pandoc |
| `geometry` | lista | la del estilo | pandoc |

Pandoc usa `book` si `top-level-division` es `chapter` (como en los preajustes) y `article` en otro caso. `memoria` requiere `book`. `papersize` acepta los nombres de papel de la clase sin el sufijo `paper`: `a4`, `letter`, `a5`, `b5`. `classoption` admite cualquier opción de la clase, como `oneside` u `openright`.

Si `geometry` se declara, sustituye por completo a los márgenes del estilo. Las medidas calculadas se escriben con `\dimexpr`:

```yaml
geometry:
  - top=1in
  - bottom=1in
  - left=1in
  - right=1in
  - headheight=14.5pt
  - headsep=\dimexpr0.5in-14.5pt\relax
  - footskip=0.5in
```

* * *

## Fuentes

| Variable | Tipo | Origen |
|---|---|---|
| `mainfont`, `sansfont`, `monofont`, `mathfont` | cadena | pandoc |
| `mainfontoptions`, `sansfontoptions`, `monofontoptions`, `mathfontoptions` | lista | pandoc |
| `mainfontfallback`, `sansfontfallback`, `monofontfallback` | lista | pandoc |
| `fontfamilies` | lista de mapas | pandoc |
| `microtypeoptions` | lista | pandoc |

La fuente principal del documento se cambia con `mainfont`, en el nivel superior del bloque YAML (no dentro de `styleoptions`); `sansfont`, `monofont` y `mathfont` hacen lo propio con la sans, la monoespaciada y la matemática:

```yaml
mainfont: Minion Pro
sansfont: Meta Pro
```

Las fuentes que no se declaren conservan las del estilo (en `memoria`, Arno Pro, Myriad Pro, Source Code Pro y STIX Two Math). Las opciones de una fuente solo se aplican si se declara también la fuente. Los fallbacks son las fuentes donde se buscan los caracteres que no tiene la principal; cada elemento es un nombre de fuente seguido de `:mode=harf`. `fontfamilies` define familias adicionales con `\newfontfamily`: cada elemento lleva `name` (el comando, p. ej. `\griego`), `font` y, opcionalmente, `options`. Sin `microtypeoptions`, microtype activa la protrusión y la expansión.

Las variables `fontoptions` controlan cómo [`fontspec`](https://ctan.org/pkg/fontspec) procesa las fuentes. Los usos más frecuentes son:

- Nombres y variantes de fuentes no estándar

  ```yaml
  mainfont: Warnock Pro
  mainfontoptions:
    - BoldFont=Warnock Pro Semibold
    - BoldItalicFont=Warnock Pro Semibold Italic
  ```

- Ligaduras adicionales (deben declararse como entradas separadas)

  ```yaml
  mainfontoptions:
    - Ligatures=TeX              # ligaduras estándar (ff, fi, fl…); declarar primero
    - Ligatures=Discretionary    # ligaduras opcionales (Th, ct…); depende de la fuente
    - Ligatures=Historic         # ligaduras históricas (ſt, ſi…)
  ```

- Numerales

  ```yaml
  mainfontoptions:
    - Numbers=OldStyle           # cifras elzevirianas; recomendable en cuerpo de texto
    - Numbers=Lining             # cifras de caja alta; para tablas o contextos técnicos
  ```

- Escala

  ```yaml
  monofontoptions:
    - Scale=MatchLowercase       # fontspec mide y ajusta automáticamente
  ```

* * *

## Texto

| Variable | Tipo | Origen |
|---|---|---|
| `linestretch` | número | pandoc |
| `cancel` | booleano | pandoc |
| `strikeout` | booleano | pandoc |
| `csquotes` | booleano | pandoc |
| `csquotesoptions` | lista | pandoc |

`linestretch` sustituye al interlineado del estilo en todo el documento. `cancel` carga el paquete `cancel` para tachados matemáticos; `strikeout` lo activa Pandoc cuando hay texto tachado. `csquotes` compone las comillas con el paquete [`csquotes`](https://ctan.org/pkg/csquotes), que las adapta al idioma.

* * *

## Idioma

| Variable | Tipo | Origen |
|---|---|---|
| `lang` | cadena | pandoc |
| `babeloptions` | lista | pandoc |
| `shorthands` | booleano | pandoc |

`lang` acepta etiquetas BCP 47 (`es-ES`, `en-GB`, `fr-FR`…). Afecta a los metadatos del PDF y, a través de babel, a la silabación y a los nombres («Índice general», «Figura», «Cuadro»). Los preajustes declaran `es-ES`; sin `lang` no se carga babel. Los demás idiomas que aparezcan en el documento (`[texte]{lang=fr}`) se cargan automáticamente.

Con el español, babel aplica sus convenciones: operadores acentuados (lím, máx), sangría también en el primer párrafo tras un título, y «Cuadro» e «Índice de cuadros» para las tablas. `babeloptions` le pasa opciones (p. ej., `es-nodecimaldot`), y `shorthands: true` activa sus atajos.

* * *

## Numeración e índices

| Variable | Tipo | Valor por defecto | Origen |
|---|---|---|---|
| `numbersections` | booleano | — | pandoc |
| `secnumdepth` | entero | `5` | pandoc |
| `toc` | booleano | — | pandoc |
| `toc-title` | cadena | el de babel | pandoc |
| `toc-depth` | entero | `2` | pandoc |
| `lof` | booleano | — | pandoc |
| `lot` | booleano | — | pandoc |
| `lol` | booleano | — | propio |
| `toccolor` | color | `black` | pandoc |

`lof`, `lot` y `lol` imprimen el índice de figuras, el de cuadros y el de listados. `lol` requiere el modo de listados (véase la sección siguiente). Con `colorlinks`, los enlaces de los índices van en `toccolor`.

* * *

## Código y listados

| Variable | Tipo | Origen |
|---|---|---|
| `listings` | booleano | pandoc |
| `highlighting-macros` | bloque raw LaTeX | pandoc |
| `verbatim-in-note` | booleano | pandoc |

Pandoc compone el código de dos maneras. Por defecto lo colorea él mismo. Con `syntax-highlighting: idiomatic` lo entrega al paquete [`listings`](https://ctan.org/pkg/listings) de LaTeX, como en las plantillas de Kieran Healy; es lo que activan los preajustes `memoria` y `multibib`. Un bloque con identificador `lst:` y atributo `caption` se convierte en un listado numerado, al que se puede remitir (véase [`pandoc-crossref`](filtros.md#pandoc-crossref)):

````markdown
```{#lst:saludo .python caption="Saludo en Python"}
print("hola")
```

Como muestra el @lst:saludo, …
````

`verbatim-in-note` permite código literal dentro de las notas al pie.

* * *

## Páginas preliminares

| Variable | Tipo | Origen |
|---|---|---|
| `title`, `subtitle` | cadena | pandoc |
| `author` | cadena o lista | pandoc |
| `date` | cadena | pandoc |
| `title-meta`, `author-meta`, `subject`, `keywords` | cadena o lista | pandoc |
| `abstract` | cadena | pandoc |
| `thanks` | cadena | pandoc |
| `maketitle` | booleano | propio |
| `dedication` | cadena | propio |
| `epigraphtext`, `epigraphauthor`, `epigraphwork` | cadena | propio |

`maketitle` imprime la portada; sin ella, el título solo existe como metadato. `title-meta`, `author-meta`, `subject` y `keywords` van a los metadatos del PDF; el subtítulo no.

`abstract` imprime el resumen y, si hay `keywords`, las palabras clave a continuación. `thanks` genera un capítulo de agradecimientos tras los índices (en la plantilla oficial es una nota al título). `dedication` genera una página de dedicatoria y `epigraphtext` una de epígrafe, con `epigraphauthor` y `epigraphwork` opcionales.

* * *

## Figuras y cuadros

| Variable | Tipo | Origen |
|---|---|---|
| `graphics`, `svg`, `subfigure`, `tables`, `multirow` | booleano | pandoc |

Pandoc activa estas variables según lo que contenga el documento; no hace falta declararlas. Las imágenes SVG necesitan una herramienta externa de conversión (Inkscape o `rsvg-convert`); sin ella la compilación falla, también con la plantilla oficial.

* * *

## Hipervínculos

| Variable | Tipo | Valor por defecto | Origen |
|---|---|---|---|
| `colorlinks` | booleano | — | pandoc |
| `linkcolor`, `urlcolor`, `citecolor` | color | `DarkSlateBlue` | pandoc |
| `filecolor` | color | `black` | pandoc |
| `boxlinks` | booleano | — | pandoc |
| `links-as-notes` | booleano | — | pandoc |
| `urlstyle` | cadena | `same` | pandoc |
| `hyperrefoptions` | lista | — | pandoc |

Sin `colorlinks` ni `boxlinks`, los enlaces no se marcan, pero siguen siendo clicables. Los colores admiten los nombres de `xcolor` (`dvipsnames`, `svgnames`, `x11names`). `links-as-notes` convierte los enlaces en notas al pie con la URL. `urlstyle` acepta `tt`, `rm`, `sf` o `same`.

* * *

## Bibliografía

| Variable | Tipo | Origen |
|---|---|---|
| `refs` | cadena | propio |

`refs` lleva la bibliografía a las páginas finales en vez de al final del cuerpo (véase [`filtros`](filtros.md#citeproc)). La separación entre entradas la decide el estilo.

* * *

## Extensibilidad

| Variable | Tipo | Origen |
|---|---|---|
| `header-includes` | bloque raw LaTeX | pandoc |
| `include-before` | bloque raw LaTeX | pandoc |
| `include-after` | bloque raw LaTeX | pandoc |

`header-includes` se inyecta al final del preámbulo, después del estilo y de las fuentes y antes de hyperref. `include-before` va tras los índices y los agradecimientos; `include-after`, tras `refs`.

* * *

## Contrato con el estilo

La plantilla carga el paquete de estilo después de la clase, babel, las fuentes por defecto y el código que necesita Pandoc (tablas, imágenes, citas, listados), y antes de las fuentes del usuario, `header-includes` e hyperref. Del estilo solo usa estos nombres, y solo si el documento declara la variable correspondiente:

| Nombre | Variable | Uso |
|---|---|---|
| entorno `abstract` | `abstract` | Resumen (las clases `article` y `report` ya lo traen) |
| `\keywords{…}` | `keywords` | Palabras clave, dentro de `abstract` |
| `\dedication{…}` | `dedication` | Dedicatoria |
| `\epigraphpage{texto}{autor}{obra}` | `epigraph…` | Epígrafe; autor y obra pueden ir vacíos |
| entorno `acknowledgments` | `thanks` | Agradecimientos |

Todo lo demás (márgenes, fuentes por defecto, títulos, encabezados, índices, notas, bibliografía) lo decide el estilo con LaTeX corriente.

* * *

## Relación con las plantillas oficiales

`pandoc.tex` sigue la plantilla LaTeX oficial de Pandoc, incluida como submódulo en `templates/pandoc-templates`. Los parciales que no chocan con el estilo se incluyen directamente (`document-metadata`, `passoptions`, `fonts`, `font-settings` y `after-header-includes`), y los bloques de `common.latex` se copian sin las ramas de beamer, CJK y pdfTeX. Las divergencias están marcadas en la plantilla con `DIVERGE`:

- `12pt` y A4 por defecto.
- Sin `parskip` (ni la variable `indent`): el párrafo es cosa del estilo.
- `linestretch` se aplica a todo el documento, también al índice.
- Sin `\babelfont{rm}`, que repetiría lo que ya fija `font-settings`.
- Colores de enlace propios, y enlaces de los índices en negro por defecto.
- Variables de contenido propias: `maketitle`, `dedication`, `epigraph…`, `thanks` como agradecimientos, `lol` y `refs`.
- Requiere LuaLaTeX. No admite las variables de beamer, natbib, biblatex, `pagestyle`, `block-headings` ni `dir`.

Al actualizar el submódulo conviene revisar los cambios en esos archivos y trasladarlos a la plantilla.
