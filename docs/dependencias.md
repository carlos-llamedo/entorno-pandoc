---
author: Carlos Llamedo
date: 2026-05
---

# Dependencias

## ¿Qué es Pandoc?

Pandoc es un programa de código abierto de conversión de documentos diseñado originalmente por John MacFarlane, profesor de filosofía en la Universidad de Berkely.

## Herramientas propias y ajenas

Para realizar la conversión a PDF, nos servimos de una serie de plantillas \LaTeX.

## Archivo de bibliografía

Generar el archivo de bibliografía es, seguramente, la parte que más planificación requiere. Podemos distinguir tres formas de hacerlo, cada una de ellas con sus ventajas:

1. La exportación simple por proyecto: se acopia bibliografía en un gestor de citas como [Zotero](https://www.zotero.org/), se exporta cuando se va a compilar el PDF y se pasa, sea en el campo `bibliography` del YAML o en la línea de comandos. El archivo de bibliografía queda así en el sistema de archivos como una instantánea (que se puede versionar fácilmente), lo que hace que el proceso de generar el documento se pueda reproducir exactamente. En este sistema, sin embargo, cualquier adición o modificación implica tener que volver a exportar. Tampoco hay que dar por sentado que todo proyecto tenga un lugar donde volcar cómodamente un archivo de bibliografía; hay proyectos (y momentos de los mismos) donde esto no tiene sentido, y en general depende del sistema de organización de archivos, si es que se sigue alguno.
2. La exportación por proyecto que se mantiene actualizada mediante la [extensión Better BibTeX de Zotero](https://retorque.re/zotero-better-bibtex/) (a costa de añadirla como dependencia adicional). Esto soluciona el problema de la exportación simple, pero las exportaciones se pueden acumular si no se eliminan manualmente en los ajustes de Better BibTeX en Zotero. Además, no soluciona el problema de dónde debería vivir el archivo, y pierde una gran virtud del primer método: la reproducibilidad del proceso.
3. La exportación global actualizada mediante Better BibTeX. No se exporta una colección vinculada a un proyecto concreto, sino toda la biblioteca de Zotero. Solo hay una colección actualizándose constantemente; y puede vivir en el directorio de datos de Pandoc sin ningún problema, donde además será fácil de encontrar para las preconfiguraciones (por ejemplo, en `${USERDATA}/biblioteca.json`). Es un método fácil, muy apto para proyectos rápidos, donde un archivo de bibliografía propio puede no tener mucho sentido. Al igual que el segundo método, claro, la reproducibilidad del proceso queda alterada. El hecho de que funcione bien con proyectos rápidos tiene otra cara de la moneda: aquí, los proyectos son menos autónomos.

|  Método |  Pros |  Contras |
|---|---|---|
|  *Exportación simple por proyecto* |  Reproducibilidad y autonomía absoluta, simplicidad (no requiere BBT), versionado |  Cambios requieren reexportar, no todo proyecto tiene directorio |
|  *Exportación actualizada por proyecto* |  Cambios no requieren reexportar, autonomía, reproducibilidad moderada, versionado  |  Requiere BBT, posible acumulación de exportaciones, la reproducibilidad no es exacta,  no todo proyecto tiene directorio |
|  *Exportación actualizada global* |  Comodidad (solo se exporta una vez), centralización, no requiere directorio por proyecto |  Requiere BBT, proyectos carecen absolutamente de autonomía, no hay reproducibilidad |

Combinar el método 1 y el 3 ofrece lo mejor de ambos mundos, y es lo que este repositorio asume. Hay un archivo de exportación global que se mantiene actualizado, con el que se trabaja y se compila durante todas las fases del proyecto. Una vez el trabajo se da por finalizado, si el proyecto lo merece, se hace una exportación simple al directorio del proyecto para garantizar su reproducibilidad y autonomía. No se aprovecha el versionado del archivo de bibliografía, pero su historial no tiene un desarrollo intelectual que merezca ser rastreado.

En cuanto al formato del archivo, `citeproc` admite BibLaTeX (`.bib`), BibTeX (`.bibtex`), CSL JSON (`.json`), CSL YAML (`.yaml`) y RIS (`.ris`). BibLaTeX es el formato más legible, pero la opción más sólida a nivel técnico, [como expone Heyns](https://retorque.re/zotero-better-bibtex/exporting/pandoc/index.html#use-csl-not-bibtex-with-pandoc), es CSL JSON. Tanto Zotero como `citeproc` usan internamente el motor CSL; exportar a BibLaTeX introduce una conversión intermedia con pérdidas innecesarias. Zotero almacena los títulos en minúsculas (como exige CSL) y los convierte a mayúsculas al exportar a BibTeX, conversión que `citeproc` deshace después mediante heurísticas necesariamente imperfectas. El modelo de datos de Zotero y el de BibTeX tampoco coinciden exactamente, y en la traducción se pueden perder campos o introducir ambigüedades. Exportar directamente a CSL evita todo este recorrido.
