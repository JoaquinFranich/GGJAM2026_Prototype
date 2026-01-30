# 🎯 GUÍA: Múltiples FocusItems en una Escena

## 🎯 PROBLEMA RESUELTO

Ahora puedes tener **múltiples FocusItems** en la misma escena, cada uno llevando a una escena diferente.

**Ejemplo:** En la escena A3 puedes tener:
- FocusItem 1 → lleva a A4
- FocusItem 2 → lleva a A5

---

## 📝 CÓMO CONFIGURAR MÚLTIPLES FOCUSITEMS

### Opción 1: Desde código (RECOMENDADO)

En el `_ready()` de tu escena, llama a `configure_focus_items_manual()`:

```gdscript
func _ready():
    # Configurar múltiples FocusItems
    configure_focus_items_manual([
        {
            "position": Vector2(300, 400),  # Posición del primer FocusItem
            "scale": Vector2(1, 1),         # Tamaño (opcional)
            "target_scene": "res://Scenes/Sub Scenes/test_node_A4.tscn"  # Escena destino
        },
        {
            "position": Vector2(800, 500),  # Posición del segundo FocusItem
            "target_scene": "res://Scenes/Sub Scenes/test_node_A5.tscn"  # Escena destino
        }
    ])
```

### Opción 2: Sobrescribir `configure_ui()`

En tu escena, sobrescribe el método `configure_ui()`:

```gdscript
func configure_ui():
    # Configurar múltiples FocusItems
    var focus_items_config = [
        {
            "position": Vector2(300, 400),
            "scale": Vector2(1, 1),
            "target_scene": "res://Scenes/Sub Scenes/test_node_A4.tscn"
        },
        {
            "position": Vector2(800, 500),
            "target_scene": "res://Scenes/Sub Scenes/test_node_A5.tscn"
        }
    ]
    
    UI_manager.configure_scene_ui_multiple(focus_items_config, visible_direction_buttons)
    
    # Configurar ButtonUp si es necesario
    if button_up_target_scene != "":
        var button_up = UI_manager.get_direction_button("up")
        if button_up:
            button_up.target_scene = button_up_target_scene
```

---

## 🎮 EJEMPLO COMPLETO: Escena A3

Vamos a configurar `test_node_A3.tscn` con dos FocusItems:

### Paso 1: Abre la escena

1. Abre `Scenes/Sub Scenes/test_node_A3.tscn`
2. Selecciona el nodo raíz
3. Verifica que tenga el script `scene_ui_config.gd`

### Paso 2: Agrega código personalizado

1. En el Inspector, click en el ícono **📜** (script)
2. Selecciona **"Extender Script"** o **"Editar Script"**
3. Agrega este código:

```gdscript
extends Node2D

func _ready():
    # Esperar un frame para asegurar que UI_manager esté listo
    await get_tree().process_frame
    
    # Configurar múltiples FocusItems
    configure_focus_items_manual([
        {
            "position": Vector2(300, 400),  # Posición del FocusItem que lleva a A4
            "scale": Vector2(1, 1),
            "target_scene": "res://Scenes/Sub Scenes/test_node_A4.tscn"
        },
        {
            "position": Vector2(800, 500),  # Posición del FocusItem que lleva a A5
            "scale": Vector2(1, 1),
            "target_scene": "res://Scenes/Sub Scenes/test_node_A5.tscn"
        }
    ])
    
    # Configurar botones visibles
    UI_manager.hide_all_direction_buttons()
    UI_manager.show_direction_button("left", true)
```

### Paso 3: Ajusta las posiciones

- Cambia `Vector2(300, 400)` y `Vector2(800, 500)` por las posiciones reales donde quieres los FocusItems
- Puedes probar ejecutando y ajustando hasta que estén donde quieres

---

## 📋 ESTRUCTURA DE CONFIGURACIÓN

Cada FocusItem se configura con un diccionario que puede tener:

| Propiedad | Tipo | Requerido | Descripción |
|-----------|------|-----------|--------------|
| `position` | Vector2 | ✅ SÍ | Posición donde aparecerá el FocusItem |
| `scale` | Vector2 | ❌ NO | Tamaño (default: Vector2.ONE) |
| `target_scene` | String | ❌ NO | Escena destino ("" = navegación automática) |

### Ejemplo mínimo:
```gdscript
{
    "position": Vector2(100, 200)
}
```

### Ejemplo completo:
```gdscript
{
    "position": Vector2(100, 200),
    "scale": Vector2(0.5, 0.5),
    "target_scene": "res://Scenes/Sub Scenes/test_node_A4.tscn"
}
```

---

## 🔄 NAVEGACIÓN AUTOMÁTICA vs MANUAL

### Navegación Automática (target_scene = "")
Si no especificas `target_scene` o lo dejas vacío `""`, el FocusItem usará la navegación automática de `SceneManager`:

```gdscript
{
    "position": Vector2(500, 300),
    "target_scene": ""  # Usa SceneManager.on_focusitem_clicked()
}
```

### Navegación Manual (target_scene = "ruta")
Si especificas una `target_scene`, el FocusItem llevará directamente a esa escena:

```gdscript
{
    "position": Vector2(500, 300),
    "target_scene": "res://Scenes/Sub Scenes/test_node_A4.tscn"  # Va directo a A4
}
```

---

## ✅ VENTAJAS

1. **Flexibilidad**: Puedes tener tantos FocusItems como necesites
2. **Control**: Cada FocusItem puede ir a una escena diferente
3. **Compatible**: Sigue funcionando con un solo FocusItem (método legacy)

---

## 🎓 EJEMPLOS DE USO

### Ejemplo 1: Dos caminos desde una escena
```gdscript
configure_focus_items_manual([
    {"position": Vector2(200, 300), "target_scene": "res://path/to/scene1.tscn"},
    {"position": Vector2(700, 300), "target_scene": "res://path/to/scene2.tscn"}
])
```

### Ejemplo 2: Tres FocusItems con diferentes tamaños
```gdscript
configure_focus_items_manual([
    {"position": Vector2(100, 200), "scale": Vector2(0.5, 0.5), "target_scene": "res://scene1.tscn"},
    {"position": Vector2(500, 200), "scale": Vector2(1, 1), "target_scene": "res://scene2.tscn"},
    {"position": Vector2(900, 200), "scale": Vector2(1.5, 1.5), "target_scene": "res://scene3.tscn"}
])
```

### Ejemplo 3: Mezcla de navegación automática y manual
```gdscript
configure_focus_items_manual([
    {"position": Vector2(300, 400), "target_scene": ""},  # Navegación automática
    {"position": Vector2(800, 400), "target_scene": "res://scene2.tscn"}  # Navegación manual
])
```

---

## ❓ PREGUNTAS FRECUENTES

### ¿Puedo tener un solo FocusItem?
**Sí**, sigue funcionando con el método antiguo usando `focus_item_position` en el Inspector.

### ¿Puedo mezclar FocusItems con navegación automática y manual?
**Sí**, cada FocusItem puede tener su propia configuración.

### ¿Cómo sé qué posición poner?
- Ejecuta la escena
- Prueba diferentes valores
- Ajusta hasta que el FocusItem esté donde quieres

### ¿Puedo tener FocusItems sin escena destino?
**Sí**, deja `target_scene` vacío `""` y usará navegación automática.

---

## 🎯 RESUMEN

1. **Múltiples FocusItems**: Usa `configure_focus_items_manual()` en `_ready()`
2. **Cada FocusItem**: Tiene posición, escala (opcional) y escena destino (opcional)
3. **Navegación**: Automática (vacío) o manual (especifica ruta)
4. **Compatible**: Sigue funcionando con un solo FocusItem

**¡Ahora puedes tener tantos FocusItems como necesites en cada escena!**
