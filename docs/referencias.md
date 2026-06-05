---
author: Carlos Llamedo
date: 2026-05-07
---

# Referencias y documentación del flujo de trabajo

## Entorno Pandoc

### Pandoc

[Pandoc](https://pandoc.org) es un programa con documentación alojada tanto en su [página web propia](https://pandoc.org) como en un [repositorio GitHub](https://github.com/jgm/pandoc). En el repositorio GitHub, están separados el [manual de uso](https://github.com/jgm/pandoc/blob/main/MANUAL.txt) del [resto de la documentación](https://github.com/jgm/pandoc/tree/main/doc).

Ambas fuentes son oficiales y válidas, y están bien mantenidas. Contienen:

- una guía de uso rápido ([web](https://pandoc.org/getting-started.html); [GitHub](https://github.com/jgm/pandoc/blob/main/doc/getting-started.md)),
- un manual de usuario ([web](https://pandoc.org/MANUAL.html); [GitHub](https://github.com/jgm/pandoc/blob/main/MANUAL.txt)),
- una guía para contribuciones ([web](https://pandoc.org/CONTRIBUTING.html); [GitHub](https://github.com/jgm/pandoc/blob/main/CONTRIBUTING.md)),
- un apartado de preguntas rápidas ([web](https://pandoc.org/faqs.html); [GitHub](https://github.com/jgm/pandoc/blob/main/doc/faqs.md)),
- un compendio de libros, artículos y blogs sobre el programa ([web](https://pandoc.org/press.html); [GitHub](https://github.com/jgm/pandoc/blob/main/doc/press.md)),
- un manual de filtros JSON ([web](https://pandoc.org/filters.html); [GitHub](https://github.com/jgm/pandoc/blob/main/doc/filters.md)),
- un manual de filtros Lua ([web](https://pandoc.org/lua-filters.html); [GitHub](https://github.com/jgm/pandoc/blob/main/doc/lua-filters.md)),
- una guía para crear lectores de formatos no soportados ([web](https://pandoc.org/custom-readers.html); [GitHub](https://github.com/jgm/pandoc/blob/main/doc/custom-readers.md)),
- una guía para renderizar formatos no soportados ([web](https://pandoc.org/custom-writers.html); [GitHub](https://github.com/jgm/pandoc/blob/main/doc/custom-writers.md)),
- un manual para `pandoc-server`, Pandoc como servidor web ([web](https://pandoc.org/pandoc-server.html); [GitHub](https://github.com/jgm/pandoc/blob/main/doc/pandoc-server.md)),
- una guía para crear libros electrónicos EPUB con Pandoc ([web](https://pandoc.org/epub.html); [GitHub](https://github.com/jgm/pandoc/blob/main/doc/epub.md)),
- una guía para usar Pandoc con ficheros ORG ([web](https://pandoc.org/org.html); [GitHub](https://github.com/jgm/pandoc/blob/main/doc/org.md)),
- una guía para gestionar ficheros JATS ([web](https://pandoc.org/jats.html); [GitHub](https://github.com/jgm/pandoc/blob/main/doc/jats.md)),
- una guía para ficheros TYPST ([web](https://pandoc.org/typst-property-output.html); [GitHub](https://github.com/jgm/pandoc/blob/main/doc/typst-property-output.md)),
- una guía para usar la API de Pandoc ([web](https://pandoc.org/using-the-pandoc-api.html); [GitHub](https://github.com/jgm/pandoc/blob/main/doc/using-the-pandoc-api.md); [tiene su propia página de documentación](https://hackage.haskell.org/package/pandoc)),
- una lista de recursos de terceros que usar con Pandoc ([web](https://pandoc.org/extras.html); [GitHub](https://github.com/jgm/pandoc/blob/main/doc/extras.md))

Además de eso, en el repositorio de GitHub hay:

- una guía para configurar de varias maneras la salida de Pandoc ([GitHub](https://github.com/jgm/pandoc/blob/main/doc/customizing-pandoc.md)),
- una lista de las librerías desarrolladas en torno a Pandoc ([GitHub](https://github.com/jgm/pandoc/blob/main/doc/libraries.md)),
- una guía para usar NiX junto con Pandoc ([GitHub](https://github.com/jgm/pandoc/blob/main/doc/nix.md)),
- una guía para `pandoc-lua`, la interfaz de Lua de la API de Pandoc ([GitHub](https://github.com/jgm/pandoc/blob/main/doc/pandoc-lua.md)),
- una guía al código fuente de Pandoc ([GitHub](https://github.com/jgm/pandoc/blob/main/doc/short-guide-to-pandocs-sources.md)),
- una guía al formato XML de Pandoc ([GitHub](https://github.com/jgm/pandoc/blob/main/doc/xml.md)).

**Sin conexión:** `pandoc --help` · `man pandoc`

### Filtros de Pandoc

#### Citeproc

[Citeproc](https://github.com/jgm/citeproc) es una librería Haskell escrita por John McFarlane. Es una reescritura de `pandoc-citeproc`, que a su vez era una derivación de la librería `citeproc-hs` de Andrea Rossato. En su repositorio GitHub [se puede consultar el manual completo](https://github.com/jgm/citeproc/blob/master/man/).

En cualquier caso, la sección [«Citations»](https://pandoc.org/MANUAL.html#citations) y [«Citation syntax»](https://pandoc.org/MANUAL.html#citation-syntax) del manual de Pandoc cubren bastante bien el uso de la librería.

**Sin conexión:** `man citeproc`

#### Citation Style Language

La documentación de la especificación [Citation Style Language](https://citationstyles.org/) (CSL) se puede ver [en web](https://docs.citationstyles.org/en/stable/specification.html) y [en su repositorio propio en GitHub](https://github.com/citation-style-language/documentation). Contiene:

- una introducción a CSL ([web](https://docs.citationstyles.org/en/stable/primer.html); [GitHub](https://github.com/citation-style-language/documentation/blob/master/primer.rst)),
- una guía para la traducción de los estilos ([web](https://docs.citationstyles.org/en/stable/translating-locale-files.html); [GitHub](https://github.com/citation-style-language/documentation/blob/master/translating-locale-files.rst)),
- la especificación CSL completa ([web](https://docs.citationstyles.org/en/stable/specification.html); [GitHub](https://github.com/citation-style-language/documentation/blob/master/specification.rst)).

Todos los estilos de citación son accesibles desde [el repositorio](https://github.com/citation-style-language), aunque el [repositorio de estilos de Zotero](https://www.zotero.org/styles), que se actualiza constantemente, es una forma más fácil de navegar y comparar.

#### pandoc-crossref

La documentación de [`pandoc-crossref`](https://github.com/lierdakil/pandoc-crossref) se puede ver [en web](https://lierdakil.github.io/pandoc-crossref/) y [en el directorio `docs/` de su repositorio de GitHub](https://github.com/lierdakil/pandoc-crossref/blob/master/docs/).

Cada [binario precompilado](https://github.com/lierdakil/pandoc-crossref/releases/latest) incluye el manual `pandoc-crossref.1`.

**Sin conexión:** `pandoc-crossref --help` · `man pandoc-crossref`

### Filtros Lua de Pandoc

#### zotero.lua

El filtro [`zotero.lua`](https://github.com/retorquere/zotero-better-bibtex/blob/master/site/content/exporting/zotero.lua) e información sobre él siempre me resulta difícil de encontrar. Está alojado [en web](https://retorque.re/zotero-better-bibtex/exporting/zotero.lua), y [en el repositorio de GitHub de Better BibTeX](https://github.com/retorquere/zotero-better-bibtex/blob/master/site/content/exporting/zotero.lua), aunque parece que una versión antigua del filtro, junto con otras cosas, reside en [el directorio `pandoc/` del repositorio](https://github.com/retorquere/zotero-better-bibtex/tree/master/pandoc).

Documentación sobre su uso se puede encontrar en [el sitio web de Better BibTeX](https://retorque.re/zotero-better-bibtex/exporting/pandoc/index.html#from-markdown-to-zotero-live-citations), así como en [su repositorio GitHub en `site/content/exporting/`](https://github.com/retorquere/zotero-better-bibtex/blob/master/site/content/exporting/pandoc.md).

#### noindent.lua

Aunque el filtro es una reescritura propia, está inspirado por la funcionalidad implementada por Thomas Duck en su [repositorio `pandoc-latex-extensions`](https://github.com/tomduck/pandoc-latex-extensions/tree/master). Hay unas cuantas extensiones con ideas muy interesantes; `noindent.lua`, concretamente, está inspirado en su [`noindent.py`](https://github.com/tomduck/pandoc-latex-extensions/blob/master/pandoclatexextensions/plugins/noindent.py).

#### multibib.lua

Este pequeño filtro [`multibib.lua`](https://github.com/pandoc-ext/multibib) no tiene, realmente, más documentación que [el README del proyecto](https://github.com/pandoc-ext/multibib/blob/main/README.md).

#### include-files.lua

Al igual que sucede con `multibib.lua`, no parece que [`include-files.lua`](https://github.com/pandoc-ext/include-files) tenga más documentación que [el README de su repositorio](https://github.com/pandoc-ext/include-files/blob/main/README.md).

### Plantillas

#### Plantillas oficiales de Pandoc

Pandoc tiene un repositorio propio con [las plantillas que utiliza el programa](https://github.com/jgm/pandoc-templates). Este proyecto lo incluye como submódulo.

#### Kieran Healy

Healy tiene muchos y excelentes recursos sobre Pandoc, R y la autoría en texto plano. Se incluyen como submódulo las [plantillas que tiene para Pandoc](https://github.com/kjhealy/pandoc-templates).

#### Andrew Dunning

Incluyo una plantilla, originalmente de Iago Mosqueira (como se indica en el propio archivo) y con [modificaciones hechas por Andrew Dunning](https://github.com/adunning/benedict-rule-doyle). El archivo aparece en varios repositorios de Dunning, he tomado el más reciente a esta fecha.

## Zettlr

[Zettlr](https://www.zettlr.com) ofrece traducciones hechas por la comunidad de su propia documentación, pero la única oficial y que garantiza estar actualizada y mantenida es la versión inglesa: [web](https://docs.zettlr.com/en/); [GitHub](https://github.com/Zettlr/zettlr-docs/tree/master/docs/en).

**Sin conexión:** Zettlr se empaqueta con un tutorial que se puede consultar siempre en local, pero la documentación completa hay que consultarla en línea.

## Zotero

La documentación de [Zotero](https://www.zotero.org/) se puede ver [en web](https://www.zotero.org/support/) y en [su repositorio de GitHub propio](https://github.com/zotero/zotero-docs/tree/main). Aunque es bastante extensa, cabe señalar [la sección de tipos de elemento y campos](https://www.zotero.org/support/kb/item_types_and_fields) dentro de ella.

## Better BibTeX

La documentación de la [extensión Better BibTeX](https://retorque.re/zotero-better-bibtex/) se puede ver [en web](https://retorque.re/zotero-better-bibtex/) y [en su repositorio de GitHub](https://github.com/retorquere/zotero-better-bibtex/tree/master). En este último, la documentación se encuentra concretamente bajo [`site/content`](https://github.com/retorquere/zotero-better-bibtex/tree/master/site/content).
