---
author: Carlos Llamedo
date: 2026-10
---

# Variables de la plantilla `pandoc.tex`

[`pandoc.tex`](../templates/pandoc.tex) es la capa que convierte el documento de Pandoc en LaTeX. No contiene decisiones de aspecto: las delega en un paquete de estilo, como [`memoria.sty`](https://github.com/carlos-llamedo/entorno-latex/blob/main/docs/memoria.md) o `temas.sty`, del repositorio [entorno-latex](https://github.com/carlos-llamedo/entorno-latex). Cualquier otro paquete que cumpla el [contrato](#contrato-con-el-estilo) puede sustituirlos sin tocar la plantilla, y sin ninguno compila con LaTeX estándar (es lo que hace el preajuste `latex`).

Las variables marcadas como `pandoc` son estándar y están documentadas en el manual de Pandoc; las marcadas como `propio` son específicas de esta plantilla. El manual de Pandoc incluye [una sección](https://pandoc.org/MANUAL.html#extension-yaml_metadata_block) que detalla cómo declarar estas opciones. Algunas variables de comportamiento las gestiona un filtro, no la plantilla, y están documentadas en [`filtros`](filtros.md).

La plantilla no fija valores por defecto. Los de aspecto los pone el estilo; el resto está en los archivos de [`metadata/`](../metadata), que los preajustes cargan con `metadata-files`: [`localizacion.yaml`](../metadata/localizacion.yaml) (idioma y posición de las llamadas de nota), [`crossref.yaml`](../metadata/crossref.yaml) (localización de pandoc-crossref) y [`plantilla.yaml`](../metadata/plantilla.yaml) (sangría de párrafo). El estilo de citas no tiene valor por defecto propio: si el documento no declara `csl`, citeproc usa _Chicago_ autor-fecha. Las fuentes, el cuerpo de letra, el papel y el aspecto de los enlaces son del estilo. Cualquier variable declarada en el bloque YAML del documento tiene prioridad sobre ellos y sobre el estilo. La excepción es `fontfamily`: cada preajuste la fija en su bloque `metadata`, que manda sobre el documento, porque elegir preajuste es elegir estilo.

* * *

## Estilo

| Variable | Tipo | Valor por defecto | Origen |
|---|---|---|---|
| `fontfamily` | cadena | la del preajuste (`memoria`, `temas` o ninguna) | pandoc |
| `fontfamilyoptions` | lista | — | pandoc |

El estilo se carga con la variable oficial `fontfamily`: es el nombre del paquete (sin `.sty`), que LaTeX debe encontrar en su árbol TEXMF. Pandoc lo carga justo antes de aplicar `mainfont` y compañía, así que el estilo puede fijar fuentes por defecto y el documento cambiarlas. `fontfamilyoptions` es la lista de opciones del paquete, cada una como `clave=valor`; si un valor lleva comas, va entre llaves. Las opciones de `memoria` están en [`memoria`](https://github.com/carlos-llamedo/entorno-latex/blob/main/docs/memoria.md).

```yaml
fontfamilyoptions:
  - headscaps=true
  - smallsize=\footnotesize
  - tocstyle=columna
```

Sirve cualquier paquete, también de terceros. Por ejemplo, `documentclass: scrreprt` con `fontfamily: classicthesis` compone el mismo Markdown con el aspecto de classicthesis.

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
| `fontsize` | cadena | el del estilo (`12pt` fijo en `memoria` y `temas`) | pandoc |
| `papersize` | cadena | el del estilo (`a4` fijo en `memoria` y `temas`) | pandoc |
| `classoption` | lista | — | pandoc |
| `geometry` | lista | la del estilo | pandoc |

Pandoc usa `book` si `top-level-division` es `chapter` (como en los preajustes) y `article` en otro caso. `memoria` requiere `book`. `papersize` acepta los nombres de papel de la clase sin el sufijo `paper`: `a4`, `letter`, `a5`, `b5`. `classoption` admite cualquier opción de la clase, como `oneside` u `openright`.

`fontsize` y `papersize` son opciones de la clase, que se carga antes que el estilo. El estilo puede cambiarlas después: `memoria` y `temas` fijan siempre 12pt (con `scrextend`) y A4 (con `geometry`), así que con ellos estas variables no tienen efecto.

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

La fuente principal del documento se cambia con `mainfont`, en el nivel superior del bloque YAML (no dentro de `fontfamilyoptions`); `sansfont`, `monofont` y `mathfont` hacen lo propio con la sans, la monoespaciada y la matemática:

```yaml
mainfont: Minion Pro
sansfont: Meta Pro
```

Las fuentes que no se declaren conservan las del estilo (en `memoria` y `temas`, Arno Pro, Myriad Pro, Source Code Pro y STIX Two Math, con Source Serif 4, Source Sans 3 y Source Code Pro como fallbacks). Con un estilo de terceros, como `classicthesis`, se conservan las suyas. Las opciones de una fuente solo se aplican si se declara también la fuente. Los fallbacks son las fuentes donde se buscan los caracteres que no tiene la principal; cada elemento es un nombre de fuente seguido de `:mode=harf`. `fontfamilies` define familias adicionales con `\newfontfamily`: cada elemento lleva `name` (el comando, p. ej. `\griego`), `font` y, opcionalmente, `options`. Sin `microtypeoptions`, microtype activa la protrusión y la expansión.

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

`linestretch` sustituye al interlineado del estilo a partir de los índices. `cancel` carga el paquete `cancel` para tachados matemáticos; `strikeout` lo activa Pandoc cuando hay texto tachado. `csquotes` compone las comillas con el paquete [`csquotes`](https://ctan.org/pkg/csquotes), que las adapta al idioma.

* * *

## Idioma

| Variable | Tipo | Origen |
|---|---|---|
| `lang` | cadena | pandoc |
| `babeloptions` | lista | pandoc |
| `shorthands` | booleano | pandoc |

`lang` acepta etiquetas BCP 47 (`es-ES`, `en-GB`, `fr-FR`…). Afecta a los metadatos del PDF y, a través de babel, a la silabación y a los nombres («Índice general», «Figura», «Cuadro»). Los preajustes declaran `es-ES`; sin `lang` no se carga babel. Los demás idiomas que aparezcan en el documento (`[texte]{lang=fr}`) se cargan automáticamente.

Con el español, babel aplica sus convenciones: operadores acentuados (lím, máx), sangría también en el primer párrafo tras un título, y «Cuadro» e «Índice de cuadros» para las tablas. `babeloptions` le pasa opciones (p. ej., `es-tabla`), y `shorthands: true` activa sus atajos, entre ellos la coma decimal en matemáticas (`$3.14$` da 3,14).

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

`lof`, `lot` y `lol` imprimen el índice de figuras, el de cuadros y el de listados. `lol` requiere el modo de listados (véase la sección siguiente). El color de sus enlaces lo decide el estilo: `memoria` y `temas` los ponen en negro.

* * *

## Código y listados

| Variable | Tipo | Origen |
|---|---|---|
| `listings` | booleano | pandoc |
| `highlighting-macros` | bloque raw LaTeX | pandoc |
| `verbatim-in-note` | booleano | pandoc |

Pandoc compone el código de dos maneras. Por defecto lo colorea él mismo. Con `syntax-highlighting: idiomatic` lo entrega al paquete [`listings`](https://ctan.org/pkg/listings) de LaTeX, como en las plantillas de Kieran Healy; es lo que activan los preajustes `memoria`, `temas` y `latex`. Un bloque con identificador `lst:` y atributo `caption` se convierte en un listado numerado, al que se puede remitir (véase [`pandoc-crossref`](filtros.md#pandoc-crossref)):

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
| `author` | cadena, lista o mapas con `name` y `email` | pandoc |
| `date` | cadena | pandoc |
| `title-meta`, `author-meta`, `subject`, `keywords` | cadena o lista | pandoc |
| `abstract` | cadena | pandoc |
| `thanks` | cadena | pandoc |
| `maketitle` | booleano | propio |

`maketitle` imprime la portada; sin ella, el título solo existe como metadato. Cada autor puede declararse como mapa con `name` y `email`; la plantilla usa `name` como nombre y pasa el correo al estilo con `\authoremail{…}`, que lo usa o lo ignora. `title-meta`, `author-meta`, `subject` y `keywords` van a los metadatos del PDF; el subtítulo no. Con autores como mapas, Pandoc no genera `author-meta`: hay que declararlo para que el PDF lleve autor.

`abstract` imprime el resumen y, si hay `keywords`, las palabras clave a continuación. `thanks` es la variable oficial para los agradecimientos; la plantilla la pasa como `\thanks` dentro de `\title`, y el estilo decide su forma: sin estilo, o con `temas`, es una nota al pie en el título; `memoria` la convierte en el capítulo «Agradecimientos», tras la portada. Puede tener varios párrafos. `subtitle` lo compone el `\subtitle` del estilo, si lo define; si no, Pandoc lo añade bajo el título.

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
| `links-as-notes` | booleano | — | pandoc |
| `urlstyle` | cadena | `same` | pandoc |
| `hyperrefoptions` | lista | — | pandoc |

El aspecto de los enlaces (color, recuadros o nada) es del estilo, que lo fija con `\hypersetup`: `memoria` y `temas` los colorean en DarkSlateBlue. La plantilla no admite `colorlinks`, `linkcolor`, `urlcolor`, `citecolor`, `filecolor`, `toccolor` ni `boxlinks`, que en la oficial pisarían al estilo. `links-as-notes` convierte los enlaces en notas al pie con la URL. `urlstyle` acepta `tt`, `rm`, `sf` o `same`.

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

`header-includes` se inyecta al final del preámbulo, después del estilo y de las fuentes y antes de hyperref. `include-before` va tras los índices; `include-after`, tras `refs`.

* * *

## Contrato con el estilo

Pandoc carga el paquete de estilo (`fontfamily`) después de la clase y de `unicode-math`, y antes de las fuentes del documento, babel, el código que necesita Pandoc (tablas, imágenes, citas, listados), `header-includes` e hyperref. El estilo puede fijar sus fuentes con `\setmainfont` y similares: las que declare el documento se aplican después y tienen prioridad. Lo que dependa de paquetes posteriores se aplaza con `\AtBeginDocument` o `\AddToHook{package/…/after}`. El aspecto de los enlaces también es del estilo: como hyperref se carga después, lo fija con `\AddToHook{package/hyperref/after}{\hypersetup{…}}`. Puede usar los nombres de color de `xcolor` (`dvipsnames`, `svgnames`, `x11names`), que la plantilla carga siempre. Del estilo solo usa estos nombres, y solo si el documento declara la variable correspondiente:

| Nombre | Variable | Uso |
|---|---|---|
| entorno `abstract` | `abstract` | Resumen (las clases `article` y `report` ya lo traen) |
| `\keywords{…}` | `keywords` | Palabras clave, dentro de `abstract` (opcional: si el estilo no lo define, la plantilla pone un párrafo con `\keywordsname`) |
| `\thanks{…}` | `thanks` | Agradecimientos (opcional: si el estilo no lo cambia, es la nota al pie de LaTeX en el título) |
| `\subtitle{…}` | `subtitle` | Subtítulo (opcional: si el estilo no lo define, Pandoc pone el suyo) |
| `\authoremail{…}` | `author.email` | Correo del autor (opcional: la plantilla lo declara vacío si el estilo no lo define) |

Todo lo demás (márgenes, títulos, encabezados, índices, notas, bibliografía) lo decide el estilo con LaTeX corriente.

* * *

## Relación con las plantillas oficiales

`pandoc.tex` es el `default.latex` oficial de Pandoc, incluido como submódulo en `templates/pandoc-templates`, con las inserciones marcadas con `DIVERGE`. Las divergencias son:

- Autores como mapas con `name` y `email`, y el comando `\authoremail` para el estilo.
- Portada solo con `maketitle` (la oficial la pone siempre que hay `title`).
- Resumen independiente de la portada, con `keywords` dentro.
- Variables de contenido propias: `lol` y `refs`.
- `\keywords` de respaldo, para compilar sin estilo.
- `hypersetup.latex` copiado solo con los metadatos del PDF: sin `colorlinks`, colores ni `hidelinks`, que son del estilo. Por eso los nombres de color de `xcolor` se cargan siempre, no solo con `colorlinks`.

Al actualizar el submódulo conviene comparar `default.latex` con la plantilla: basta con un `diff` que ignore el prefijo `pandoc-templates/` de los parciales.
