# README Layout Rules (GitHub Profile)

Este archivo define reglas de diseno y medidas para mantener el `README.md` consistente (como si fuera una landing page).

Limitacion clave: GitHub README no permite CSS/JS propio. La consistencia se logra con HTML simple + imagenes.

---

## 0) Baseline (regla base)

- **Ancho seguro de diseno:** ~`780px` (columna central en desktop).
- **Imagenes full-width (`width="100%"`):** subir assets a `1000–1200px` de ancho real para que se vean nitidos cuando GitHub los reduzca.
- **Peso de assets:** preferir liviano (carga rapida).

---

## 1) Header / Hero

### Banner superior

- **Ancho recomendado:** `1200px`.
- **Alto recomendado (estatico):** `220–320px`.
- **Si es GIF:** `150–260px` de alto (para no comer demasiado scroll).
- **Peso objetivo:** `<1MB`.
- **Aceptable:** `1–3MB`.
- **Evitar:** `>5MB`.

### Texto animado (readme-typing-svg)

- **width:** `900–1100`
- **height:** `80–110` (subir si se cortan descendentes como `g/y/p`)
- **size:** `32–42` (subtitulo) o `48–64` (headline)
- **Lineas:** max `2–3` (si no, domina el layout).

---

## 2) Dividers (lineas animadas/estaticas)

- **Tamano tipico:** `1000x10` a `1200x16`.
- Render:
  - Usar `<img width="100%" ...>` para que se adapte al ancho de GitHub.
- Uso:
  - Divisor + `1 <br/>` entre bloques grandes.
  - No abusar: si hay mas de 3 divisores seguidos, se siente "ruidoso".

---

## 3) Iconography / Stack

### Icon carousel (GIF)

- **Altura recomendada:** `70–120px`.
- **Regla:** todas las frames deben tener el mismo canvas (sin "jumping").
- **Peso objetivo:** `<500KB`.
- **Aceptable:** `0.5–2MB`.

### Icon stack (fuente de verdad)

- Mantener las filas de iconos en `STACK_ICONS.md`.
- El carrusel se regenera desde `STACK_ICONS.md` (ver `scripts/gen_icons_carousel.py` y workflow).

---

## 4) Content Blocks (Articles / Projects / Services)

### Longitud de texto por bloque

- **Descripcion:** `2–4` lineas max.
- Incluir:
  - 1 titulo fuerte
  - 1 descripcion corta
  - `Stack:` (si aplica)
  - `Link:` (si aplica)

### Layout en GitHub (sin CSS)

- Preferir bloques verticales (columna unica).
- Si se usa 2 columnas con `<table>`:
  - **Columna izquierda (avatar/imagen):** `180–260px`
  - **Imagen/avatar:** `160–220px`
  - Columna derecha: texto (resto).

---

## 5) GitHub Activity (stats/graphs)

- Mostrar en columna (stacked), no en grid.
- **width recomendado:** `70–80%` para que no se vea enorme.
- Alinear ambos graficos con el mismo `width` para consistencia.

---

## 6) Spacing (aire entre secciones)

Regla: mantener ritmo vertical constante.

- Entre secciones grandes: `24–40px` visual.
- Implementacion en Markdown/HTML:
  - Usar `1–2` `<br/>` como maximo.
  - Evitar `>2` `<br/>` seguidos (excepto en el Hero si se justifica).

---

## 7) Checklist antes de hacer push

- El banner y/o typing no se cortan (especialmente `g/y/p`).
- Ningun bloque genera scroll horizontal (no usar anchos fijos grandes).
- Imagenes con `width="100%"` tienen suficiente resolucion (`1000–1200px`).
- GIFs no pesan demasiado (ideal `<1MB`).
- Los anchors/Navigation siguen funcionando (links llevan a la seccion correcta).
- Si se actualizaron iconos en `STACK_ICONS.md`, el workflow regenerara `images/icons/icons-carousel.gif`.

---

## 8) Asset Canon (Naming Contract)

Para evitar drift de rutas/nombres, estos son los paths canonicos del repo:

- `images/hero/` -> banners de cabecera (GIF/PNG/SVG del hero).
- `images/icons/` -> assets de stack/iconos (incluye `icons-carousel.gif`).
- `images/placeholders/` -> visuales placeholder para cards/proyectos.
- `images/diagrams/` -> diagramas renderizados para README.
- `images/diagrams/source/` -> fuentes editables de diagramas (ej. `.mmd`).
- `images/dividers/` -> divisores visuales (si se usan assets locales).
- `images/archive/` -> assets legacy/deprecados.
- `images/drafts/` -> borradores temporales (no productivos, ignorados para QA estricto).

### Versionado de assets visuales

- Usar sufijo `@Nx` para variantes de densidad/tamano:
  - ejemplo: `github-banner-1600x450@3x.gif`, `@4x`, `@7x`.
- Mantener el mismo nombre base y cambiar solo el sufijo:
  - correcto: `github-banner-1600x450@3x.gif` -> `github-banner-1600x450@4x.gif`.
- Regla de operacion:
  - `README.md` debe apuntar solo a **una** variante canonica activa.
  - variantes no usadas deben moverse a `images/archive/` o eliminarse segun decision del PR.

### Politica de archivo (`images/archive/`)

- Todo asset reemplazado o legacy va a `images/archive/`.
- No referenciar assets de `images/archive/` desde `README.md`.
- Si un asset se migra a `archive`, actualizar referencias en el mismo PR.
