---
title: Entorno de datos de Pandoc
author: Carlos Llamedo
date: 2026-04
---

# Entorno de datos de Pandoc

Este repositorio contiene los datos y elementos necesarios para escribir en texto plano y producir a partir de estos archivos documentos en otros formatos, como PDF.

## Dependencias externas

El repositorio es bastante autocontenido, pero hay dependencias mínimas sin las que nada funciona, y que hay que instalar. Qué son estos programas y cómo se relacionan con las demás herramientas que intervienen en el flujo de trabajo —incluyendo las recomendadas para gestión bibliográfica y escritura— se explica con más detalle en [la documentación de las dependencias](docs/dependencias.md).

- [`pandoc`](https://pandoc.org/installing.html) con [`citeproc`](https://github.com/jgm/citeproc) (vienen empaquetados juntos)
- [`pandoc-crossref`](https://github.com/lierdakil/pandoc-crossref/releases/latest)
- Una distribución [`TeX`](https://ctan.org/starter) que incluya [`LuaTeX`](https://www.luatex.org/download.html)

En el caso de `pandoc` y `pandoc-crossref`, es importante que ambos estén compilados para la misma versión. Los paquetes de algunos gestores van por detrás de las versiones oficiales; en caso de error o de duda, la [documentación de dependencias](docs/dependencias.md) ofrece más información.

## Organización del repositorio

### Plantillas

El directorio [`templates/`](templates/) contiene las plantillas Pandoc usa para generar los documentos.

- [`memoir.tex`](templates/memoir.tex) es la plantilla principal. Está diseñada para memorias académicas con la clase `book` de LaTeX y es compatible con todas las preconfiguraciones que generan PDF. Sus variables, declarables en el encabezado YAML de cada documento, están documentadas en [`docs/plantilla.md`](docs/plantilla.md).
- [`dunning.tex`](templates/dunning.tex) es una plantilla ligera basada en la clase `tufte-handout`, útil para documentos breves con notas al margen. Obra de Andrew Dunning.

El repositorio incluye también los archivos XML para construir `memoir.odt`, una plantilla para documentos ODT con aspecto parecido al de los PDF generados por `memoir.tex`. Los formatos `.odt` y `.docx` son archivos XML comprimidos; el directorio [`odt/`](templates/odt/) contiene esos archivos, que hay que empaquetar manualmente en `memoir.odt` y colocar en [`templates/`](templates/). El archivo construido **no se incluye en el repositorio** por ser un binario.

### Filtros

El directorio [`filters/`](filters/) contiene los filtros Lua que transforman el documento durante la compilación. [`referencias.md`](docs/referencias.md) incluye dónde buscar la documentación exhaustiva de los filtros de terceros, aunque una guía de uso básica, tanto de los propios como de los ajenos, se da en [`filtros.md`](docs/filtros.md).

- [`include-files.lua`](filters/include-files.lua). Permite incluir un archivo Markdown dentro de otro, lo que facilita dividir textos largos en varios archivos. De Albert Krewinkel.
- [`multibib.lua`](filters/multibib.lua). Genera bibliografías múltiples y separadas en lugar de una única en un documento Markdown. De Albert Krewinkel.
- [`noindent.lua`](filters/noindent.lua). Convierte *divs* con clase `.noindent` en bloques LaTeX sin sangría de primera línea. Útil para indicar cuándo un párrafo tras una lista o una cita exenta es continuación del anterior, y no uno nuevo.
- [`correcciones-notas.lua`](filters/correcciones-notas.lua). Aplica correcciones tipográficas del español dentro de las notas al pie construidas por `citeproc`: sustituye `párr.` y `sec.` por `§` para conservar el símbolo y normaliza las semirrayas (anglicismo ortográfico) en rangos numéricos, convirtiéndolas a guiones.
- [`zotero.lua`](filters/zotero.lua). Permite convertir la [sintaxis de la extensión `citations` de Pandoc](https://pandoc.org/MANUAL.html#citation-syntax) a campos de cita de Zotero en archivos `.odt` y `.docx`, tal y como si se hubieran insertado con la [extensión de procesadores de texto de Zotero](https://www.zotero.org/support/word_processor_integration)[^1]. De Emiliano Heyns.

[^1]: Tal como [documenta Heyns](https://retorque.re/zotero-better-bibtex/exporting/pandoc/index.html#from-markdown-to-zotero-live-citations), LibreOffice Writer tiene un *bug* que impide reconocer las citas en archivos `.docx`, por lo que hay que usar `.odt`. Si se usa Microsoft Word, no hay ningún problema con las citas en los `.docx`.

### Referencias bibliográficas

En lugar de formatear manualmente las citas, `citeproc` es capaz de generar referencias en texto junto con su bibliografía en cualquier estilo. Lo único que necesita es un documento con referencias en la [sintaxis de la extensión `citations` de Pandoc](https://pandoc.org/MANUAL.html#citation-syntax); un [archivo de bibliografía](https://pandoc.org/MANUAL.html#specifying-bibliographic-data) en uno de los formatos admitidos (BibLaTeX, BibTeX, CSL JSON, CSL YAML o RIS); y, si se quiere, un [archivo de estilo CSL](https://www.zotero.org/styles) (si no se indica, se usa *Chicago* autor-fecha).

#### Archivo de bibliografía

La gestión de bibliografía se apoya en [Zotero](https://www.zotero.org/) con [Better BibTeX](https://retorque.re/zotero-better-bibtex/). A través de ellos se genera y mantiene actualizado `${USERDATA}/biblioteca.json`, una exportación global de toda la biblioteca en formato CSL JSON que algunas preconfiguraciones —como [`memoria.yaml`](defaults/memoria.yaml) o [`notas.yaml`](defaults/notas.yaml)— requieren. La justificación de esta decisión está en [`dependencias.md`](docs/dependencias.md).

El archivo `biblioteca.json` no se incluye en el repositorio, pero **cada usuario tienen que crear su propia exportación** en el directorio de datos de Pandoc.

#### Archivos de estilo CSL y de localización

El directorio [`csl/`](csl/) contiene los estilos de citación y el directorio [`locales/`](locales/) los archivos de localización (léase «traducción»). Ambos forman parte del estándar [Citation Style Language](https://citationstyles.org/), que es el sistema que usa `citeproc` para formatear las referencias.

Los [estilos](https://www.zotero.org/styles) determinan el formato de las citas: qué información se muestra, en qué orden, con qué separadores y con qué puntuación. Este repositorio incluye los estilos más habituales en humanidades y ciencias sociales:

- `chicago-notes-bibliography`. *Chicago* 18.ª ed. con notas al pie y bibliografía final. Estándar en humanidades.
- `chicago-shortened-notes-bibliography`. Variante de *Chicago* 18.ª ed. con notas abreviadas a partir de la segunda cita.
- `chicago-author-date`. *Chicago* 18.ª ed. autor-fecha. Es también el más adecuado para bibliografías autónomas.
- `mhra-notes`: *MHRA* 4.ª ed. con notas al pie, alternativa británica al *Chicago* de notas.
- `mhra-shortened-notes`: variante de *MHRA* 4.ª ed. con notas abreviadas.
- `mhra-author-date`: *MHRA* 4.ª ed. autor-fecha.
- `apa`. *APA* 7.ª ed. Estilo autor-fecha, estándar en ciencias sociales.

Las [localizaciones](https://github.com/citation-style-language/locales) adaptan los estilos al idioma del documento: traducen cadenas fijas como «ed.», «vol.» o «et al.» y aplican las convenciones tipográficas propias de cada lengua. Sin el archivo de localización correspondiente, `citeproc` recurre al inglés estadounidense por defecto. El repositorio incluye `es-ES`. `en-GB`, `fr-FR` y `en-US`.

### Preconfiguraciones

El directorio [`defaults/`](defaults/) contiene archivos preconfigurados para tareas específicas. El archivo [`filtros.md`](docs/filtros.md) da instrucciones sobre qué sintaxis concreta usan.

- [`memoria.yaml`](defaults/memoria.yaml). Sería la opción por defecto: toma un documento Markdown y lo convierte en un PDF. Utiliza, en este orden:
    - `include-files.lua`
    - `pandoc-crossref`
    - `noindent.lua`
    - `citeproc`
    - `correcciones-notas.lua`
- [`multibib.yaml`](defaults/multibib.yaml) es un caso anejo a `memoria.yaml`. Se usa cuando, en lugar de un único bloque de referencias bibliográficas, se considera oportuno dividirlas en secciones distintas. En lugar de `citeproc` usa `multibib.lua`.
- [`odt.yaml`](defaults/odt.yaml) genera un documento ODT (un formato abierto equivalente al `.docx` de Microsoft Word) parecido a los PDF generados a partir de `memoir.tex`.
- [`biblio.yaml`](defaults/biblio.yaml) toma un archivo de bibliografía (BibLaTeX, CSL JSON, etc.) y lo formatea en un PDF a partir de `memoir.tex`. El estilo usado es *Chicago* autor-fecha.
- [`notas.yaml`](defaults/notas.yaml). 

### *Scripts*

El directorio [`scripts/`](scripts/) contiene utilidades de mantenimiento y actualización.

- [`actualizar-csl.sh`](scripts/actualizar-csl.sh). Descarga las versiones más recientes de los estilos CSL incluidos en el repositorio desde el repositorio oficial de Citation Style Language.
- [`actualizar-locales.sh`](scripts/actualizar-locales.sh). Hace lo propio con los archivos de localización.

### Documentación

El directorio [`docs/`](docs/) contiene la documentación técnica de consulta:

- [`dependencias.md`](docs/dependencias.md). Qué es cada herramienta, cómo instalarla y cómo se relaciona con el resto del flujo de trabajo.
- [`plantilla.md`](docs/plantilla.md). Referencia completa de las variables YAML de `memoir.tex`.
- [`filtros.md`](docs/filtros.md). Instrucciones de uso de los filtros con sintaxis específica de cada uno.
- [`referencias.md`](docs/referencias.md). Inventario de fuentes documentales del flujo de trabajo: dónde está la documentación oficial de cada componente.
- [`markdown.md`](docs/markdown.md). Extensiones de Markdown activas en este flujo y qué hacen.

### Submódulos

Se incluyen como submódulos de Git dos proyectos que conviene tener a mano:

- [`pandoc-templates`](https://github.com/jgm/pandoc-templates), que contiene [las plantillas](templates/pandoc-templates/) que Pandoc usa por defecto en todos los formatos soportados.
- [`pandoc-templates` de Kieran Healy](https://github.com/kjhealy/pandoc-templates), que contiene [plantillas y recursos](templates/kjhealy/) útiles como referencia.

## Justificación teórica

En su polémico artículo *Word Processors: Stupid and Inefficient*[^2], Cottrell 

[^2]: Allin Cottrell, *Word Processors: Stupid and Inefficient*, 1999, <http://cda.psych.uiuc.edu/latex_class_material/wp.html>.

vale. antes de hacer el diagrama, que ya veré cómo lo hago, voy a escribir la parte argumentativa. para mí, el README del documento se debería estructurar así

1. Header y brevísima descripción de qué es este proyecto.
2. Justificación teórica. Qué sentido tiene este proyecto, a qué necesidades responde, qué ventajas presenta y qué limitaciones.
3. Cómo ponerlo en marcha con lo mínimo. Dependencias externas
4. Ahora mismo tengo una explicación de los submódulos. Seguramente esto se debería encuadrar en una explicación un poco más amplia de cómo está organizado el repositorio.
5. Derechos

El punto 2 es el más argumentativo de todos. Aquí va una serie de elementos, no ordenados, de cosas que querría decir para acordarme y organizarlo

- Notar el poco cuidado que, en general, se tiene por cómo se componen textos cuando hay gente que se dedica profesionalmente a ello. Omnipotencia de Microsoft Word.
- Hacer explícito lo implícito. Diferencia entre procesadores de texto (edición tipo WYSIWYG) y editores de texto. Hacer breve recorrido histórico por la historia de los procesadores de texto. Electric Pencil, WordStar, WordPerfect, Microsoft Word, Adobe InCopy, Pages, Google Docs, Scrivener, OpenOffice Writer y LibreOffice Writer.
- Poner anécdota de que en 2014 George R. R. Martin dijo en el programa de Conan O'Brien que escribía en WordStar en un MS-DOS.
- El texto plano como documento básico. No se requieren herramientas específicas para procesarlo más allá de que se entienda Unicode. Explicar Unicode, su origen histórico. Explicar un archivo DOCX o incluso uno abierto ODT como empaquetamientos de archivos XML, bastante difícilmente legibles sin el software específico. Eso abre la puerta a obsolescencia y a paywalls mediante software privativo que es lo único que te permite leer tus documentos.
- Explicar la lógica de la autoedición a la que nos ha avocado la revolución tecnológica y la omnipresencia de PC. Todos escribimos y editamos nuestros propios textos. Son dos tareas distintas que los procesadores juntan constantemente. Una tarea distrae de la otra. El diseño, el typesetting, se debería hacer en otro momento (incluso antes), pero formatos como Word hacen que hacer plantillas sea un dolor. LaTeX es mucho más directo (que no sencillo) a la hora de hacer plantillas. Racionalización: escritura por un lado, composición por el otro.
- Portabilidad máxima del texto plano. El texto plano lo lee cualquier cosa, y eso hace que se pueda transformar fácilmente en cualquier otra cosa. Herramientas como Pandoc pueden funcionar, en otros formatos es mucho más raro. En un mundo donde todo el mundo te pide documentos Word, puedes pasar de texto plano a Word sin ningún problema. Al revés es bastante más difícil. Al ser texto plano es, paradójicamente, agnóstico de formato.
- Archivística digital!! Un markdown unicode en texto plano lo podría leer un IBM PC sin mucho problema (esto es un triple, hacer fact-check). Son archivos pequeños que viven en tu ordenador. Kepano, el CEO de Obsidian, escribió una vez (https://obsidian.md/blog/new-obsidian-icon/) que si queríamos que nuestros ficheros se pudieran leer en 2060 o en 2160, a lo mejor teníamos que empezar a pensar en ficheros que se podrían leer en 1960. Permite además versionarlo fácilmente con herramientas como git, aunque es algo técnico y avanzado.
- Todo ello se puede hacer fácilmente con herramientas que son gratuitas y fácilmente reemplazables. Nada de vendor-lock nunca más. ¿No te gusta Obsidian? Bájate Zettlr. O Logseq. Configura Emacs o Neovim a tu gusto y úsalos. Usa el bloc de notas de Windows, por qué no. Si dedicas horas de tu vida a escribir, merece la pena asegurarse de que tu flujo de trabajo es consistente, portable, reproducible y fiable.
- Hemos establecido por qué texto plano. Pero si coges el bloc de notas de Windows y te pones a escribir, te vas a dar cuenta rápido de dos problemas: ¿cómo jerarquizo la información? Antes hablábamos de cómo diferenciar la tarea de escribir de la de editar. Pero hay edición que se tiene que hacer inline, según escribes, que no se puede automatizar. No solo el uso de mayúsculas y la puntuación. Cursiva, versalitas, saltos de párrafo, listas. ¿Cómo indicamos todo eso? Podríamos inventarnos nuestra propia sintaxis, pero si aprendemos una sintaxis ya hecha, que está bien diseñada, es simple, es legible tal cual fácilmente y está muy reconocida por otras herramientas, va a ser mucho más fácil todo. Markdown. Historia y filosofía elemental. Los dialectos de Markdown y el Markdown de Pandoc como solución a todos los casos necesarios.
- La superioridad de la sintaxis de markdown frente a otras de texto plano, como HTML o LaTeX. Sencillez y legibilidad.
- Paradójicamente, una vez configurado y conociendo el flujo, es bastante más sencillo de usar que navegar por infinitos submenús en Word. Hacer un índice en Word es notoriamente un dolor y la gente aún no sabe cómo hacerlo, porque tienes que jerarquizar el texto mediante estilos, que es algo bastante contraintuitivo, y luego insertar los índices. Y formatearlos es un dolor.
- Escala cuando lo necesitas. ¿Necesitas hacer una tabla bastante compleja? Mete un bloque de LaTeX sin problema. ¿A mitad de escritura ves que para un proyecto concreto va a ser mejor usar Word? Hazlo sin problema, la conversión es trivial.
- Como el output se gestiona mediante plantillas con todo explícitamente declarado, en principio, si están bien pensadas, hacer cambios es bastante trivial. Experimenta poniéndole a todo el texto otra tipografía sin problema.
- Jamás habrá crasheos que destruyen la última hora de trabajo.
- Contras fundamentales. Requiere aprender cosas nuevas, es nadar contra la corriente de Word que todos hemos aprendido. La sintaxis de markdown puede ser antiintuitiva si no se conoce. Los casos más complicados, que requieran por ejemplo introducir LaTeX, rompen el agnosticismo que permite al documento convertirse fácilmente en cualquier otra cosa. Requiere tener un conocimiento más profundo de tu ordenador. Hay varias herramientas, y todo ello es trabajo y cuidado, aunque acabe mereciendo la pena. Hay que tener clara una organización de los archivos que no todo el mundo tiene. En Word, pegas una imagen en el documento y ya está. En Markdown invocas una imagen que vive en un directorio relativo al propio archivo, no está incrustado. Eso es más organización y más puntos de fallo. Hacer retoques manuales en secciones es más difícil (requiere por ejemplo compilar primero a TeX, tocar eso manualmente y luego compilar a PDF), aunque en principio si las plantillas y el flujo están bien pensados no debería ocurrir mucho.

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
