# 📝 EJEMPLO PRÁCTICO: Configurar test_node_A3 con múltiples FocusItems

## 🎯 OBJETIVO

Configurar `test_node_A3.tscn` para que tenga **dos FocusItems**:
- FocusItem 1 → lleva a `test_node_A4.tscn`
- FocusItem 2 → lleva a `test_node_A5.tscn`

---

## 📋 PASO A PASO

### Paso 1: Abre la escena

1. En Godot, ve a `Scenes/Sub Scenes/test_node_A3.tscn`
2. **Doble click** para abrirla

### Paso 2: Selecciona el nodo raíz

1. En el panel **Scene**, selecciona el nodo raíz `TestNodeA3`
2. Verás sus propiedades en el **Inspector**

### Paso 3: Extiende el script

1. En el Inspector, busca la sección **"Script"**
2. Click en el ícono **📜** (script) en la barra superior
3. Selecciona **"Extender Script"**
4. En la ventana que aparece:
   - **Path:** `res://Scripts/test_node_A3_custom.gd`
   - **Template:** Deja como está
   - Click en **"Crear"**

### Paso 4: Edita el script

1. Se abrirá el editor de scripts con `test_node_A3_custom.gd`
2. **Ajusta las posiciones** de los FocusItems:
   ```gdscript
   "position": Vector2(400, 300),  # Cambia estos valores
   ```
   - Prueba diferentes valores hasta que los FocusItems estén donde quieres
   - Puedes ejecutar (F5) y ajustar

3. **Verifica las rutas de las escenas**:
   ```gdscript
   "target_scene": "res://Scenes/Sub Scenes/test_node_A4.tscn"
   ```
   - Asegúrate de que las rutas sean correctas
   - Si las escenas A4 y A5 no existen aún, créalas primero

### Paso 5: Guarda y prueba

1. **Guarda el script** (Ctrl+S)
2. **Guarda la escena** (Ctrl+S)
3. **Ejecuta el juego** (F5)
4. Verifica que:
   - Aparecen dos FocusItems en la escena A3
   - Cada uno lleva a su escena correspondiente

---

## 🎨 AJUSTAR POSICIONES

### Método 1: Prueba y error

1. Ejecuta el juego (F5)
2. Observa dónde aparecen los FocusItems
3. Detén el juego
4. Edita el script y cambia los valores de `position`
5. Repite hasta que estén donde quieres

### Método 2: Usar coordenadas del editor

1. En el editor de escenas, mueve el mouse sobre donde quieres el FocusItem
2. Mira las coordenadas en la parte inferior del editor
3. Usa esas coordenadas en el script

**Ejemplo:**
- Si quieres el FocusItem en la posición (621, 491) del editor
- Usa: `"position": Vector2(621, 491)`

---

## 🔧 CONFIGURACIÓN COMPLETA

### Script final para test_node_A3:

```gdscript
extends Node2D

func _ready():
	await get_tree().process_frame
	
	# Dos FocusItems
	configure_focus_items_manual([
		{
			"position": Vector2(400, 300),  # Ajusta según necesites
			"scale": Vector2(1, 1),
			"target_scene": "res://Scenes/Sub Scenes/test_node_A4.tscn"
		},
		{
			"position": Vector2(900, 300),  # Ajusta según necesites
			"scale": Vector2(1, 1),
			"target_scene": "res://Scenes/Sub Scenes/test_node_A5.tscn"
		}
	])
	
	# Solo botón izquierdo para volver
	UI_manager.hide_all_direction_buttons()
	UI_manager.show_direction_button("left", true)
```

---

## ✅ VERIFICACIÓN

Después de configurar, verifica:

- [ ] El script está asignado al nodo raíz
- [ ] Las posiciones están configuradas
- [ ] Las rutas de las escenas destino son correctas
- [ ] Al ejecutar, aparecen dos FocusItems
- [ ] Cada FocusItem lleva a su escena correspondiente

---

## 🆘 SOLUCIÓN DE PROBLEMAS

### Los FocusItems no aparecen
- Verifica que las posiciones no sean `(0, 0)`
- Asegúrate de que `UI_manager` esté registrado como autoload
- Revisa la consola de errores

### Los FocusItems no llevan a las escenas correctas
- Verifica que las rutas de `target_scene` sean correctas
- Asegúrate de que las escenas destino existan
- Revisa que las rutas empiecen con `"res://"`

### Solo aparece un FocusItem
- Verifica que el array tenga dos elementos
- Asegúrate de que ambos tengan `"position"` diferente de `(0, 0)`

---

## 🎓 RESUMEN

1. **Extiende el script** del nodo raíz
2. **Usa `configure_focus_items_manual()`** con un array de configuraciones
3. **Cada FocusItem** tiene posición, escala (opcional) y escena destino
4. **Ajusta las posiciones** hasta que estén donde quieres
5. **¡Listo!** Tienes múltiples FocusItems funcionando
