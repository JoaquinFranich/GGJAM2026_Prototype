# 📖 GUÍA PASO A PASO: Configurar UI en el Inspector

## 🎯 OBJETIVO

Aprender a configurar las propiedades `focus_item_position`, `focus_item_scale` y `visible_direction_buttons` en el Inspector de Godot para cada escena.

---

## 📋 PASO 1: Abrir tu escena

1. En Godot, ve al panel **FileSystem** (abajo a la izquierda)
2. Navega a la carpeta de tus escenas (ej: `Scenes/Main Scenes/`)
3. **Doble click** en la escena que quieres configurar (ej: `test_node_A.tscn`)
4. La escena se abrirá en el editor de escenas

---

## 📋 PASO 2: Seleccionar el nodo raíz

1. En el panel **Scene** (arriba a la izquierda), verás el árbol de nodos
2. Busca el nodo raíz (generalmente se llama `TestNodeA`, `Node2D`, o similar)
3. **Click una vez** en el nodo raíz para seleccionarlo
4. Verás que se resalta en azul

**Ejemplo del árbol de nodos:**
```
📁 test_node_A.tscn
  └── 🟦 TestNodeA (Node2D)  ← Este es el nodo raíz, selecciónalo
      └── Background (Sprite2D)
```

---

## 📋 PASO 3: Verificar que tiene el script

1. Con el nodo raíz seleccionado, mira el panel **Inspector** (lado derecho)
2. Busca la sección **"Script"** (casi al final del Inspector)
3. Debe mostrar: `res://Scripts/scene_ui_config.gd`

**Si NO tiene el script:**
1. Click en el ícono **📜** (script) en la barra superior del editor
2. Selecciona **"Cargar"**
3. Busca y selecciona: `res://Scripts/scene_ui_config.gd`
4. Click en **"Abrir"**

---

## 📋 PASO 4: Configurar `focus_item_position`

### ¿Qué es?
La posición (X, Y) donde aparecerá el FocusItem en esta escena.

### Pasos detallados:

1. En el **Inspector**, busca la propiedad `focus_item_position`
   - Está en la sección del script `scene_ui_config`
   - Verás algo como: `focus_item_position: Vector2(0, 0)`

2. **Click en el campo** `Vector2(0, 0)`
   - Se expandirá mostrando dos campos: `x` y `y`

3. **Configura el valor X:**
   - Click en el campo `x` (o usa Tab para moverte)
   - Escribe el valor: `621`
   - Presiona Enter o click fuera

4. **Configura el valor Y:**
   - Click en el campo `y`
   - Escribe el valor: `491`
   - Presiona Enter o click fuera

5. **Resultado:**
   - Deberías ver: `focus_item_position: Vector2(621, 491)`

**Visualización:**
```
Inspector
├── ...
├── Script Variables (scene_ui_config.gd)
│   ├── focus_item_position
│   │   ├── x: [621]  ← Escribe aquí
│   │   └── y: [491]  ← Escribe aquí
│   ├── focus_item_scale
│   └── visible_direction_buttons
```

**💡 Tip:** Si no quieres FocusItem en esta escena, deja `(0, 0)`

---

## 📋 PASO 5: Configurar `focus_item_scale`

### ¿Qué es?
El tamaño del FocusItem. `(1, 1)` es tamaño normal, valores menores lo hacen más pequeño.

### Pasos detallados:

1. En el **Inspector**, busca la propiedad `focus_item_scale`
   - Está justo debajo de `focus_item_position`
   - Por defecto muestra: `Vector2(1, 1)`

2. **Click en el campo** `Vector2(1, 1)`
   - Se expandirá mostrando dos campos: `x` y `y`

3. **Configura el valor X:**
   - Click en el campo `x`
   - Escribe el valor: `0.192`
   - Presiona Enter

4. **Configura el valor Y:**
   - Click en el campo `y`
   - Escribe el valor: `0.162`
   - Presiona Enter

5. **Resultado:**
   - Deberías ver: `focus_item_scale: Vector2(0.192, 0.162)`

**💡 Tip:** Si quieres tamaño normal, deja `(1, 1)`

---

## 📋 PASO 6: Configurar `visible_direction_buttons`

### ¿Qué es?
Un array (lista) que indica qué botones de dirección quieres mostrar.

### Pasos detallados:

#### Opción A: Agregar botones uno por uno (RECOMENDADO)

1. En el **Inspector**, busca la propiedad `visible_direction_buttons`
   - Está debajo de `focus_item_scale`
   - Verás: `Array[String]` con un botón `[+]` al lado

2. **Click en el botón `[+]`** para agregar un elemento
   - Aparecerá un campo vacío: `[0] = ""`

3. **Escribe el nombre del botón:**
   - Click en el campo vacío
   - Escribe: `left` (en minúsculas, sin comillas)
   - Presiona Enter
   - Verás: `[0] = "left"`

4. **Para agregar más botones:**
   - Click en `[+]` de nuevo
   - Escribe: `right`
   - Presiona Enter
   - Verás: `[0] = "left"` y `[1] = "right"`

5. **Para eliminar un botón:**
   - Click en el botón `[-]` al lado del elemento que quieres eliminar

**Opciones válidas:**
- `"left"` - Botón izquierdo
- `"right"` - Botón derecho
- `"up"` - Botón arriba
- `"down"` - Botón abajo

**Ejemplo visual:**
```
visible_direction_buttons: Array[String]
  [0] = "left"   ← Click [+] y escribe "left"
  [1] = "right"  ← Click [+] y escribe "right"
  [+] [-]
```

#### Opción B: Usar el editor de arrays (alternativa)

1. **Click derecho** en `visible_direction_buttons`
2. Selecciona **"Edit Array"** o **"Editar Array"**
3. En la ventana que aparece:
   - Click en `Add Element`
   - Escribe `left`
   - Repite para más botones
4. Click en **"OK"**

---

## 📋 PASO 7: Guardar la escena

1. **Presiona Ctrl+S** (o Cmd+S en Mac)
2. O click en el botón **💾 Guardar** en la barra superior
3. La escena se guardará con tu configuración

---

## 📋 PASO 8: Probar la configuración

1. **Presiona F5** para ejecutar el juego
2. O click en el botón **▶️ Play** en la barra superior
3. Verifica que:
   - El FocusItem aparece en la posición que configuraste
   - Los botones que configuraste están visibles
   - Todo funciona correctamente

---

## 🎯 EJEMPLO COMPLETO

Vamos a configurar `test_node_A.tscn` paso a paso:

### Configuración objetivo:
- `focus_item_position`: `(621, 491)`
- `focus_item_scale`: `(0.192, 0.162)`
- `visible_direction_buttons`: `["left"]`

### Pasos:

1. ✅ Abre `test_node_A.tscn`
2. ✅ Selecciona el nodo raíz `TestNodeA`
3. ✅ Verifica que tiene el script `scene_ui_config.gd`
4. ✅ En `focus_item_position`:
   - Click en `Vector2(0, 0)`
   - Escribe `x: 621`
   - Escribe `y: 491`
5. ✅ En `focus_item_scale`:
   - Click en `Vector2(1, 1)`
   - Escribe `x: 0.192`
   - Escribe `y: 0.162`
6. ✅ En `visible_direction_buttons`:
   - Click en `[+]`
   - Escribe `left`
7. ✅ Guarda (Ctrl+S)
8. ✅ Ejecuta (F5) y verifica

---

## 🖼️ CAPTURAS DE PANTALLA CONCEPTUALES

### Inspector antes de configurar:
```
┌─────────────────────────────────┐
│ Inspector                       │
├─────────────────────────────────┤
│ TestNodeA (Node2D)              │
│                                 │
│ Transform                       │
│ Position: (0, 0, 0)            │
│ ...                             │
│                                 │
│ Script Variables                │
│ (scene_ui_config.gd)            │
│                                 │
│ focus_item_position             │
│   Vector2(0, 0)  ← Click aquí  │
│                                 │
│ focus_item_scale               │
│   Vector2(1, 1)  ← Click aquí  │
│                                 │
│ visible_direction_buttons      │
│   Array[String] [+]  ← Click   │
└─────────────────────────────────┘
```

### Inspector después de configurar:
```
┌─────────────────────────────────┐
│ Inspector                       │
├─────────────────────────────────┤
│ TestNodeA (Node2D)              │
│                                 │
│ Script Variables                │
│ (scene_ui_config.gd)            │
│                                 │
│ focus_item_position             │
│   Vector2(621, 491)  ✅         │
│     x: 621                      │
│     y: 491                      │
│                                 │
│ focus_item_scale               │
│   Vector2(0.192, 0.162)  ✅     │
│     x: 0.192                    │
│     y: 0.162                    │
│                                 │
│ visible_direction_buttons      │
│   Array[String]  ✅             │
│     [0] = "left"                │
│     [+] [-]                     │
└─────────────────────────────────┘
```

---

## ❓ PREGUNTAS FRECUENTES

### ¿Por qué no veo las propiedades en el Inspector?
- **Asegúrate de que el nodo raíz tenga el script `scene_ui_config.gd`**
- Si no lo tiene, asígnalo (Paso 3)

### ¿Cómo sé qué valores poner?
- **`focus_item_position`**: Prueba valores hasta que el FocusItem esté donde quieres
- **`focus_item_scale`**: `(1, 1)` es normal, valores menores = más pequeño
- **`visible_direction_buttons`**: Agrega los botones que necesitas: `"left"`, `"right"`, `"up"`, `"down"`

### ¿Puedo copiar la configuración de una escena a otra?
- **Sí**, pero luego ajusta los valores según necesites
- Cada escena puede tener valores diferentes

### ¿Qué pasa si dejo todo en (0, 0) y array vacío?
- No aparecerá FocusItem
- No aparecerán botones
- La escena funcionará, pero sin UI visible

---

## ✅ CHECKLIST FINAL

Antes de guardar, verifica:

- [ ] El nodo raíz está seleccionado
- [ ] Tiene el script `scene_ui_config.gd`
- [ ] `focus_item_position` tiene valores (o es 0, 0 si no quieres FocusItem)
- [ ] `focus_item_scale` está configurado
- [ ] `visible_direction_buttons` tiene al menos un elemento (o está vacío si no quieres botones)
- [ ] Guardaste la escena (Ctrl+S)
- [ ] Probaste ejecutando (F5)

---

## 🎓 RESUMEN

1. **Abre la escena** → Selecciona nodo raíz → Verifica script
2. **Configura `focus_item_position`**: Click en Vector2 → Escribe X e Y
3. **Configura `focus_item_scale`**: Click en Vector2 → Escribe X e Y
4. **Configura `visible_direction_buttons`**: Click [+] → Escribe nombres de botones
5. **Guarda y prueba**

**¡Es así de simple!** Cada escena tiene su propia configuración única en el Inspector.
