extends "res://Scripts/scene_ui_config.gd"

## Script para la secuencia final de la Escena F6
## Maneja la aparición de manos y la transición a F7

@export_category("F6 Sequence Refs")
@export var hand1_node: Sprite2D
@export var hand2_node: Sprite2D

# Variable para evitar múltiples activaciones
var _sequence_started = false

# Override de configure_ui para evitar que scene_ui_config cree el FocusItem por defecto
func configure_ui():
	# Solo ocultar botones de dirección, no crear FocusItem automático
	if UI_manager:
		UI_manager.hide_all_direction_buttons()
	
	# Configurar nuestra interacción personalizada
	_setup_custom_interaction()

func _ready():
	# Inicializar referencias si no se asignaron en editor (fallback)
	if not hand1_node: hand1_node = get_node_or_null("Hand1")
	if not hand2_node: hand2_node = get_node_or_null("Hand2")
	
	# Asegurar estado inicial
	if hand1_node: hand1_node.visible = false
	if hand2_node: hand2_node.visible = false
	
	# Llamar al padre (que llamará a configure_ui, que ahora es nuestro override)
	super._ready()

func _setup_custom_interaction():
	# Usaremos un botón invisible para la interacción
	var interaction_button = TextureButton.new()
	interaction_button.name = "InteractionButton"
	interaction_button.size = Vector2(200, 200) # Tamaño aproximado del monolito
	interaction_button.position = Vector2(925 - 100, 575 - 100) # Centrado en la posición original
	
	# Configurar cursor para el botón
	interaction_button.mouse_entered.connect(func(): CursorManager.set_hand_cursor())
	interaction_button.mouse_exited.connect(func(): CursorManager.reset_cursor())
	interaction_button.button_down.connect(func(): CursorManager.set_click_cursor())
	interaction_button.button_up.connect(func(): CursorManager.set_hand_cursor())
	
	interaction_button.pressed.connect(_on_monolith_clicked)
	add_child(interaction_button)

func _on_monolith_clicked():
	if _sequence_started:
		return
	
	_sequence_started = true
	
	# Deshabilitar interacción global si es posible o simplemente ignorar inputs
	if UI_manager and UI_manager._mask_button:
		UI_manager._mask_button.disabled = true
	
	# 1. Mostrar Hand1
	if hand1_node:
		hand1_node.visible = true
	
	# 2. Timer de 1.5s para Hand2
	await get_tree().create_timer(1.5).timeout
	
	# 3. Switch Hands
	if hand1_node: hand1_node.visible = false
	if hand2_node: hand2_node.visible = true
	
	# 4. Timer de 3.5s (Total 5s desde inicio de secuencia)
	await get_tree().create_timer(3.5).timeout
	
	# 5. Transición lenta a F7
	SceneManager.set_fade_duration(3.0)
	SceneManager.change_scene("res://Scenes/Sub Scenes/test_node_F7.tscn")
	
	# Restaurar duración del fade después de que termine esta transición (en F7 o al terminar)
	# Lo haremos en el script de F7 para asegurar
