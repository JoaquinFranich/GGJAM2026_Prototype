# Guía de Implementación: Botón de Máscara (Vía Inspector)

¡Buenas noticias! El sistema ya está configurado para que puedas activar la máscara directamente desde el **Inspector** de Godot, sin necesidad de escribir código.

Como tus escenas utilizan el script `scene_ui_config.gd` (Escena UI Config), ya tienes la opción integrada.

## Pasos para activar la máscara en una escena

1.  **Abre tu escena** (por ejemplo, `test_node_B.tscn`).
2.  Selecciona el **nodo raíz** de la escena (el primero de arriba).
3.  En el panel **Inspector** (a la derecha), busca la sección **Mask Configuration** (Configuración de Máscara).

## Opciones Disponibles

*   **Mask Clue Texture**:
    *   Arrastra aquí tu imagen (pista). Si está vacío, la máscara se desactiva.
*   **Mask Clue Position**:
    *   Ajusta `x` e `y` para mover la imagen dentro del overlay.
    *   Útil para centrarla exactamente donde quieres.
*   **Mask Clue Scale**:
    *   Ajusta `x` e `y` para cambiar el tamaño de la imagen.
    *   Ejemplo: `(0.5, 0.5)` reduce la imagen a la mitad.

## ¿Cómo funciona?

El script `scene_ui_config.gd` detecta automáticamente si has puesto una imagen:
*   Si hay imagen -> Le dice al `UI_manager` que active el botón y use esa imagen, aplicando la posición y escala que definiste.
*   Si NO hay imagen -> Le dice al `UI_manager` que oculte el botón.

Todo esto ocurre automáticamente al iniciar la escena.

## Resumen

No necesitas crear scripts nuevos. Solo arrastra la imagen al Inspector en cada escena donde quieras que el jugador pueda usar la máscara.
