extends "res://Scripts/scene_ui_config.gd"

## Script para la escena intermedia de manos
## Maneja la secuencia Hand1 -> Hand2 -> Fade a F7

@export_category("Hands Sequence Refs")
@export var hand1_node: Sprite2D
@export var hand2_node: Sprite2D

func configure_ui():
	# Ocultar toda la UI (botones dirección, mask button, etc)
	if UI_manager:
		UI_manager.hide_all_direction_buttons()
		UI_manager.set_current_clue(null) # Ocultar botón máscara
		UI_manager.clear_all_focus_items() # Asegurar que no haya focus items

func _ready():
	super._ready()
	
	# Inicializar referencias si no están asignadas
	if not hand1_node: hand1_node = get_node_or_null("Hand1")
	if not hand2_node: hand2_node = get_node_or_null("Hand2")
	
	_start_sequence()

func _start_sequence():
	# Estado inicial: Hand1 visible, Hand2 invisible
	if hand1_node: hand1_node.visible = true
	if hand2_node: hand2_node.visible = false
	
	# 1. Esperar 1.5s
	await get_tree().create_timer(1.5).timeout
	
	# 2. Switch Hands
	if hand1_node: hand1_node.visible = false
	if hand2_node: hand2_node.visible = true
	
	# 3. Esperar 3.5s (Total 5s)
	await get_tree().create_timer(3.5).timeout
	
	# 4. Transición lenta a F7
	SceneManager.set_fade_duration(3.0)
	SceneManager.change_scene("res://Scenes/Sub Scenes/test_node_F7.tscn")
