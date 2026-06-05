---
title: Entorno de datos de Pandoc
author: Carlos Llamedo
date: 2026-04
---

# Entorno de datos de Pandoc

Este repositorio contiene los datos y elementos necesarios para escribir en texto plano y producir a partir de estos archivos documentos en otros formatos, como PDF.

## Dependencias externas

El repositorio es bastante autocontenido, pero hay dependencias mínimas sin las que el flujo simplemente no funciona, y que hay que instalar. Qué son estos programas y cómo se relacionan con las demás herramientas que intervienen en el flujo de trabajo —incluyendo las recomendadas para gestión bibliográfica y escritura— se explica con más detalle en [la documentación de las dependencias](docs/dependencias.md).

- [`pandoc`](https://pandoc.org/installing.html) con [`citeproc`](https://github.com/jgm/citeproc) (vienen empaquetados juntos)
- [`pandoc-crossref`](https://github.com/lierdakil/pandoc-crossref/releases/latest)
- Una distribución [`TeX`](https://ctan.org/starter) que incluya [`LuaTeX`](https://www.luatex.org/download.html)

En el caso de `pandoc` y `pandoc-crossref`, es importante que ambos estén compilados para la misma versión. Los paquetes de algunos gestores van por detrás de las versiones oficiales; en caso de error o de duda, la [documentación de dependencias](docs/dependencias.md) ofrece más información.

## Organización del repositorio

### Plantillas

### Filtros

### Submódulos

Se incluyen como submódulos de Git dos proyectos que conviene tener a mano:

- [`pandoc-templates`](https://github.com/jgm/pandoc-templates), que contiene [las plantillas](templates/pandoc-templates/) que Pandoc usa por defecto en todos los formatos soportados.
- [`pandoc-templates` de Kieran Healy](https://github.com/kjhealy/pandoc-templates), que contiene [plantillas y recursos](templates/kjhealy/) útiles como referencia.

## Justificación teórica

En su polémico artículo *Word Processors: Stupid and Inefficient*[^1], Cottrell 

[^1]: Allin Cottrell, *Word Processors: Stupid and Inefficient*, 1999, <http://cda.psych.uiuc.edu/latex_class_material/wp.html>.

vale. antes de hacer el diagrama, que ya veré cómo lo hago, voy a escribir la parte argumentativa. para mí, el README del documento se debería estructurar así

1. Header y brevísima descripción de qué es este proyecto.
2. Justificación teórica. Qué sentido tiene este proyecto, a qué necesidades responde, qué ventajas presenta y qué limitaciones.
3. Cómo ponerlo en marcha con lo mínimo. Dependencias externas
4. Ahora mismo tengo una explicación de los submódulos. Seguramente esto se debería encuadrar en una explicación un poco más amplia de cómo está organizado el repositorio.
5. Derechos

El punto 2 es el más argumentativo de todos. Aquí va una serie de elementos, no ordenados, de cosas que querría decir para acordarme y organizarlo

* Notar el poco cuidado que, en general, se tiene por cómo se componen textos cuando hay gente que se dedica profesionalmente a ello. Omnipotencia de Microsoft Word.

* Hacer explícito lo implícito. Diferencia entre procesadores de texto (edición tipo WYSIWYG) y editores de texto. Hacer breve recorrido histórico por la historia de los procesadores de texto. Electric Pencil, WordStar, WordPerfect, Microsoft Word, Adobe InCopy, Pages, Google Docs, Scrivener, OpenOffice Writer y LibreOffice Writer.

* Poner anécdota de que en 2014 George R. R. Martin dijo en el programa de Conan O'Brien que escribía en WordStar en un MS-DOS.

* El texto plano como documento básico. No se requieren herramientas específicas para procesarlo más allá de que se entienda Unicode. Explicar Unicode, su origen histórico. Explicar un archivo DOCX o incluso uno abierto ODT como empaquetamientos de archivos XML, bastante difícilmente legibles sin el software específico. Eso abre la puerta a obsolescencia y a paywalls mediante software privativo que es lo único que te permite leer tus documentos.

* Explicar la lógica de la autoedición a la que nos ha avocado la revolución tecnológica y la omnipresencia de PC. Todos escribimos y editamos nuestros propios textos. Son dos tareas distintas que los procesadores juntan constantemente. Una tarea distrae de la otra. El diseño, el typesetting, se debería hacer en otro momento (incluso antes), pero formatos como Word hacen que hacer plantillas sea un dolor. LaTeX es mucho más directo (que no sencillo) a la hora de hacer plantillas. Racionalización: escritura por un lado, composición por el otro.

* Portabilidad máxima del texto plano. El texto plano lo lee cualquier cosa, y eso hace que se pueda transformar fácilmente en cualquier otra cosa. Herramientas como Pandoc pueden funcionar, en otros formatos es mucho más raro. En un mundo donde todo el mundo te pide documentos Word, puedes pasar de texto plano a Word sin ningún problema. Al revés es bastante más difícil. Al ser texto plano es, paradójicamente, agnóstico de formato.

* Archivística digital!! Un markdown unicode en texto plano lo podría leer un IBM PC sin mucho problema (esto es un triple, hacer fact-check). Son archivos pequeños que viven en tu ordenador. Kepano, el CEO de Obsidian, escribió una vez (https://obsidian.md/blog/new-obsidian-icon/) que si queríamos que nuestros ficheros se pudieran leer en 2060 o en 2160, a lo mejor teníamos que empezar a pensar en ficheros que se podrían leer en 1960. Permite además versionarlo fácilmente con herramientas como git, aunque es algo técnico y avanzado.

* Todo ello se puede hacer fácilmente con herramientas que son gratuitas y fácilmente reemplazables. Nada de vendor-lock nunca más. ¿No te gusta Obsidian? Bájate Zettlr. O Logseq. Configura Emacs o Neovim a tu gusto y úsalos. Usa el bloc de notas de Windows, por qué no. Si dedicas horas de tu vida a escribir, merece la pena asegurarse de que tu flujo de trabajo es consistente, portable, reproducible y fiable.

* Hemos establecido por qué texto plano. Pero si coges el bloc de notas de Windows y te pones a escribir, te vas a dar cuenta rápido de dos problemas: ¿cómo jerarquizo la información? Antes hablábamos de cómo diferenciar la tarea de escribir de la de editar. Pero hay edición que se tiene que hacer inline, según escribes, que no se puede automatizar. No solo el uso de mayúsculas y la puntuación. Cursiva, versalitas, saltos de párrafo, listas. ¿Cómo indicamos todo eso? Podríamos inventarnos nuestra propia sintaxis, pero si aprendemos una sintaxis ya hecha, que está bien diseñada, es simple, es legible tal cual fácilmente y está muy reconocida por otras herramientas, va a ser mucho más fácil todo. Markdown. Historia y filosofía elemental. Los dialectos de Markdown y el Markdown de Pandoc como solución a todos los casos necesarios.

* La superioridad de la sintaxis de markdown frente a otras de texto plano, como HTML o LaTeX. Sencillez y legibilidad.

* Paradójicamente, una vez configurado y conociendo el flujo, es bastante más sencillo de usar que navegar por infinitos submenús en Word. Hacer un índice en Word es notoriamente un dolor y la gente aún no sabe cómo hacerlo, porque tienes que jerarquizar el texto mediante estilos, que es algo bastante contraintuitivo, y luego insertar los índices. Y formatearlos es un dolor.

* Escala cuando lo necesitas. ¿Necesitas hacer una tabla bastante compleja? Mete un bloque de LaTeX sin problema. ¿A mitad de escritura ves que para un proyecto concreto va a ser mejor usar Word? Hazlo sin problema, la conversión es trivial.

* Como el output se gestiona mediante plantillas con todo explícitamente declarado, en principio, si están bien pensadas, hacer cambios es bastante trivial. Experimenta poniéndole a todo el texto otra tipografía sin problema.

* Jamás habrá crasheos que destruyen la última hora de trabajo.

* Contras fundamentales. Requiere aprender cosas nuevas, es nadar contra la corriente de Word que todos hemos aprendido. La sintaxis de markdown puede ser antiintuitiva si no se conoce. Los casos más complicados, que requieran por ejemplo introducir LaTeX, rompen el agnosticismo que permite al documento convertirse fácilmente en cualquier otra cosa. Requiere tener un conocimiento más profundo de tu ordenador. Hay varias herramientas, y todo ello es trabajo y cuidado, aunque acabe mereciendo la pena. Hay que tener clara una organización de los archivos que no todo el mundo tiene. En Word, pegas una imagen en el documento y ya está. En Markdown invocas una imagen que vive en un directorio relativo al propio archivo, no está incrustado. Eso es más organización y más puntos de fallo. Hacer retoques manuales en secciones es más difícil (requiere por ejemplo compilar primero a TeX, tocar eso manualmente y luego compilar a PDF), aunque en principio si las plantillas y el flujo están bien pensados no debería ocurrir mucho.

Hay algún punto que veas que flaquea? Qué te parece mi lógica? esta sección es muy larga, probablemente debería ir, por lo menos, después de las dependencias. ¿cómo lo ves? ¿es convincente?


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
