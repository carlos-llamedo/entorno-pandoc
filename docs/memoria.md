---
author: Carlos Llamedo
date: 2026-10
---

# El estilo `memoria.sty`

[`memoria.sty`](../tex/memoria.sty) es el estilo por defecto de la plantilla [`pandoc.tex`](plantilla.md): una maqueta para memorias académicas sobre la clase `book`, compilada con LuaLaTeX. También se puede usar en documentos LaTeX escritos a mano.

Para que LaTeX lo encuentre, debe estar en el árbol TEXMF personal (véase el [README](../README.md)).

* * *

## Opciones

Desde Pandoc se declaran bajo `styleoptions`; en LaTeX, como opciones del paquete.

```yaml
styleoptions:
  headscaps: true
  titlefont: Meta Pro
  smallsize: \footnotesize
  tocstyle: columna
```

| Opción | Tipo | Valor por defecto | Efecto |
|---|---|---|---|
| `parindent` | medida | `1cm` | Sangría de párrafo, y medida de listas, citas, notas y bibliografía |
| `noindent` | booleano | — | Párrafos sin sangría y con espacio entre ellos |
| `smallsize` | comando | `\normalsize` | Tamaño de notas, citas, pies, encabezados y código |
| `titlefont` | cadena | — | Familia para títulos, encabezados, folios, índice y pies |
| `titlefontoptions` | cadena | — | Opciones de fontspec para `titlefont`, separadas por comas |
| `tocstyle` | `tex`, `margen`, `columna` | `margen` | Diseño de los índices |
| `headscaps` | booleano | — | Encabezados en versalitas en lugar de cursiva |
| `folioonly` | booleano | — | Encabezados con el folio solo |
| `headrule` | booleano | — | Filete bajo el encabezado |
| `nofolio` | booleano | — | Sin folio en las páginas de inicio de capítulo |
| `footsuper` | booleano | — | Número de la nota volado en lugar de en el renglón |
| `footrule` | booleano | — | Filete de notas en todas las páginas |
| `nofootrule` | booleano | — | Sin filete de notas, ni siquiera en continuaciones |
| `quotesymmetric` | booleano | — | Citas exentas sangradas también por la derecha |

`parindent` acepta cualquier unidad LaTeX: `1cm`, `0.5in` (la anglosajona), `2em` (proporcional al cuerpo).

`smallsize` acepta cualquier comando de tamaño. Con un cuerpo de `12pt`: `\footnotesize` da 10 pt, `\small` 10,95 pt, y `\normalsize` (por defecto) iguala los elementos secundarios con el cuerpo.

`titlefont` permite combinar dos familias, p. ej. una sans para los títulos (`titlefont: Myriad Pro`) o dos serifs. Lleva siempre cifras elzevirianas. Las demás fuentes no son opciones del estilo: se cambian con las variables de Pandoc `mainfont`, `sansfont`, `monofont` y `mathfont`, fuera de `styleoptions` (véase [`plantilla`](plantilla.md#fuentes)).

* * *

## Índices

`tocstyle` elige el diseño del índice general y de los de figuras, cuadros y listados:

- `margen` (por defecto): los capítulos llevan la página en una columna a la izquierda, el número en otra y el título en negrita, alineado tengan número o no. Las secciones van debajo en versalitas espaciadas, sin página, y las subsecciones, sangradas y seguidas en un párrafo («Título, página; Título, página»).
- `columna`: número y título a la izquierda, página alineada a la derecha sin puntos; capítulos en versalitas espaciadas.
- `tex`: el índice estándar de la clase `book`.

En `margen` y `columna`, las entradas de figuras, cuadros y listados llevan su nombre delante («Figura 1.1») y no se separan por capítulos. En todos los estilos, los índices de figuras, cuadros y listados aparecen en el índice general.

* * *

## Valores por defecto

- **Página:** márgenes de `3cm`, con encabezado y pie a media altura del margen. La variable `geometry` los sustituye. Los capítulos empiezan en cualquier página, salvo que se declare `classoption: openright`.
- **Fuentes:** Arno Pro, Myriad Pro, Source Code Pro y STIX Two Math, con Source Serif 4, Source Sans 3 y Source Code Pro como fallbacks. Se aplican al final del preámbulo y solo si el documento no ha elegido otras, porque la primera fuente principal fija también la de los operadores matemáticos.
- **Párrafo:** interlineado 1,5, sangría sin espacio entre párrafos, y control de viudas y huérfanas.
- **Versalitas:** folios romanos, etiquetas de los pies, capítulos del índice, autor del epígrafe y encabezados con `headscaps` usan las versalitas de la fuente si las tiene; si no, mayúsculas.
- **Encabezados:** en el verso, el autor (o el título si no hay autor); en el recto, el capítulo. El folio va en el exterior superior.
- **Listas:** la marca a la altura de la sangría de párrafo y el texto colgado tras ella. Raya, bolo y rombo según el nivel.
- **Notas:** numeración continua en todo el documento; filete solo en las páginas de continuación.
- **Bibliografía:** sangría francesa igual a `parindent`; las entradas se separan como los párrafos.
- **Código:** a `smallsize`. Los listados van en un recuadro, como en las plantillas de Kieran Healy, pero sin flotar y con el espaciado natural para que el texto copiado del PDF salga limpio.

* * *

## Comandos

El paquete implementa el [contrato](plantilla.md#contrato-con-el-estilo) que usa la plantilla, con los nombres en español:

| Comando | Resultado |
|---|---|
| `\begin{abstract} … \keywords{…} \end{abstract}` | Página de resumen («Resumen», de babel), con «Palabras clave:» |
| `\dedication{texto}` | Página de dedicatoria, en cursiva, en el cuarto superior derecho |
| `\epigraphpage{texto}{autor}{obra}` | Página de epígrafe; autor en versalitas y obra en cursiva |
| `\begin{acknowledgments} … \end{acknowledgments}` | Capítulo «Agradecimientos», incluido en el índice |

Además ofrece `\metafont` (la familia de títulos), `\metacaps{texto}` (versalitas o mayúsculas, según la fuente) y `\textsmall` (el tamaño `smallsize`).

* * *

## Uso directo en LaTeX

```latex
\documentclass[12pt,a4paper,spanish]{book}
\usepackage[shorthands=off]{babel}
\usepackage[headscaps,tocstyle=columna]{memoria}
\usepackage{hyperref}
\title{Título}
\author{Autor}
```

Babel se carga antes que `memoria`. Las fuentes se cambian con `\setmainfont` y compañía, los márgenes con `geometry` y el interlineado con `\setstretch`.
