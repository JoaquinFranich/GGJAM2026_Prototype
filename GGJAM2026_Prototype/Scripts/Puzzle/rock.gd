extends Area2D

@export var snap_distance := 50
@export var correct_hole: Node2D

var drag = false
var offset = Vector2.ZERO
var correct = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	input_pickable = true
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if drag and not correct:
		global_position = get_global_mouse_position() + offset
	pass

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if correct:
		return
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			print("agarrar")
			drag = true
			offset = global_position - get_global_mouse_position()
		else:
			print("soltar")
			drag = false
			check_hole()
	pass # Replace with function body.

func check_hole():
	if global_position.distance_to(correct_hole.global_position) < snap_distance:
		print("Bien")
		correct = true
