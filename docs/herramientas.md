---
author: Carlos Llamedo
date: 2026-07
---

# Herramientass

Cada apartado de este documento presenta al menos una herramienta gratuita y de código abierto capaz de cubrir esa función del flujo de trabajo; la única categoría donde esto no está garantizado es la de los editores de Markdown, en la que se incluyen también programas de pago por lo extendido de su uso.

Lo que sigue no es un manual de instalación ni de uso —para eso está el resto de la documentación—, sino una presentación de cada herramienta: quién la hizo, con qué propósito y qué papel ocupa hoy en el ecosistema de la escritura en texto plano.

## La escritura del documento

### Codificación de caracteres. ASCII y Unicode

Todo archivo de texto plano es, en última instancia, una secuencia de bytes que hay que interpretar según una convención de codificación de caracteres. ASCII, estandarizado en 1963 por la ASA, predecesora de ANSI, resolvió el problema asignando un número a cada letra, dígito y signo del inglés, en un espacio de solo 128 valores. Fue suficiente mientras la informática se limitó a ese idioma, pero incapaz de representar siquiera los diacríticos del español o el resto de alfabetos del mundo sin recurrir a páginas de códigos incompatibles entre sí, cada una reservando esos mismos 128 valores adicionales para un repertorio distinto según el país o el fabricante.

Unicode nació en 1991, impulsado, entre otros, por Joe Becker, Lee Collins y Mark Davis, y por técnicos de empresas como Xerox y Apple, con el objetivo de asignar un número único y estable a cada carácter de cualquier sistema de escritura del mundo, de forma que un mismo texto significara lo mismo en cualquier sistema, sin ambigüedad de página de códigos. UTF-8, diseñado en 1992 por Ken Thompson y Rob Pike, los mismos autores, años antes, del sistema operativo Unix en los Laboratorios Bell, es una de las formas de codificar ese repertorio en bytes. Su virtud decisiva es la retrocompatibilidad. Los primeros 128 puntos de código de Unicode coinciden exactamente con ASCII, y UTF-8 los representa con el mismo byte que ASCII ya usaba, de modo que cualquier archivo ASCII es también un archivo UTF-8 válido. La codificación resultante es, además, de longitud variable, lo que la hace notablemente más compacta que UTF-16 (la otra codificación de uso extendido, empleada internamente por Windows y por Java) para textos que, como el español, están escritos mayoritariamente en caracteres del rango ASCII. Cada letra sin diacrítico ocupa un solo byte, y solo los caracteres fuera de ese rango (nuestras tildes, la eñe, las comillas angulares) requieren dos o más. Por este motivo se usa UTF-8 para todo en este flujo de trabajo. Es la codificación universal de facto en sistemas Unix y en la web, perfectamente legible dentro de sesenta años como lo es hoy un archivo ASCII de 1983, y sin el coste de espacio de UTF-16 para un idioma que apenas se aparta del repertorio ASCII original.

### Lenguajes de marcado. HTML y Markdown
 
HTML, publicado por Tim Berners-Lee en 1991 durante su trabajo en el CERN, es la sintaxis de marcado sobre la que se construyó la web; su propósito original era permitir enlazar e intercambiar documentos científicos entre investigadores, no la representación visual que hoy asociamos con una página.
 
Markdown, obra de John Gruber en 2004 —con contribuciones de sintaxis de Aaron Swartz—, es un lenguaje de marcado ligero pensado explícitamente como alternativa legible a HTML. Recoge convenciones ya circulantes en el correo electrónico y los foros de la época (asteriscos para el énfasis, guiones para las listas, almohadillas para los encabezados) y las formaliza en una sintaxis que se entiende sin renderizar. El objetivo declarado de Gruber era que el texto fuente pudiera publicarse tal cual, sin conversión, y siguiera siendo legible. El dialecto que usa Pandoc amplía considerablemente, como indicamos en [`markdown`](markdown.md), el original de Gruber, pensado sobre todo para producir HTML.

### Editores de Markdown

Al ser el archivo Markdown texto plano, cualquier editor de texto sirve en principio para escribirlo. Pero existe una categoría de programas diseñados específicamente en torno a este lenguaje de marcado, que añaden vista previa en línea, gestión de notas enlazadas y otras comodidades sin dejar nunca de escribir en texto plano.

Zettlr, escrito por Hendrik Erz y publicado en 2017 como proyecto personal durante sus estudios, es de código abierto y gratuito, y es el editor recomendado en este repositorio. Está pensado explícitamente para la escritura académica al integrar citas de Zotero, gestión de bibliografía y exportación mediante Pandoc de forma nativa.

Obsidian, de 2020, obra de Erica Xu y Shida Li, es una alternativa muy conocida. Es gratuito para uso personal pero de código cerrado; su modelo de negocio se apoya en licencias comerciales y servicios de sincronización de pago. Es un programa muy bonito, completo y con un ecosistema de extensiones de la comunidad que le permite hacer prácticamente de todo. Entre estas extensiones, varias replican buena parte de las funciones de citación e integración con Pandoc que Zettlr ofrece de fábrica.

Typora, de Abner Lee, pasó en 2020 de ser gratuito a un modelo de pago único tras un periodo de beta abierta (no es de código abierto). Es un programa rápido, sobrio y elegante, con un modo de vista previa continua.

Por último, cualquier editor de código general con las extensiones adecuadas (VSCode, de Microsoft, o su empaquetado libre VSCodium) puede funcionar razonablemente bien para ediciones puntuales o rápidas. Hay quien lo recomienda incluso como entorno de escritura general.

## La conversión del documento

### Pandoc y su ecosistema

Pandoc es un programa de código abierto de conversión de documentos, diseñado originalmente por [John MacFarlane](https://github.com/jgm), profesor de filosofía en la Universidad de Berkeley. Escrito en Haskell y publicado en 2006, nació de la necesidad de MacFarlane de convertir sus propios apuntes de clase, redactados en Markdown, a distintos formatos de salida sin tener que reescribirlos cada vez. De ahí procede su carácter definitorio, resumido en su propio lema de «convertidor universal de documentos»: no está atado a un único formato de entrada ni de salida, sino que analiza el documento fuente en un árbol sintáctico abstracto (AST) intermedio, y a partir de él genera el formato que se le pida, ya sea PDF, `.docx`, HTML o una veintena larga de alternativas más.

Alrededor de Pandoc se ha ido formando un pequeño ecosistema de herramientas que resuelven problemas que el programa, por diseño, deja fuera de su núcleo. Estas herramientas, llamadas «filtros» están documentadas con detalle en [`filtros`](filtros.md).

`citeproc` es una reescritura que hizo MacFarlane de `citeproc-hs`, de Andrea Rossato. «Citeproc» es el nombre genérico que reciben los programas de procesamiento automático de citas. El de Pandoc se sirve del [estándar CSL](#csl); desde la versión 2.11 de Pandoc, de 2020, se distribuye integrada en el mismo binario, de modo que ya no hace falta instalarla por separado. Es la pieza que traduce las citas en sintaxis `[@clave]` a notas o referencias en el estilo que se indique, y construye la bibliografía final a partir del archivo de datos correspondiente.

`pandoc-crossref` es un filtro externo escrito en Haskell por [Nikolay Yakimov](https://github.com/lierdakil). Resuelve la numeración automática y la remisión cruzada de figuras, tablas y ecuaciones, un problema que Pandoc no aborda. Al ser un proyecto aparte, su versión debe mantenerse sincronizada con la de Pandoc, lo que es la causa más habitual de que un documento deje de compilar tras una actualización de cualquiera de los dos.

Los filtros Lua, en cambio, sí forman parte del núcleo de Pandoc desde 2017. Explotan que el propio programa lleva un intérprete de Lua, un lenguaje de programación nacido en 1993 en la Pontificia Universidad Católica de Río de Janeiro y elegido, entre otras razones, por su ligereza y su facilidad de incrustación en programas escritos en otros lenguajes. Cada filtro recorre el AST que Pandoc construye a partir del documento y transforma los elementos que le interesan antes de que se genere el resultado final.

### TeX, LaTeX y LuaTeX

TeX es obra de Donald Knuth, que lo desarrolló entre 1978 y 1982 movido por la frustración de ver cómo se maquetaba el segundo volumen de *The Art of Computer Programming*.

Knuth es una leyenda de la informática. Sus contribuciones a la teoría de algoritmos y estructuras de datos son fundamentales para la disciplina, y TeX mismo nació como un paréntesis de varios años en ese proyecto mayor, con la idea original de que le llevaría un verano. La ambición de Knuth no era solo tener control tipográfico sobre su propio libro, sino resolver el problema de la composición de calidad tipográfica por medios enteramente algorítmicos —incluido el algoritmo de justificación de línea Knuth-Plass, todavía hoy uno de los más sofisticados que existen—. El resultado, sumado a su carácter de software libre y a que Knuth ofreció recompensas económicas por cada error encontrado en el programa, hizo de TeX un sistema extraordinariamente estable. Los mismos documentos escritos en los años ochenta compilan hoy sin apenas cambios.

TeX, sin embargo, es un lenguaje de programación de bajo nivel, tedioso de usar directamente. LaTeX, creado por Leslie Lamport en 1984, entonces investigador en el Computer Science Laboratory del centro SRI International, es un conjunto de macros construido sobre TeX que añade una capa de comandos de alto nivel (`\section`, `\emph`, `\cite`) y con ella la posibilidad de pensar el documento en términos de estructura lógica y no de instrucciones tipográficas sueltas. Es, junto con HTML, el mayor éxito de adopción de un lenguaje de marcado. La práctica totalidad de las disciplinas científico-técnicas (matemáticas, física, informática, ingeniería) escriben e intercambian sus artículos directamente en LaTeX, y buena parte de las revistas de esos campos ofrecen plantillas propias en este formato.
 
LuaTeX es uno de los varios motores de composición que hoy pueden ejecutar código LaTeX, sucesor de pdfTeX. Se originó hacia 2005 por iniciativa de Taco Hoekwater y Hans Hagen, este último además autor del sistema ConTeXt, con el propósito declarado de exponer los mecanismos internos de TeX a un lenguaje de programación moderno (de nuevo Lua) en lugar de obligar a cualquier extensión a reescribirse en el propio lenguaje TeX. Alcanzó su primera versión estable en 2010, y hoy es el motor recomendado para compilar LaTeX. LuaTeX, a diferencia de pdfTeX, tiene soporte nativo de Unicode y de fuentes OpenType a través de `fontspec`, lo que permite trabajar directamente con las fuentes del sistema y con sus funciones tipográficas avanzadas sin pasar por la conversión a fuentes de formato TeX que exigían los motores anteriores.

### PDF
 
El Portable Document Format nació en 1993, ideado por John Warnock, cofundador de Adobe, con el propósito de que un documento se viera exactamente igual con independencia del sistema, la impresora o el programa que lo abriera. Resolvía así el problema, entonces habitual, de que un archivo compuesto en un ordenador se recompusiera de otra forma en otro.

A diferencia de un `.docx` o de un archivo Markdown, un PDF no es un formato editable ni pensado para serlo. Es, esencialmente, un conjunto de instrucciones de dibujo fijas (dónde va cada glifo, cada línea, cada imagen, en cada página) más los metadatos y las fuentes necesarias para reproducirlas. Su rigidez es la que lo hace idóneo como formato final del flujo de trabajo, listo para imprimirse o archivarse.

## La gestión de bibliografía

### Zotero y Better BibTeX

Zotero es un gestor de referencias bibliográficas de código abierto, desarrollado desde 2006 por el Center for History and New Media de la Universidad George Mason. Nació como una extensión del navegador Firefox pensada para historiadores, con el propósito de capturar y organizar fuentes directamente desde la web sin depender de software comercial como EndNote o RefWorks, entonces dominantes en el mercado universitario. Hoy funciona como aplicación independiente y sigue ofreciéndose de forma gratuita, con almacenamiento en la nube limitado y planes de pago solo para quien necesite más espacio de sincronización. Su papel en este flujo de trabajo es el de base de datos bibliográfica. Es donde se acumulan y organizan las referencias, y desde donde se exportan al formato que Pandoc necesita para construir citas y bibliografía.

Better BibTeX es una extensión de Zotero, obra de Emiliano Heyns, gratuita y de código abierto igual que el programa que extiende. Zotero no ofrece de fábrica una forma de mantener sincronizada y actualizada una exportación de la biblioteca, o de una parte de ella, en un archivo externo sin tener que repetir manualmente la exportación cada vez que se añade o modifica un registro; eso es lo que resuelve Better BibTeX. Es, además, la extensión de referencia para integrar Zotero en flujos de trabajo de texto plano, con soporte específico para distintos formatos de exportación, entre ellos CSL JSON.

Generar el archivo de bibliografía para escribir es, seguramente, la parte que más planificación requiere. Podemos distinguir tres formas de hacerlo, cada una de ellas con sus ventajas:

1. La exportación simple por proyecto: se acopia bibliografía en un gestor de citas como [Zotero](https://www.zotero.org/), se exporta cuando se va a compilar el PDF y se pasa, sea en el [campo `bibliography` del YAML](filtros.md) o en la línea de comandos. El archivo de bibliografía queda así en el sistema de archivos como una instantánea (que se puede versionar fácilmente), lo que hace que el proceso de generar el documento se pueda reproducir exactamente. En este sistema, sin embargo, cualquier adición o modificación implica tener que volver a exportar. Tampoco hay que dar por sentado que todo proyecto tenga un lugar donde volcar cómodamente un archivo de bibliografía; hay proyectos (y momentos de los mismos) donde esto no tiene sentido, y en general depende del sistema de organización de archivos, si es que se sigue alguno.
2. La exportación por proyecto que se mantiene actualizada mediante la [extensión Better BibTeX de Zotero](https://retorque.re/zotero-better-bibtex/) (a costa de añadirla como dependencia adicional). Esto soluciona el problema de la exportación simple, pero las exportaciones se pueden acumular si no se eliminan manualmente en los ajustes de Better BibTeX en Zotero. Además, no soluciona el problema de dónde debería vivir el archivo, y pierde una gran virtud del primer método: la reproducibilidad del proceso.
3. La exportación global actualizada mediante Better BibTeX. No se exporta una colección vinculada a un proyecto concreto, sino toda la biblioteca de Zotero. Solo hay una colección actualizándose constantemente; y puede vivir en el directorio de datos de Pandoc sin ningún problema, donde además será fácil de encontrar para las preconfiguraciones (por ejemplo, en `${USERDATA}/biblioteca.json`). Es un método fácil, muy apto para proyectos rápidos, donde un archivo de bibliografía propio puede no tener mucho sentido. Al igual que el segundo método, claro, la reproducibilidad del proceso queda alterada. El hecho de que funcione bien con proyectos rápidos tiene otra cara de la moneda: aquí, los proyectos son menos autónomos.

|  Método |  Pros |  Contras |
|---|---|---|
|  *Exportación simple por proyecto* |  Reproducibilidad y autonomía absoluta, simplicidad (no requiere BBT), versionado |  Cambios requieren reexportar, no todo proyecto tiene directorio |
|  *Exportación actualizada por proyecto* |  Cambios no requieren reexportar, autonomía, reproducibilidad moderada, versionado  |  Requiere BBT, posible acumulación de exportaciones, la reproducibilidad no es exacta,  no todo proyecto tiene directorio |
|  *Exportación actualizada global* |  Comodidad (solo se exporta una vez), centralización, no requiere directorio por proyecto |  Requiere BBT, proyectos carecen absolutamente de autonomía, no hay reproducibilidad |

Combinar el método 1 y el 3 ofrece lo mejor de ambos mundos, y es lo que este repositorio asume. Hay un archivo de exportación global que se mantiene actualizado, con el que se trabaja y se compila durante todas las fases del proyecto. Una vez el trabajo se da por finalizado, si el proyecto lo merece, se hace una exportación simple al directorio del proyecto para garantizar su reproducibilidad y autonomía. No se aprovecha el versionado del archivo de bibliografía, pero su historial no tiene un desarrollo intelectual que merezca ser rastreado.

En cuanto al formato del archivo, `citeproc` admite BibLaTeX (`.bib`), BibTeX (`.bibtex`), CSL JSON (`.json`), CSL YAML (`.yaml`) y RIS (`.ris`). BibLaTeX es el formato más legible, pero la opción más sólida a nivel técnico, [como expone Heyns](https://retorque.re/zotero-better-bibtex/exporting/pandoc/index.html#use-csl-not-bibtex-with-pandoc), es CSL JSON. Tanto Zotero como `citeproc` usan internamente el motor CSL; exportar a BibLaTeX introduce una conversión intermedia con pérdidas innecesarias. Zotero almacena los títulos en minúsculas (como exige CSL) y los convierte a mayúsculas al exportar a BibTeX, conversión que `citeproc` deshace después mediante heurísticas necesariamente imperfectas. El modelo de datos de Zotero y el de BibTeX tampoco coinciden exactamente, y en la traducción se pueden perder campos o introducir ambigüedades. Exportar directamente a CSL evita todo este recorrido.

### CSL

El *Citation Style Language* es una especificación abierta, mantenida desde 2006 por un proyecto encabezado por Bruce D’Arcus y Simon Kornblith, este último además cofundador de Zotero, que define en XML cómo debe formatearse una referencia bibliográfica. Qué elementos incluir, en qué orden, con qué puntuación, y cómo debe construirse a partir de ellos tanto la cita en el cuerpo del texto como la entrada correspondiente en la bibliografía final.

Su ventaja decisiva frente a soluciones anteriores, como los estilos de BibTeX, escritos en un lenguaje de macros propio y difícil de modificar, es que separa por completo los datos bibliográficos de las reglas de formato. Un mismo registro puede convertirse en una nota de Chicago, una referencia de la APA o una cita de la MLA sin tocar el dato, cambiando solamente el archivo de estilo.

`citeproc`, el motor que usa Pandoc, es un intérprete de esa especificación, exactamente igual que Zotero. Los archivos de localización, mantenidos por el mismo proyecto, resuelven la parte que un estilo por sí solo no puede: qué cadenas fijas (ed., vol., y otros) y qué convenciones tipográficas, como el orden de los signos de puntuación o el uso del artículo, corresponden a cada idioma.
