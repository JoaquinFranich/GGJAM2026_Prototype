extends Node2D

@onready var ui = $UI

## ============================================================================
## SCRIPT PARA CONFIGURAR LA UI EN CADA ESCENA
## ============================================================================
## 
## INSTRUCCIONES:
## 1. Asigna este script al nodo raíz de tu escena
## 2. Configura las propiedades en el Inspector (abajo)
## 3. ¡Listo! La UI aparecerá automáticamente
##
## ⚠️ IMPORTANTE: NO instancies UI_manager ni FocusItem en tu escena.
##    Todo se maneja automáticamente a través de este script.
## ============================================================================

## 📍 Posición donde aparecerá el FocusItem en esta escena (LEGACY - un solo FocusItem)
## ⚠️ Si usas focus_items, ignora esto
## Si no quieres FocusItem, deja (0, 0)
@export var focus_item_position: Vector2 = Vector2.ZERO

## 📏 Tamaño del FocusItem (1, 1 = tamaño normal) (LEGACY - un solo FocusItem)
@export var focus_item_scale: Vector2 = Vector2.ONE

## 🎯 Escena destino para el FocusItem (Opcional)
## Si lo dejas vacío, el juego decidirá automáticamente (comportamiento por defecto)
## Si pones una ruta, el FocusItem te llevará ahí obligatoriamente.
@export var focus_item_target_scene: String = ""

@export var scene_entry_text: String = ""

## 🎯 Configuración de múltiples FocusItems
## Cada elemento del array es un FocusItem con:
## - position: Vector2 (posición)
## - scale: Vector2 (tamaño, opcional)
## - target_scene: String (escena destino, opcional, "" = navegación automática)
## - dialogue: String (texto a mostrar, opcional, si no hay target_scene)
## 
## EJEMPLO en código:
## focus_items = [
##   {"position": Vector2(100, 200), "scale": Vector2(1, 1), "target_scene": "res://path/to/scene1.tscn"},
##   {"position": Vector2(500, 300), "dialogue": "Mira, una pista."}
## ]
##
## ⚠️ NOTA: Esta propiedad no se puede editar directamente en el Inspector de Godot.
##    Usa el método configure_focus_items_manual() en _ready() o configura
##    focus_item_position para un solo FocusItem.
@export var focus_items: Array = []

## 🔘 Botones de dirección que quieres mostrar
## ⚠️ CONFIGURA ESTE VALOR EN EL INSPECTOR PARA CADA ESCENA
## Opciones: "left", "right", "up", "down"
## Ejemplo: ["left", "right"] muestra solo izquierda y derecha
@export var visible_direction_buttons: Array[String] = []

## 🆙 Escena destino para el botón "Up" (solo si usas botón arriba)
## Ejemplo: "res://Scenes/Main Scenes/techo.tscn"
## Si no usas botón Up, deja vacío ""
## 🆙 Escena destino para el botón "Up" (solo si usas botón arriba)
## Ejemplo: "res://Scenes/Main Scenes/techo.tscn"
## Si no usas botón Up, deja vacío ""
@export_group("Direction Buttons Configuration")
## 🆙 Escena destino para el botón "Up" (solo si usas botón arriba)
## Ejemplo: "res://Scenes/Main Scenes/techo.tscn"
@export var button_up_target_scene: String = ""

## ⬇️ Escena destino para el botón "Down"
@export var button_down_target_scene: String = ""

## ⬅️ Escena destino para el botón "Left"
@export var button_left_target_scene: String = ""

## ➡️ Escena destino para el botón "Right"
@export var button_right_target_scene: String = ""

@export_group("Mask Configuration")
## 🎭 Textura de la pista para la Máscara
## Si dejas esto vacío (null), el botón de la máscara NO aparecerá en esta escena.
## Asigna una imagen aquí para habilitar la máscara y mostrar esta pista.
@export var mask_clue_texture: Texture2D

## 📍 Posición de la imagen de la pista (relativa al centro o según config de UI)
## Ajusta esto para mover la imagen dentro de la máscara
@export var mask_clue_position: Vector2 = Vector2.ZERO

## 📏 Escala de la imagen de la pista
## Ajusta esto para cambiar el tamaño de la imagen
@export var mask_clue_scale: Vector2 = Vector2.ONE


func _ready():
	# Esperar un frame para asegurar que UI_manager esté listo
	await get_tree().process_frame
	if ui:
		ui.visible = false
	# Configurar la UI
	configure_ui()

## Configura la UI de esta escena automáticamente
func configure_ui():
	# Verificar que UI_manager existe
	if not UI_manager:
		push_error("scene_ui_config: UI_manager no encontrado. ¿Está registrado como autoload?")
		return
	
	# Si hay configuración de múltiples FocusItems, usarla
	if focus_items.size() > 0:
		UI_manager.configure_scene_ui_multiple(focus_items, visible_direction_buttons)
	# Si no, usar el método legacy (un solo FocusItem)
	elif focus_item_position != Vector2.ZERO:
		UI_manager.configure_scene_ui(focus_item_position, focus_item_scale, visible_direction_buttons, focus_item_target_scene)
	else:
		# Si no hay posición, ocultar FocusItem pero mostrar botones
		UI_manager.configure_scene_ui(Vector2.ZERO, Vector2.ONE, visible_direction_buttons)
	
	# Configurar Botones de Dirección
	_configure_direction_button("up", button_up_target_scene)
	_configure_direction_button("down", button_down_target_scene)
	_configure_direction_button("left", button_left_target_scene)
	_configure_direction_button("right", button_right_target_scene)
	

	# Configurar Pista de Máscara
	# Si mask_clue_texture es null, set_current_clue ocultará el botón
	UI_manager.set_current_clue(mask_clue_texture, mask_clue_position, mask_clue_scale)
	
	# Mostrar texto de contexto si existe
	if scene_entry_text != "":
		# Pequeño delay para asegurar que el fade-in de la escena no oculte el diálogo
		await get_tree().create_timer(0.5).timeout
		DialogueManager.show_dialogue([scene_entry_text])

func _configure_direction_button(direction: String, target_scene_path: String):
	if target_scene_path != "":
		var button = UI_manager.get_direction_button(direction)
		if button:
			# Verificar si el botón tiene la propiedad target_scene (up, left, right, down modificados)
			if "target_scene" in button:
				button.target_scene = target_scene_path
			else:
				push_warning("scene_ui_config: El botón '" + direction + "' no soporta target_scene")
		else:
			# Solo advertir si se esperaba usar pero el botón no está en UI manager (raro si está en visible_buttons)
			pass

## Configura múltiples FocusItems manualmente desde código
## Úsalo en _ready() si prefieres configurar desde código en lugar del Inspector
## Ejemplo:
##   configure_focus_items_manual([
##     {"position": Vector2(100, 200), "target_scene": "res://Scenes/Sub Scenes/test_node_A4.tscn"},
##     {"position": Vector2(500, 300), "dialogue": "Un texto de prueba"}
##   ])
func configure_focus_items_manual(focus_items_config: Array):
	focus_items = focus_items_config
	if UI_manager:
		UI_manager.configure_scene_ui_multiple(focus_items, visible_direction_buttons)
