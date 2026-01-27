extends Node2D

var hand_cursor = preload("res://Assets/Images/HandCursor.png")

# Diccionario que mapea el nombre del nodo Area2D a su escena destino
# Puedes modificar estas rutas según las escenas que crees
var scene_mapping = {
	"FocusItem": "res://Scenes/test_node2.tscn",
	"ButtonLeft": "res://Scenes/test_node.tscn",
	"ButtonRight": "res://Scenes/button_right_scene.tscn",
	"ButtonUp": "res://Scenes/button_up_scene.tscn",
	"ButtonDown": "res://Scenes/button_down_scene.tscn"
}

# Called when the node enters the scene tree for the first time.
func _ready():
	# Conectar señales input_event para todos los Area2D
	_connect_area2d_signals()

func _connect_area2d_signals():
	# Conectar FocusItem
	var focus_area = get_node_or_null("FocusItem/Area2D")
	if focus_area:
		# Conectar señal de click
		if not focus_area.input_event.is_connected(_on_area2d_input_event):
			focus_area.input_event.connect(_on_area2d_input_event.bind("FocusItem"))
		
		# Conectar señales de hover para cambio de cursor
		if not focus_area.mouse_entered.is_connected(change_cursor_hand):
			focus_area.mouse_entered.connect(change_cursor_hand)
		if not focus_area.mouse_exited.is_connected(change_cursor_back):
			focus_area.mouse_exited.connect(change_cursor_back)
	
	# Conectar botones de dirección
	var button_names = ["ButtonLeft", "ButtonRight", "ButtonUp", "ButtonDown"]
	for button_name in button_names:
		var button_area = get_node_or_null("DirectionButtons/" + button_name + "/Area2D")
		if button_area:
			# Conectar señal de click
			if not button_area.input_event.is_connected(_on_area2d_input_event):
				button_area.input_event.connect(_on_area2d_input_event.bind(button_name))
			
			# Conectar señales de hover para cambio de cursor
			if not button_area.mouse_entered.is_connected(change_cursor_hand):
				button_area.mouse_entered.connect(change_cursor_hand)
			if not button_area.mouse_exited.is_connected(change_cursor_back):
				button_area.mouse_exited.connect(change_cursor_back)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Maneja el evento de input en los Area2D
func _on_area2d_input_event(viewport: Node, event: InputEvent, shape_idx: int, area_name: String):
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_LEFT:
			# Cambiar a la escena correspondiente
			if scene_mapping.has(area_name):
				var target_scene = scene_mapping[area_name]
				SceneManager.change_scene(target_scene)
			else:
				push_warning("No hay escena asignada para: " + area_name)

func change_cursor_hand():
	Input.set_custom_mouse_cursor(hand_cursor)
	
func change_cursor_back():
	Input.set_custom_mouse_cursor(null)
