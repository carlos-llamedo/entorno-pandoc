---
author: Carlos Llamedo
date: 2026-05-22
---

# Avisos de licencia

Este archivo recopila los términos de uso y procedencia de todos los componentes del flujo de trabajo documentado en este repositorio, tanto los incluidos directamente como los externos. Los elementos marcados con `*` están incluidos en el repositorio y cuentan con el texto completo de su licencia en este mismo directorio. No se incluye la licencia de archivos que están incluidos como submódulos.

## Entorno Pandoc

### Pandoc

[Pandoc](https://pandoc.org) está, [de acuerdo con su README](https://github.com/jgm/pandoc#license), bajo una licencia GPLv2-or-later. El repositorio contiene un archivo [COPYING](https://github.com/jgm/pandoc/blob/main/COPYING.md) y otro [COPYRIGHT](https://github.com/jgm/pandoc/blob/main/COPYRIGHT), con concreciones sobre cada uno de sus componentes.

### Filtros de Pandoc

#### Citeproc

La librería [`citeproc`](https://github.com/jgm/citeproc), de John MacFarlane, está [bajo una licencia BSD 2-Clause “Simplified”](https://github.com/jgm/citeproc/blob/master/LICENSE).

#### Citation Style Language\*

En el caso del [Citation Style Language](https://citationstyles.org/) (CSL), tenemos tres elementos distintos:

- Por un lado, tenemos los propios archivos CSL. Aunque lo declaran cada uno al principio del propio archivo, el README especifica que todos los estilos del repositorio están [bajo una licencia Creative Commons Attribution-ShareAlike 3.0 Unported](https://github.com/citation-style-language/styles#licensing).
- Los archivos de localización (léase «traducción») están [sujetos a la misma licencia Creative Commons Attribution-ShareAlike 3.0 Unported](https://github.com/citation-style-language/locales#licensing).
- La documentación está bajo una licencia Creative Commons Attribution-ShareAlike 4.0 International ([README](https://github.com/citation-style-language/documentation/tree/master#licensing); [archivo de la licencia en el repositorio](https://github.com/citation-style-language/documentation/blob/master/LICENSE.txt)).

#### pandoc-crossref

[`pandoc-crossref`](https://github.com/lierdakil/pandoc-crossref) está bajo una licencia GPLv2-or-later ([README](https://github.com/lierdakil/pandoc-crossref#license); [archivo de la licencia en el repositorio](https://github.com/lierdakil/pandoc-crossref/blob/master/LICENSE)).

### Filtros Lua de Pandoc

#### zotero.lua\*

Todo el repositorio de Better BibTeX (y por tanto [el filtro `zotero.lua`](https://github.com/retorquere/zotero-better-bibtex/blob/master/site/content/exporting/zotero.lua) y su documentación) está [bajo una licencia MIT](https://github.com/retorquere/zotero-better-bibtex/blob/master/LICENSE), Copyright © 2016 Emiliano Heyns.

#### noindent.lua

El filtro `noindent.lua` es, en realidad, código propio inspirado en el trabajo de Duck. Todo el [repositorio `pandoc-latex-extensions`](https://github.com/tomduck/pandoc-latex-extensions) está bajo la licencia [GPLv3](https://github.com/tomduck/pandoc-latex-extensions/blob/master/LICENSE).

#### multibib.lua\*

[`multibib.lua`](https://github.com/pandoc-ext/multibib) está publicado bajo una licencia MIT ([README](https://github.com/pandoc-ext/multibib#license); [archivo de licencia en el repositorio](https://github.com/pandoc-ext/multibib/blob/main/LICENSE)), Copyright © 2018-2024 Albert Krewinkel and contributors.

#### include-files.lua\*

[`include-files.lua`](https://github.com/pandoc-ext/include-files) está publicado bajo una [licencia MIT](https://github.com/pandoc-ext/include-files/blob/main/LICENSE), Copyright © 2023 Pandoc Extensions.

### Plantillas

#### Plantillas oficiales de Pandoc

El [README](https://github.com/jgm/pandoc-templates/blob/master/README.markdown) del [repositorio](https://github.com/jgm/pandoc-templates) indica que las plantillas están bajo una licencia doble: GPLv2-or-later, al igual que Pandoc, y la BSD 3-Clause.

#### Kieran Healy

El [repositorio de Healy](https://github.com/kjhealy/pandoc-templates) no tiene una licencia declarada.

#### Andrew Dunning\*

El [repositorio de Dunning](https://github.com/adunning/benedict-rule-doyle) que incluye la versión que tomé está bajo una licencia [CC 0 Universal](https://github.com/adunning/benedict-rule-doyle/blob/master/LICENSE).

## Zettlr

Tanto el código de [Zettlr](https://www.zettlr.com) ([README](https://github.com/Zettlr/Zettlr#license); [archivo de la licencia en el repositorio](https://github.com/Zettlr/Zettlr/blob/develop/LICENSE)) como la documentación de Zettlr están bajo una licencia GPLv3 ([README](https://github.com/Zettlr/zettlr-docs/tree/master#license); [archivo de la licencia en el repositorio](https://github.com/Zettlr/zettlr-docs/blob/master/LICENSE)).

## Zotero

El [código](https://github.com/zotero/zotero) de [Zotero](https://www.zotero.org/) está bajo una [licencia AGPLv3](https://github.com/zotero/zotero/blob/main/COPYING). Sin embargo [su documentación](https://github.com/zotero/zotero-docs) está bajo una doble licencia: el código bajo una [AGPLv3](https://github.com/zotero/zotero-docs/blob/main/LICENSE), y el contenido (todo lo contenido en el directorio `content/`), bajo una licencia [CC BY-SA 4.0](https://github.com/zotero/zotero-docs/blob/main/LICENSE-CONTENT).

## Better BibTeX

Todo el repositorio de [Better BibTeX](https://retorque.re/zotero-better-bibtex/) (y por tanto la extensión y su documentación) está [bajo una licencia MIT](https://github.com/retorquere/zotero-better-bibtex/blob/master/LICENSE), Copyright © 2016 Emiliano Heyns.
