# Principio organizador

La distinción clave es entre lo que un lector nuevo necesita para entender y usar el repositorio, y lo que un usuario ya familiarizado necesita para consultar detalles. El `README` cubre lo primero; `docs/` cubre lo segundo.

## README.md: presentación y orientación

El diagrama del flujo de trabajo iría aquí, como elemento central. Es lo más ilustrativo y lo primero que debe ver alguien que llega al repositorio. Además: descripción breve del propósito, lista de dependencias con una línea por cada una y enlace a su sitio oficial, los submódulos (que efectivamente no hemos declarado en ningún lado todavía), y la sección de «Derechos» que ya tenemos.

Lo argumentativo (por qué texto plano, ventajas operativas y archivísticas) también encaja aquí, como introducción antes o después del diagrama. No es documentación técnica; es el *raison d’être* del repositorio.

`docs/`: documentación técnica de consulta

Propongo esta estructura:

```
docs/
  referencias.md       ← lo que es ahora REFS.md
  dependencias.md      ← instalación y configuración de cada componente
  markdown.md          ← extensiones activas y qué hacen
  plantilla.md         ← variables de memoir.tex (lo que es ahora variables.md)
  filtros.md           ← documentación de los filtros Lua propios y ajenos
  scripts.md           ← md-pdf.sh, actualizar-locales.sh, actualizar-csl.sh
  pandoc-notas.md      ← tus anotaciones y síntesis del manual de Pandoc
```

Algunas decisiones que justifican esta estructura:

`referencias.md` y `dependencias.md` son archivos distintos aunque relacionados. `referencias.md` es un inventario de fuentes (dónde está la documentación oficial, cómo acceder sin conexión); `dependencias.md` explica qué es cada herramienta y cómo instalarla. Son preguntas distintas: «dónde leo más» frente a «cómo lo pongo en marcha». Fuentes a considerar:

- Pandoc
- Citeproc
- CSL
- CSL locales
- pandoc-crossref
- include-files.lua
- multibib.lua
- pandoc-latex-extensions (de donde tomé la idea para noindent.lua)
- Zotero
- Better BibTeX
- LaTeX y LuaLaTeX
- dunning.tex
- pandoc-templates
- kjhealy templates
- Zettlr

`filtros.md` y `scripts.md` son documentación del propio código. Podrían ir juntos en un `codigo.md`, pero separados son más fáciles de consultar cuando buscas algo concreto.

`pandoc-notas.md` es el archivo más abierto y orgánico: tus propias síntesis, listas de extensiones, anotaciones. Que tenga nombre propio lo distingue de la documentación oficial y deja claro que es elaboración tuya.

`plantilla.md` es el actual `variables.md` renombrado para que el nombre sea más descriptivo. Podría también llamarse `memoir.md` si quieres que quede claro que es específico de esa plantilla.
