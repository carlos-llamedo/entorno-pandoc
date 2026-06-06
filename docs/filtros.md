---
author: Carlos Llamedo
date: 2026-06
---

# Filtros de Pandoc

Pandoc permite, de manera nativa, aplicar programas (filtros) que modifican su árbol de sintaxis abstracta (AST) entre la lectura del documento y la
escritura del formato de salida. Esto posibilita extender el comportamiento de Pandoc con sintaxis o transformaciones que ni el lector ni el escritor nativo contemplan.

```
INPUT --reader--> AST --filter--> AST --writer--> OUTPUT
```

Hay dos tipos de filtros soportados por Pandoc, cada uno con su documentación: [filtros JSON](https://pandoc.org/filters.html), que se invocan como procesos externos, y [filtros Lua](https://pandoc.org/lua-filters.html), que se ejecutan en el intérprete de Lua de Pandoc.

Este documento expone qué filtros actúan en el flujo de trabajo del repositorio, qué hacen y cuándo se activan. Para aquellos que requieren una sintaxis concreta en el documento para operar se acompañan indicaciones de cómo usarla. Es una guía de uso rápida; [`referencias`](referencias.md) indica dónde encontrar la documentación completa de cada uno.

* * *

## Filtros JSON

### Citeproc

[Citeproc](https://github.com/jgm/citeproc) es el procesador de citas integrado en Pandoc, una librería Haskell escrita por John McFarlane. Es una reescritura de `pandoc-citeproc`, que a su vez era una derivación de la librería `citeproc-hs` de Andrea Rossato.

Resuelve las citas en sintaxis `[@clave]` presentes en el documento, genera las referencias formateadas según el estilo CSL activo y produce la bibliografía final. Se invoca declarándolo en la lista `filters` del archivo de defaults o pasando `--citeproc` o `-C` en la línea de comandos.

```yaml
filters:
  - citeproc
```

Es importante que Citeproc vaya después de cualquier filtro que pueda generar o modificar citas, y antes de los filtros que operan sobre el texto ya resuelto (como `correcciones-notas.lua`). `multibib.lua` lo sustituye completamente, por lo que los dos son incompatibles juntos.

La bibliografía se configura mediante las variables `bibliography` y `csl` del documento o del archivo de defaults:

```yaml
bibliography: biblioteca.json
csl: chicago-notes-bibliography
```

Si `csl` no está declarado, citeproc usa el estilo *Chicago* autor-fecha por defecto.

Las variables que controlan el comportamiento de la bibliografía y las citas se declaran en los metadatos del documento:

| Variable | Tipo | Efecto |
|---|---|---|
| `reference-section-title` | string | Título de la sección de bibliografía |
| `suppress-bibliography` | booleano (`false`) | Suprime la generación de la bibliografía |
| `link-citations` | booleano (`false`) | Añade hipervínculos de las citas a sus entradas en la bibliografía (solo en estilos autor-fecha y numéricos) |
| `link-bibliography` | booleano (`true`) | Convierte en hipervínculos los DOI, URL y similares de las entradas de la bibliografía |
| `notes-after-punctuation` | booleano (`true`) | En estilos de nota, mueve la llamada de nota al pie tras el signo de puntuación siguiente |
| `nocite` | lista de claves | Incluye entradas en la bibliografía sin que aparezcan citadas en el texto. `@*` incluye toda la bibliografía |
| `lang` | etiqueta BCP 47 | Idioma para la localización del estilo CSL |

La bibliografía se inserta por defecto al final del documento. Para controlar su posición, se puede usar un div con el identificador `refs`:

```markdown
::: {#refs}
:::
```

### pandoc-crossref

[`pandoc-crossref`](https://github.com/lierdakil/pandoc-crossref) es un filtro externo de Nikolay Yakimov para remisiones a figuras, tablas y ecuaciones. Asigna números correlativos a los elementos etiquetados y sustituye las referencias en el texto por los identificadores formateados.

Se invoca declarándolo en `filters`. Debe ir **antes de Citeproc** para que las referencias cruzadas estén resueltas cuando Citeproc procese el documento:

```yaml
filters:
  - pandoc-crossref
  - citeproc
```

Las figuras se etiquetan mediante el atributo `#fig:identificador` en la sintaxis de imagen:

```markdown
![Pie de foto](ruta/imagen.png){#fig:mapa}
```

Las tablas, añadiendo el atributo a continuación del pie:

```markdown
: Pie de tabla {#tbl:datos}

| Col A | Col B |
|-------|-------|
| 1     | 2     |
```

Las remisiones en el texto tienen esta sintaxis:

```markdown
Como se aprecia en @fig:mapa, la distribución es irregular.

Véase la @tbl:datos para los valores completos.
```

Los prefijos y títulos de sección se declaran localizados al español en el bloque `metadata`:

```yaml
metadata:
  figureTitle: "Figura"
  tableTitle: "Tabla"
  figPrefix:
    - "fig."
    - "figs."
  tblPrefix:
    - "tabla"
    - "tablas"
  eqnPrefix:
    - "ec."
    - "ecs."
  lofTitle: "Lista de figuras"
  lotTitle: "Lista de tablas"
```

* * *

## Filtros Lua

### include-files.lua

[`include-files.lua`](https://github.com/pandoc-ext/include-files) es un filtro de Albert Krewinkel. Permite componer un documento a partir de múltiples archivos Markdown, incluyendo unos dentro de otros mediante bloques de código de clase `include`. Es el mecanismo central para estructurar trabajos extensos en capítulos independientes.

#### Sintaxis básica

Un bloque de código con la clase `include` lista los archivos a incluir, uno por línea. Las rutas son relativas al archivo que contiene el bloque. No tiene problema con rutas que contengan caracteres especiales, como letras acentuadas.

````markdown
``` {.include}
capítulos/introducción.md
capítulos/desarrollo.md
capítulos/conclusión.md
```
````

Las líneas que empiezan por `//` se tratan como comentarios y se ignoran:

````markdown
``` {.include}
// Este archivo está siendo revisado
// capítulos/apéndice.md
capítulos/introducción.md
```
````

#### Control de niveles de encabezado

Por defecto, los encabezados de los archivos incluidos se insertan con su nivel original. El atributo `shift-heading-level-by` permite desplazarlos para que encajen en la jerarquía del documento principal. Un valor positivo sube el nivel (un `# Título` pasa a `## Título`); uno negativo lo baja:

````markdown
``` {.include shift-heading-level-by=1}
capítulos/desarrollo.md
```
````

El modo automático, activado con `include-auto: true` en el bloque de metadatos del documento, desplaza los encabezados de cada archivo incluido según el último encabezado encontrado antes del bloque `include`. Esto permite mantener la jerarquía sin declarar el desplazamiento manualmente:

```yaml
---
include-auto: true
---
```

#### Rutas relativas

El filtro ajusta automáticamente las rutas relativas de enlaces e imágenes dentro de los archivos incluidos, de modo que se resuelven correctamente desde la ubicación del archivo incluido, no desde el documento principal.

### noindent.lua

`noindent.lua` convierte divs con la clase `noindent` a un grupo LaTeX sin sangría de primera línea. Útil para párrafos que siguen a elementos no textuales (listas, tablas, figuras, citas exentas) y que, por convención tipográfica, no deben llevar sangría aunque el documento use sangría por defecto.

El filtro solo actúa en la salida LaTeX; en otros formatos el div se ignora sin generar código adicional.

```markdown
::: {.noindent}
Párrafo sin sangría de primera línea.
:::
```

El filtro envuelve el contenido del div en `{\parindent0pt … }` en lugar de usar `\noindent`, porque `\noindent` solo afecta al párrafo inmediatamente siguiente; si el div contiene varios párrafos, los sucesivos recuperarían la sangría normal.

### multibib.lua

[`multibib.lua`](https://github.com/pandoc-ext/multibib) es un filtro de Albert Krewinkel. Permite separar la bibliografía en varias partes dentro de un mismo documento, cada una alimentada por un archivo de bibliografía distinto. 

Sustituye a Citeproc cuando el documento requiere separar las referencias en secciones independientes (p. ej., fuentes primarias y bibliografía secundaria), por lo que **no es compatible con Citeproc**. Cuando se usa `multibib.lua`, Citeproc no debe declararse en `filters`.

Las bibliografías se declaran en el bloque de metadatos del documento como un mapa, donde cada clave es un nombre que identificará la sección y cada valor es la ruta al archivo de bibliografía correspondiente:

```yaml
bibliography:
  primarias: fuentes-primarias.json
  secundaria: biblioteca.json
```

Cada sección de referencias se inserta en el punto del documento donde se quiera que aparezca, mediante un *div* cuyo identificador sigue el patrón `refs-nombre`:

```markdown
## Fuentes primarias

::: {#refs-primarias}
:::

## Bibliografía

::: {#refs-secundaria}
:::
```

#### La numeración de notas al pie se reinicia en cada capítulo

Hay una interacción conocida entre `pandoc-crossref` y `multibib.lua` que obliga al contador de numeración de notas al pie a reiniciarse en cada capítulo. Si se quiere evitar este comportamiento, hay que añadir un bloque `header-includes` en el YAML del documento:

```yaml
header-includes:
  - |
      \usepackage{chngcntr}
      \counterwithout{footnote}{chapter}
```

### correcciones-notas.lua

`correcciones-notas.lua` aplica dos correcciones tipográficas dentro de las notas al pie, normalizando convenciones del español que Citeproc no gestiona.

Las dos correcciones comparten el mismo recorrido del AST y se procesan en un único pase, por lo que el filtro debe declararse después de Citeproc, una vez que las notas al pie ya están generadas:

```yaml
filters:
  - citeproc
  - correcciones-notas.lua
```

1. Sustituye las abreviaturas castellanas de párrafo (`párr.`) y sección (`sec.`, `secs.`) por el símbolo ortográfico convencional (`§`). La sustitución es exacta, no actúa sobre cadenas que lo contengan.
2. Normaliza las semirrayas (`–`) que separan rangos de páginas o párrafos sustituyéndolas por guion simple. Así, `§ 12–15` se convierte en `§ 12-15`, siguiendo la convención tipográfica española (las semirrayas son un signo ortográfico propio del inglés, no existen en español). La corrección respeta el contexto: solo actúa sobre semirrayas que aparecen dentro de rangos alfanuméricos tras `§`, y mantiene las semirrayas en cualquier otro uso.

### zotero.lua

[`zotero.lua`](https://retorque.re/zotero-better-bibtex/exporting/pandoc/) es un filtro de Emiliano Heyns. Convierte la sintaxis de citas de Pandoc (`[@clave]`) a campos de cita activos de Zotero en archivos `.odt` y `.docx`, equivalentes a los que inserta la [extensión de procesadores de texto de Zotero](https://www.zotero.org/support/word_processor_integration). El resultado es un documento de ofimática con citas vinculadas a la biblioteca de Zotero, que el usuario puede seguir editando desde Writer o Word con el complemento de Zotero instalado.

Se usa exclusivamente en el flujo de salida hacia `.odt`, declarado en `odt.yaml`. Zotero se tiene que estar ejecutando cuando el documento se compila. No es compatible con Citeproc en el mismo pipeline: cuando se usa `zotero.lua`, Citeproc no debe declararse en `filters`.

```yaml
filters:
  - include-files.lua
  - zotero.lua
```

LibreOffice Writer tiene un *bug* que impide reconocer las citas en archivos `.docx` generados con este filtro, por lo que en ese entorno hay que exportar a `.odt`. Microsoft Word no tiene este problema y admite los `.docx` sin restricciones.[^1]

[^1]: Véase la [documentación de Heyns](https://retorque.re/zotero-better-bibtex/exporting/pandoc/index.html#from-markdown-to-zotero-live-citations) para más detalles sobre este comportamiento.
