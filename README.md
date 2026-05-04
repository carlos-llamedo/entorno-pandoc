---
title: Entorno de datos de Pandoc
author: Carlos Llamedo
date: 2026-04
---

# Entorno de datos de Pandoc

Este repositorio contiene los datos y elementos necesarios para escribir en Markdown y producir a partir de ellos documentos en otros formatos, como PDF.

## ¿Qué es Pandoc?

Pandoc es un programa de código abierto de conversión de documentos diseñado originalmente por John MacFarlane, profesor de filosofía en la Universidad de Berkely.

## El Markdown de Pandoc



## Extensiones nativas y activadas

Se puede ajustar cómo el lector de Pandoc de ciertos formatos se comporta usando extensiones. El argumento `--list-extensions[=FORMATO]` lista cuáles están disponibles para cada formato. Esta configuración mantiene las activas por defecto, que se listan con `+` como prefijo:

- `all_symbols_escapable`. Permite que todos los caracteres se escapen precediéndolos de `\`, tratándose de manera literal. La norma original de Markdown solo permite escapar los caracteres `\*_{}[]()>#+-.!`.
- `auto_identifiers`. En cada sección del documento se puede declarar un identificador del mismo añadiendo `{#identificador}` tras su título, y se utilizará para generar enlaces a las secciones en el índice y para hacer una remisión en el propio texto. Esta extensión asigna un identificador automáticamente a aquellos títulos sin uno explícitamente declarado. Se elimina todo formato, pies de página y caracteres no alfanuméricos (excepto puntos, guiones y guiones bajos); los espacios se convierten en guiones y todo se pone en minúscula. Un título como «*Quo vadis?* Viajes y distancias en el Imperio» se convierte en `#quo-vadis-viajes-y-distancias-en-el-imperio`. En un documento largo y formal, aún así, es recomendable declarar los identificadores explícitamente, puesto que si los títulos cambian, los enlaces que se apoyen en identificadores implícitos generados automáticamente se romperán.
- `backtick_code_blocks`.
- `blank_before_blockquote`.
- `blank_before_header`.
- `bracketed_spans`.
- `citations`.
- `definition_lists`.
- escaped_line_breaks
- example_lists
- fancy_lists
- fenced_code_attributes
- fenced_code_blocks
- fenced_divs
- footnotes
- grid_tables
- header_attributes
- implicit_figures
- implicit_header_references
- inline_code_attributes
- inline_notes
- intraword_underscores
- latex_macros
- line_blocks
- link_attributes
- markdown_in_html_blocks
- multiline_tables
- native_divs
- native_spans
- pandoc_title_block
- pipe_tables
- raw_attribute
- raw_html
- raw_tex
- shortcut_reference_links
- simple_tables
- smart
- space_in_atx_header
- startnum
- strikeout
- subscript
- superscript
- task_lists
- table_captions
- tex_math_dollars
- yaml_metadata_block

## Herramientas propias y ajenas

Para realizar la conversión a PDF, nos servimos de una serie de plantillas \LaTeX 

## Derechos

Este repositorio está bajo una [Licencia Pública General de GNU](LICENCE.md).
