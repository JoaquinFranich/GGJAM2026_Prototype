# 📖 GUÍA COMPLETA: Cómo usar UI_manager

## 🎯 CONCEPTO PRINCIPAL

**UI_manager es un SINGLETON (autoload)** - Esto significa que:
- ✅ Se carga automáticamente al iniciar el juego
- ✅ Existe UNA SOLA VEZ en todo el juego
- ✅ Persiste entre cambios de escena
- ❌ **NO debes instanciarlo dentro de las escenas**
- ❌ **NO debes agregar botones o FocusItem directamente en las escenas**

---

## 🏗️ JERARQUÍA DEL PROYECTO

```
📁 Proyecto
│
├── 🔧 SINGLETONS (Autoloads - Se cargan automáticamente)
│   ├── SceneManager (gestiona cambios de escena)
│   ├── DialogueManager (gestiona diálogos)
│   └── UI_manager (gestiona TODA la interfaz)
│       ├── Botones de dirección (Left, Right, Up, Down)
│       ├── FocusItem (se crea dinámicamente)
│       ├── Panel de diálogo (manejado por DialogueManager)
│       └── Inventario (preparado para futuro)
│
└── 🎬 ESCENAS DEL JUEGO (cada una es independiente)
    ├── test_node_00.tscn
    ├── test_node_A.tscn
    ├── test_node_A1.tscn
    ├── test_node_A2.tscn
    └── ... (todas las demás escenas)
```

### ⚠️ IMPORTANTE: Capas Visuales

```
┌─────────────────────────────────────┐
│  UI_manager (CanvasLayer - layer 5) │ ← SIEMPRE ARRIBA
│  - Botones de dirección             │
│  - FocusItem                        │
│  - Diálogos                         │
│  - Inventario                       │
├─────────────────────────────────────┤
│  Escenas del juego (Node2D)         │ ← CONTENIDO DEL JUEGO
│  - Background                       │
│  - Sprites                          │
│  - Objetos interactivos             │
└─────────────────────────────────────┘
```

**La UI está SIEMPRE por delante** porque usa `CanvasLayer` con `layer = 5`.

---

## 📝 PASOS PARA CONFIGURAR UNA ESCENA

### Paso 1: Abre tu escena en el editor

Ejemplo: `test_node_A.tscn`

### Paso 2: Asegúrate de que el nodo raíz tenga el script `scene_ui_config.gd`

**En el Inspector:**
- Selecciona el nodo raíz (ej: "TestNodeA")
- En la pestaña "Inspector", busca "Script"
- Debe tener asignado: `res://Scripts/scene_ui_config.gd`

Si no lo tiene:
1. Click en el nodo raíz
2. Click en el ícono de script (📜) en la barra superior
3. Selecciona "Cargar" y busca `scene_ui_config.gd`

### Paso 3: Configura las propiedades exportadas

En el Inspector, con el nodo raíz seleccionado, verás estas propiedades:

#### 🎯 `focus_item_position` (Vector2)
- **¿Qué es?** La posición donde aparecerá el FocusItem en esta escena
- **Ejemplo:** `Vector2(621, 491)`
- **Si no quieres FocusItem:** Deja `Vector2(0, 0)`

#### 📏 `focus_item_scale` (Vector2)
- **¿Qué es?** El tamaño del FocusItem
- **Ejemplo:** `Vector2(0.192, 0.162)`
- **Por defecto:** `Vector2(1, 1)`

#### 🔘 `visible_direction_buttons` (Array[String])
- **¿Qué es?** Qué botones de dirección quieres mostrar
- **Opciones:** `"left"`, `"right"`, `"up"`, `"down"`
- **Ejemplos:**
  - Solo botón izquierdo: `["left"]`
  - Izquierda y derecha: `["left", "right"]`
  - Todos: `["left", "right", "up", "down"]`
  - Ninguno: `[]` (array vacío)

#### 🆙 `button_up_target_scene` (String) - OPCIONAL
- **¿Qué es?** Solo si usas el botón "Up", aquí pones la escena destino
- **Ejemplo:** `"res://Scenes/Main Scenes/techo_scene.tscn"`
- **Si no usas botón Up:** Deja vacío `""`

### Paso 4: ¡Listo! 🎉

Cuando ejecutes la escena, el script `scene_ui_config.gd` automáticamente:
1. Configurará el FocusItem en la posición que indicaste
2. Mostrará/ocultará los botones según tu configuración
3. Todo esto usando el `UI_manager` que ya existe (singleton)

---

## 🎮 EJEMPLOS PRÁCTICOS

### Ejemplo 1: Escena principal con solo botón izquierdo

```
Nodo raíz: TestNodeA
├── Script: scene_ui_config.gd
├── focus_item_position: (621, 491)
├── focus_item_scale: (0.192, 0.162)
├── visible_direction_buttons: ["left"]
└── button_up_target_scene: "" (vacío)
```

### Ejemplo 2: Subescena con navegación izquierda/derecha

```
Nodo raíz: Node2D
├── Script: scene_ui_config.gd
├── focus_item_position: (645, 339)
├── focus_item_scale: (1, 1)
├── visible_direction_buttons: ["left", "right"]
└── button_up_target_scene: "" (vacío)
```

### Ejemplo 3: Escena con botón "mirar arriba"

```
Nodo raíz: Node2D
├── Script: scene_ui_config.gd
├── focus_item_position: (500, 400)
├── focus_item_scale: (1, 1)
├── visible_direction_buttons: ["left", "up"]
└── button_up_target_scene: "res://Scenes/Main Scenes/techo.tscn"
```

---

## ❌ ERRORES COMUNES Y CÓMO EVITARLOS

### ❌ Error 1: Instanciar UI_manager dentro de una escena

**Síntoma:** Las flechas no aparecen, o aparecen duplicadas

**Causa:** Agregaste `UI_manager` como hijo de tu escena

**Solución:** 
- ❌ NO hagas esto: `[node name="UI_manager" parent="." instance=...]`
- ✅ El UI_manager ya existe como singleton, no lo instancies

### ❌ Error 2: Agregar FocusItem directamente en la escena

**Síntoma:** FocusItem aparece dos veces o en posición incorrecta

**Causa:** Agregaste `FocusItem` como hijo de tu escena

**Solución:**
- ❌ NO hagas esto: `[node name="FocusItem" parent="." instance=...]`
- ✅ El FocusItem se crea automáticamente por UI_manager

### ❌ Error 3: Agregar botones de dirección en la escena

**Síntoma:** Botones duplicados o que no funcionan

**Causa:** Agregaste botones como hijos de tu escena

**Solución:**
- ❌ NO agregues botones manualmente
- ✅ Los botones ya existen en UI_manager, solo configúralos con `visible_direction_buttons`

### ❌ Error 4: No tener el script scene_ui_config.gd

**Síntoma:** La UI no aparece

**Causa:** El nodo raíz no tiene el script

**Solución:**
- ✅ Asigna `scene_ui_config.gd` al nodo raíz de tu escena

---

## 🔍 VERIFICACIÓN RÁPIDA

Antes de ejecutar tu escena, verifica:

- [ ] El nodo raíz tiene el script `scene_ui_config.gd`
- [ ] `focus_item_position` está configurado (o es (0,0) si no quieres FocusItem)
- [ ] `visible_direction_buttons` tiene los botones que quieres mostrar
- [ ] NO hay instancias de `UI_manager` dentro de la escena
- [ ] NO hay instancias de `FocusItem` dentro de la escena
- [ ] NO hay botones de dirección dentro de la escena

---

## 🎓 RESUMEN ULTRA SIMPLE

1. **UI_manager existe automáticamente** (no lo instancies)
2. **En cada escena:** Asigna `scene_ui_config.gd` al nodo raíz
3. **Configura 3 propiedades:** posición FocusItem, escala, botones visibles
4. **¡Listo!** La UI aparece automáticamente

---

## 🆘 ¿NECESITAS AYUDA?

Si algo no funciona:
1. Verifica que `UI_manager` esté en `project.godot` como autoload
2. Verifica que el nodo raíz tenga el script correcto
3. Revisa la consola de errores en Godot
4. Compara tu escena con `test_node_00.tscn` que está funcionando correctamente
