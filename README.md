---
title: Entorno de datos de Pandoc
author: Carlos Llamedo
date: 2026-04
---

# Entorno de datos de Pandoc

Este repositorio contiene los datos y elementos necesarios para escribir en Markdown y producir a partir de ellos documentos en otros formatos, como PDF.

## Los procesadores de texto son estúpidos e ineficientes

En su polémico artículo *Word Processors: Stupid and Inefficient*[^1], Cottrell 

[^1]: Allin Cottrell, *Word Processors: Stupid and Inefficient*, 1999, <http://cda.psych.uiuc.edu/latex_class_material/wp.html>.

## Dependencias externas

El repositorio es bastante autocontenido, pero hay *software* sin el que el flujo simplemente no funciona y que hay que instalar. Qué es cada uno de estos programas, cómo interviene en el flujo y cómo se relaciona con los ficheros contenidos aquí se explica con más detalle en [la documentación de las dependencias](docs/dependencias.md).

- [`pandoc`](https://pandoc.org/installing.html)
- [`citeproc`](https://github.com/jgm/citeproc) (está integrado en el binario de Pandoc)
- [`pandoc-crossref`](https://github.com/lierdakil/pandoc-crossref/releases/latest)
- [`TeX`](https://ctan.org/starter) o [`LaTeX`](https://www.latex-project.org/get/)
- [`LuaTeX`](https://www.luatex.org/download.html)

En el caso de `pandoc` y `pandoc-crossref`, hay bastante variabilidad en cómo de actualizados están los paquetes en distintos gestores. Es importante, además, que los dos paquetes estén hechos para la misma versión. En [Homebrew](https://formulae.brew.sh/formula/pandoc) (macOS) parecen estar bastante actualizados, pero en [Ubuntu](https://packages.ubuntu.com/resolute/pandoc), por ejemplo, van varias versiones por detrás. En caso de duda, comparar la versión ofrecida del paquete con la última en el repositorio oficial. Si estuviera muy por detrás, se puede simplemente descargar el binario precompilado y añadirlo al `PATH`.

## Submódulos

Se incluyen como submódulos de Git dos proyectos que conviene tener a mano:

- [`pandoc-templates`](https://github.com/jgm/pandoc-templates), que contiene [las plantillas](templates/pandoc-templates/) que Pandoc usa por defecto en todos los formatos soportados.
- El repositorio [`pandoc-templates` de Kieran Healy](https://github.com/kjhealy/pandoc-templates), que contiene [plantillas y recursos](templates/kjhealy/) estupendos que usar como referencia.

## Derechos

Este repositorio está bajo una [licencia MIT](LICENCE.md).

El archivo [`NOTICES`](licences/NOTICES.md) hace un inventario completo de los derechos que aplican a cada uno de los elementos que intervienen en el flujo de trabajo, que son libres y abiertos. De ellos, sin embargo, hay que señalar los que se incluyen directamente en este repositorio, y que tienen su texto legal en [`licences/`](licences/):

|  Archivo |  Autor |  Licencia |
|---|---|---|
|  `include-files.lua` |  Albert Krewinkel |  [MIT](licences/MIT.md) |
|  `multibib.lua` |  Albert Krewinkel y contribuidores |  [MIT](licences/MIT.md) |
|  `zotero.lua` |  Emiliano Heyns |  [MIT](licences/MIT.md) |
|  `csl/` |  Citation Style Language |  [CC BY-SA 3.0 Unported](<licences/CC BY-SA 3.0 Unported.md>) |
|  `locales/` |  Citation Style Language |  [CC BY-SA 3.0 Unported](<licences/CC BY-SA 3.0 Unported.md>) |

Se trata de material de terceros con términos de uso propios, sobre el que este repositorio no reclama derechos.
