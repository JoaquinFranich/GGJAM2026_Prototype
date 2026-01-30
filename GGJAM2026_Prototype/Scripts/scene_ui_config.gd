extends Node2D

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

## 🎯 Configuración de múltiples FocusItems
## Cada elemento del array es un FocusItem con:
## - position: Vector2 (posición)
## - scale: Vector2 (tamaño, opcional)
## - target_scene: String (escena destino, opcional, "" = navegación automática)
## 
## EJEMPLO en código:
## focus_items = [
##   {"position": Vector2(100, 200), "scale": Vector2(1, 1), "target_scene": "res://path/to/scene1.tscn"},
##   {"position": Vector2(500, 300), "target_scene": "res://path/to/scene2.tscn"}
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
@export var button_up_target_scene: String = ""

func _ready():
	# Esperar un frame para asegurar que UI_manager esté listo
	await get_tree().process_frame
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
		UI_manager.configure_scene_ui(focus_item_position, focus_item_scale, visible_direction_buttons)
	else:
		# Si no hay posición, ocultar FocusItem pero mostrar botones
		UI_manager.configure_scene_ui(Vector2.ZERO, Vector2.ONE, visible_direction_buttons)
	
	# Configurar ButtonUp si tiene target_scene
	if button_up_target_scene != "":
		var button_up = UI_manager.get_direction_button("up")
		if button_up:
			button_up.target_scene = button_up_target_scene
		else:
			push_warning("scene_ui_config: No se encontró el botón 'up' en UI_manager")

## Configura múltiples FocusItems manualmente desde código
## Úsalo en _ready() si prefieres configurar desde código en lugar del Inspector
## Ejemplo:
##   configure_focus_items_manual([
##     {"position": Vector2(100, 200), "target_scene": "res://Scenes/Sub Scenes/test_node_A4.tscn"},
##     {"position": Vector2(500, 300), "target_scene": "res://Scenes/Sub Scenes/test_node_A5.tscn"}
##   ])
func configure_focus_items_manual(focus_items_config: Array):
	focus_items = focus_items_config
	if UI_manager:
		UI_manager.configure_scene_ui_multiple(focus_items, visible_direction_buttons)
