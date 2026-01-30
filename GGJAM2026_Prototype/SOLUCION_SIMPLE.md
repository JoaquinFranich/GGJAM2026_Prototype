# ✅ SOLUCIÓN SIMPLE: Cada escena configura su propia UI

## 🎯 CONCEPTO CLAVE

**Cada escena tiene su propia configuración única** configurada en el Inspector.

El script `scene_ui_config.gd` NO tiene valores por defecto que afecten a todas las escenas. Cada escena DEBE configurar sus propios valores.

---

## 📝 CÓMO FUNCIONA (MUY SIMPLE)

### 1. UI_manager existe automáticamente
- Es un singleton (autoload)
- Ya tiene todos los botones y elementos UI
- **NO lo instancies en tus escenas**

### 2. Cada escena configura SU propia UI
- Asigna `scene_ui_config.gd` al nodo raíz
- Configura las propiedades en el Inspector
- Cada escena tiene valores DIFERENTES

### 3. El script aplica la configuración automáticamente
- Cuando la escena se carga, `_ready()` se ejecuta
- Llama a `UI_manager.configure_scene_ui()` con TUS valores
- La UI aparece con la configuración de ESA escena específica

---

## 🎮 EJEMPLO PRÁCTICO

### Escena A (test_node_A.tscn):
```
Nodo raíz: TestNodeA
├── Script: scene_ui_config.gd
├── focus_item_position: (621, 491)  ← VALOR ÚNICO DE ESTA ESCENA
├── focus_item_scale: (0.192, 0.162)  ← VALOR ÚNICO DE ESTA ESCENA
└── visible_direction_buttons: ["left"]  ← VALOR ÚNICO DE ESTA ESCENA
```

### Escena B (test_node_A1.tscn):
```
Nodo raíz: Node2D
├── Script: scene_ui_config.gd
├── focus_item_position: (645, 339)  ← VALOR DIFERENTE
├── focus_item_scale: (1, 1)  ← VALOR DIFERENTE
└── visible_direction_buttons: ["left", "right"]  ← VALOR DIFERENTE
```

**Cada escena tiene su propia configuración única.**

---

## 📋 PASOS PARA CONFIGURAR UNA ESCENA

### Paso 1: Asigna el script
1. Abre tu escena
2. Selecciona el nodo raíz
3. Asigna el script: `res://Scripts/scene_ui_config.gd`

### Paso 2: Configura las propiedades (IMPORTANTE)
En el Inspector, con el nodo raíz seleccionado:

1. **`focus_item_position`**: 
   - Click en el campo
   - Escribe la posición X e Y donde quieres el FocusItem
   - Ejemplo: `X: 621, Y: 491`
   - **Cada escena tiene su propia posición**

2. **`focus_item_scale`**: 
   - Click en el campo
   - Escribe el tamaño (normalmente 1, 1)
   - **Cada escena puede tener su propio tamaño**

3. **`visible_direction_buttons`**: 
   - Click en el array
   - Agrega los botones que quieres: "left", "right", "up", "down"
   - **Cada escena puede mostrar botones diferentes**

### Paso 3: ¡Listo!
Al ejecutar, la UI aparecerá con la configuración de ESA escena específica.

---

## ✅ VENTAJAS DE ESTE ENFOQUE

1. **Cada escena es independiente**: No hay valores compartidos
2. **Fácil de configurar**: Solo editas en el Inspector
3. **Visual**: Ves los valores directamente en el editor
4. **Sin código**: No necesitas escribir código, solo configurar propiedades

---

## 🔍 VERIFICACIÓN

Para verificar que cada escena tiene su configuración única:

1. Abre `test_node_A.tscn` → Mira los valores en el Inspector
2. Abre `test_node_A1.tscn` → Mira los valores (deben ser diferentes)
3. Cada escena tiene sus propios valores únicos

---

## ❓ PREGUNTAS FRECUENTES

### ¿Por qué todas las escenas usan el mismo script?
- El script es solo un "helper" que aplica la configuración
- Cada escena tiene sus propios valores en el Inspector
- Es como usar la misma plantilla pero con datos diferentes

### ¿Puedo tener valores diferentes en cada escena?
- **¡SÍ!** Ese es el punto
- Cada escena configura sus valores en el Inspector
- No hay valores compartidos

### ¿Qué pasa si no configuro los valores?
- Si `focus_item_position` es (0, 0): No aparecerá FocusItem
- Si `visible_direction_buttons` está vacío: No aparecerán botones
- Funciona, pero no verás la UI

---

## 🎓 RESUMEN

1. **UI_manager existe automáticamente** (singleton)
2. **Cada escena configura sus propios valores** en el Inspector
3. **El script aplica esos valores** cuando la escena se carga
4. **Cada escena es única** - no hay valores compartidos

**Es simple: configura los valores en el Inspector de cada escena y listo.**
