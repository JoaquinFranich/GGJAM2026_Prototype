# ⚡ RESUMEN RÁPIDO: Cómo hacer que la UI aparezca

## 🎯 LA RESPUESTA EN 3 PASOS

### ✅ Paso 1: Verifica que UI_manager esté en autoload

Abre `project.godot` y verifica que tenga esta línea:
```
UI_manager="*res://Scenes/UI/ui_manager.tscn"
```

Si no está, agrégalo en la sección `[autoload]`.

---

### ✅ Paso 2: En cada escena, asigna el script al nodo raíz

1. Abre tu escena (ej: `test_node_A.tscn`)
2. Selecciona el nodo raíz (el primero, ej: "TestNodeA")
3. En el Inspector, busca "Script"
4. Si está vacío, click en el ícono 📜 y selecciona "Cargar"
5. Busca y carga: `res://Scripts/scene_ui_config.gd`

---

### ✅ Paso 3: Configura 3 propiedades en el Inspector

Con el nodo raíz seleccionado, en el Inspector verás:

1. **`focus_item_position`**: 
   - Pon la posición donde quieres el FocusItem
   - Ejemplo: `(621, 491)`
   - Si no quieres FocusItem: `(0, 0)`

2. **`focus_item_scale`**: 
   - Tamaño del FocusItem
   - Ejemplo: `(0.192, 0.162)`
   - Normal: `(1, 1)`

3. **`visible_direction_buttons`**: 
   - Array de botones a mostrar
   - Ejemplo: `["left"]` o `["left", "right"]`
   - Opciones: `"left"`, `"right"`, `"up"`, `"down"`

---

## 🎉 ¡LISTO!

Al ejecutar la escena, la UI aparecerá automáticamente.

---

## ❌ LO QUE NO DEBES HACER

- ❌ NO instancies `UI_manager` dentro de tu escena
- ❌ NO agregues `FocusItem` dentro de tu escena  
- ❌ NO agregues botones de dirección dentro de tu escena

**Todo se maneja automáticamente.** Solo configura las propiedades del script.

---

## 📚 MÁS INFORMACIÓN

- `GUIA_UI_MANAGER.md` - Guía completa y detallada
- `DIAGRAMA_JERARQUIA.md` - Diagramas visuales de la estructura

---

## 🔍 VERIFICACIÓN RÁPIDA

Tu escena debería verse así:

```
test_node_A.tscn
└── TestNodeA (Node2D)
    ├── Script: scene_ui_config.gd ✅
    ├── focus_item_position: (621, 491) ✅
    ├── focus_item_scale: (0.192, 0.162) ✅
    ├── visible_direction_buttons: ["left"] ✅
    └── Background (Sprite2D)
        └── texture: tu_imagen.jpg
```

**NO debería tener:**
- ❌ Nodo "UI_manager"
- ❌ Nodo "FocusItem"  
- ❌ Nodo "DirectionButtons"
- ❌ Nodos de botones individuales
