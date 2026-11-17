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

Es importante que Citeproc vaya después de cualquier filtro que pueda generar o modificar citas, y antes de los filtros que operan sobre el texto ya resuelto.

La bibliografía se configura mediante las variables `bibliography` y `csl` del documento o del archivo de defaults:

```yaml
bibliography: biblioteca.json
csl: chicago-notes-bibliography
```

Si `csl` no está declarado, citeproc usa el estilo _Chicago_ autor-fecha por defecto.

Las variables que controlan el comportamiento de la bibliografía y las citas se declaran en los metadatos del documento:

| Variable | Tipo | Efecto |
|---|---|---|
| `reference-section-title` | cadena | Título de la sección de bibliografía |
| `suppress-bibliography` | booleano (`false`) | Suprime la generación de la bibliografía |
| `link-citations` | booleano (`false`) | Añade hipervínculos de las citas a sus entradas en la bibliografía (solo en estilos autor-fecha y numéricos) |
| `link-bibliography` | booleano (`true`) | Convierte en hipervínculos los DOI, URL y similares de las entradas de la bibliografía |
| `notes-after-punctuation` | booleano (`true`) | En estilos de nota, mueve la llamada de nota al pie tras el signo de puntuación |
| `nocite` | lista de claves | Incluye entradas en la bibliografía sin que aparezcan citadas en el texto. `@*` incluye toda la bibliografía |
| `lang` | etiqueta BCP 47 | Idioma para la localización del estilo CSL |

La bibliografía se inserta por defecto al final del documento. Para controlar su posición, se puede usar un _div_ con el identificador `refs`:

```markdown
::: {#refs}
:::
```

Para colocar esta sección fuera del cuerpo del documento (en las páginas finales, por ejemplo), se puede poner el _div_ en una variable arbitraria (llamémosla `refs`)

```yaml
refs: |
  ::: {#refs}
  :::
```

y usar esta en la plantilla

```tex
\backmatter

$if(refs)$
$refs$
$endif$
```

`reference-section-title` solo tiene efecto cuando Citeproc añade la bibliografía al final del documento así que puede ser apropiado poner un título a la sección y una explicación manualmente:

```yaml
refs: |
  ::: {#refs}
  # Referencias {-}
  
  Las referencias se dividen en fuentes primarias y secundarias.
  :::
```

Si se quieren incluir en la bibliografía referencias que, por lo que sea, no están citadas en el texto, se pueden poner en una variable arbitraria (llamémosla `nocite`)

```yaml
nocite: |
  @item1, @item2
```

Para hacer esto con todas las referencias, se puede usar un comodín `@*`

```yaml
nocite: |
  @*
```

### pandoc-crossref

[`pandoc-crossref`](https://github.com/lierdakil/pandoc-crossref) es un filtro externo de Nikolay Yakimov para remisiones a figuras, cuadros, listados y ecuaciones. Asigna números correlativos a los elementos etiquetados y sustituye las referencias en el texto por los identificadores formateados.

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

Los cuadros, añadiendo el atributo a continuación del pie:

```markdown
: Pie de cuadro {#tbl:datos}

| Col A | Col B |
|-------|-------|
| 1     | 2     |
```

Los listados de código, con el identificador y el pie como atributos del bloque:

````markdown
```{#lst:saludo .python caption="Saludo en Python"}
print("hola")
```
````

Las remisiones en el texto tienen esta sintaxis:

```markdown
Como se aprecia en @fig:mapa, la distribución es irregular.

Véase el @tbl:datos para los valores completos, y el @lst:saludo para el código.
```

Los prefijos y títulos de sección se declaran localizados al español en el bloque `metadata`, con los mismos nombres que usa babel. `listings: true` hace que los listados se compongan con el paquete `listings`, el modo que activa `syntax-highlighting: idiomatic` (véase [`plantilla`](plantilla.md#código-y-listados)); sin ella, crossref anida el listado dentro de otro flotante y duplica el pie.

```yaml
metadata:
  listings: true
  figureTitle: "Figura"
  tableTitle: "Cuadro"
  listingTitle: "Listado"
  figPrefix:
    - "fig."
    - "figs."
  tblPrefix:
    - "cuadro"
    - "cuadros"
  lstPrefix:
    - "listado"
    - "listados"
  eqnPrefix:
    - "ec."
    - "ecs."
  lofTitle: "Índice de figuras"
  lotTitle: "Índice de cuadros"
  lolTitle: "Índice de listados"
```

* * *

## Filtros Lua

### include-files.lua

[`include-files.lua`](https://github.com/pandoc-ext/include-files) es un filtro de Albert Krewinkel. Permite componer un documento a partir de múltiples archivos Markdown, incluyendo unos dentro de otros mediante bloques de código de clase `include`. Es el mecanismo central para estructurar trabajos extensos en capítulos independientes.

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

El filtro ajusta automáticamente las rutas relativas de enlaces e imágenes dentro de los archivos incluidos, de modo que se resuelven correctamente desde la ubicación del archivo incluido, no desde el documento principal.

### custom-divs.lua

`custom-divs.lua` convierte divs con la clase `noindent` a un grupo LaTeX sin sangría de primera línea. Útil para párrafos que siguen a elementos no textuales (listas, tablas, figuras, citas exentas) y que, por convención tipográfica, no deben llevar sangría aunque el documento use sangría por defecto.

El filtro solo actúa en la salida LaTeX; en otros formatos el div se ignora sin generar código adicional.

```markdown
::: {.noindent}
Párrafo sin sangría de primera línea.
:::
```

El filtro envuelve el contenido del div en `{\parindent0pt … }` en lugar de usar `\noindent`, porque `\noindent` solo afecta al párrafo inmediatamente siguiente; si el div contiene varios párrafos, los sucesivos recuperarían la sangría normal.

### suprimir-citas.lua

`suprimir-citas.lua` quita las citas del texto y las deja solo en la bibliografía. `citeproc` tiene la opción contraria con `suppress-bibliography`, pero esta no. La opción `nocite` añade a la bibliografía entradas no citadas, pero no oculta las citadas.

El filtro pasa todas las citas del documento a `nocite` y las borra del texto, junto con el espacio que las precede. Si una nota al pie solo contenía una cita, la nota se quita entera. Funciona con cualquier estilo, de autor-fecha o de notas. Solo actúa si el documento lo pide en sus metadatos:

```yaml
suppress-citations: true
```

Debe declararse antes de Citeproc, que si no ya habría resuelto las citas:

```yaml
filters:
  - suprimir-citas.lua
  - citeproc
```

Con las citas narrativas desaparece también el nombre del autor: `según @clave` queda «según». En esos casos hay que escribir el nombre a mano.

### dividir-bibliografia.lua

`dividir-bibliografia.lua` permite dividir la bibliografía en varios grupos. No sustituye a Citeproc, sino que se ejecuta después y reparte las entradas de la bibliografía que este ha generado.

```yaml
filters:
  - citeproc
  - dividir-bibliografia.lua
```

Los grupos se declaran, por orden, en la variable `reference-sections`. Cada grupo tiene un título (`title`) y, opcionalmente, uno o varios archivos (`file`) de los que solo se leen las claves. Se admiten CSL JSON, CSL YAML, BibLaTeX y RIS, y se buscan como el resto de recursos (en el `resource-path`).

```yaml
reference-sections:
  - title: Legislación
    file: legislación.json
  - title: Ludografía
    file: [juegos.json, manuales.bib]
  - title: Bibliografía
```

Cada entrada va al primer grupo cuyos archivos la contienen; si no está en ninguno, al primer grupo sin `file`, que recoge el resto. Si no hay grupo para el resto, las entradas sobrantes quedan al final, sin encabezado, y el filtro lo avisa. Dentro de cada grupo se mantiene el orden de Citeproc.

Cada grupo se imprime con su título como encabezado sin numerar, un nivel por debajo del título de la bibliografía, en el sitio donde Citeproc ha puesto la bibliografía.

Para una disposición distinta (por ejemplo, grupos a distintos niveles), un grupo con `id` se coloca en el _div_ `refs-<id>` del documento, si existe; los encabezados se escriben entonces a mano:

```yaml
reference-sections:
  - title: Juegos
    file: juegos.json
    id: juegos
refs: |
  # Referencias {-}

  ## Materiales de clase {-}

  ### Juegos {-}

  ::: {#refs-juegos}
  :::
```

### ajustes-citeproc.lua

`ajustes-citeproc.lua` corrige comportamientos de Citeproc que no se pueden cambiar desde el estilo CSL ni desde el locale. Solo actúa sobre el texto de las citas que ha generado Citeproc, por lo que no toca el texto propio del documento (tampoco el de las notas al pie) ni la bibliografía. No depende del idioma, así que se puede usar en cualquier documento. Debe declararse después de Citeproc:

```yaml
filters:
  - citeproc
  - ajustes-citeproc.lua
```

Por ahora hace un único ajuste: **respeta el signo con que se escriben los rangos de los localizadores**. Citeproc cambia el signo de los rangos del localizador (lo que va tras la coma en `[@clave, párr. 3-5]`) según su tipo:

- En las páginas (`p.`, `pp.` o sin tipo), usa el término `page-range-delimiter` del locale: guion en `es-ES`, semirraya en `en-US`.
- En los demás tipos (párrafo, sección, capítulo…), pone siempre semirraya, sin consultar el locale ni el estilo.

El filtro pone en cada rango el signo que se escribió en el Markdown, sea guion o semirraya (`--`, con la extensión `smart`, cuenta como semirraya). Lo demás sigue siendo cosa de Citeproc: el término del localizador (`párr.`, `cap.`…) y la abreviatura de los rangos de páginas que pida el estilo (Chicago escribe `321-28` por `321-328`).

| Se escribe | Citeproc (`es-ES`) | Con el filtro |
|---|---|---|
| `[@clave, párr. 3-5]` | párr. 3–5 | párr. 3-5 |
| `[@clave, párr. 3–5]` | párr. 3–5 | párr. 3–5 |
| `[@clave, cap. 3-5 y 7-9]` | cap. 3–5 y 7-9 | cap. 3-5 y 7-9 |
| `[@clave, pp. 3–5]` | 3-5 | 3–5 |
| `[@clave, pp. 321-328]` | 321-28 | 321-28 |

En español, por tanto, los rangos se escriben con guion, y así se imprimen.

El filtro localiza cada rango por su primera cifra dentro del texto de la cita. Si el título de la obra contiene un rango que empieza por la misma cifra que el del localizador (`[@clave, párr. 1914-1918]` en un libro titulado _La guerra de 1914–1918_), también cambia el signo de ese rango del título, aunque solo en esa cita.

### zotero.lua

[`zotero.lua`](https://retorque.re/zotero-better-bibtex/exporting/pandoc/) es un filtro de Emiliano Heyns. Convierte la sintaxis de citas de Pandoc (`[@clave]`) a campos de cita activos de Zotero en archivos `.odt` y `.docx`, equivalentes a los que inserta la [extensión de procesadores de texto de Zotero](https://www.zotero.org/support/word_processor_integration). El resultado es un documento de ofimática con citas vinculadas a la biblioteca de Zotero, que el usuario puede seguir editando desde Writer o Word con el complemento de Zotero instalado.

Sirve solo para la salida a `.odt`, ya que LibreOffice Writer tiene un _bug_ con las citas en los `.docx`[^1]. Zotero se tiene que estar ejecutando cuando el documento se compila. No es compatible con Citeproc en el mismo pipeline: cuando se usa `zotero.lua`, Citeproc no debe declararse en `filters`.

[^1]: LibreOffice Writer tiene, [como indica Heyns](https://retorque.re/zotero-better-bibtex/exporting/pandoc/index.html#from-markdown-to-zotero-live-citations) un _bug_ que impide reconocer las citas en archivos `.docx` generados con este filtro, por lo que en ese entorno hay que exportar a `.odt`. Microsoft Word no tiene este problema y admite los `.docx` sin restricciones.

```yaml
filters:
  - include-files.lua
  - zotero.lua
```
