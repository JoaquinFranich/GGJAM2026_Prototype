extends "res://Scripts/scene_ui_config.gd"

## Script para la escena F6 (Monolito Lejano)
## Función: Interactuar con el monolito lleva a la escena de las manos (Close-up)

func configure_ui():
	# 1. Ocultar botones de dirección estándar
	if UI_manager:
		UI_manager.hide_all_direction_buttons()
	
	# 2. Configurar zona interactiva (FocusItem invisible)
	_setup_interaction_zone()

func _setup_interaction_zone():
	# Creamos un botón invisible que cubra el monolito
	var btn = TextureButton.new()
	btn.name = "MonolithClickZone"
	btn.size = Vector2(300, 400) # Área aproximada del monolito
	btn.position = Vector2(960 - 150, 540 - 200) # Centrado (ajustar si es necesario)
	
	# Cursor de mano al pasar por encima
	btn.mouse_entered.connect(func(): CursorManager.set_hand_cursor())
	btn.mouse_exited.connect(func(): CursorManager.reset_cursor())
	
	# Al hacer clic, ir a la escena de las manos
	btn.pressed.connect(_on_monolith_clicked)
	
	add_child(btn)

func _on_monolith_clicked():
	print("F6: Monolito clickeado. Avanzando a escena de manos.")
	SceneManager.change_scene("res://Scenes/Sub Scenes/test_scene_hands.tscn")
