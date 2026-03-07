# Parametric Map Storage Tube (OpenSCAD)

Modelo paramétrico de tubo segmentado para almacenar mapas/lonas, preparado para impresión FDM.

## Características

- Segmentación automática en piezas según altura máxima de impresión.
- Uniones roscadas macho/hembra entre piezas.
- Modo de vista ensamblada y modo distribución en cama.
- Etiqueta lateral insertable para identificar contenido.
- Compatibilidad con `threads-scad` para MakerWorld.

## Archivos principales

- `tubo_parametrico_mapas.scad`: modelo principal.
- `threads-scad/threads.scad`: librería de roscas usada por el modelo.
- `tubo_parametrico_mapas.json`: preset de parámetros para Customizer.

## Uso rápido

1. Abrir `tubo_parametrico_mapas.scad` en OpenSCAD.
2. Ajustar parámetros en Customizer.
3. Exportar STL de las piezas en `layout_mode = "print_bed"`.

## Nota MakerWorld

El archivo principal incluye:

```scad
include <threads-scad/threads.scad>;
```

y redefine `Demo()` para evitar que aparezcan piezas de demostración de la librería en el render.
