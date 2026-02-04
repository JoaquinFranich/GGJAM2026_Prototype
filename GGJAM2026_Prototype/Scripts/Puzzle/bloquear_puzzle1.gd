extends Sprite2D
@onready var test_node_a: Node2D = $".."
var puzzle_candado = PuzzleManager.puzzle_candado

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if PuzzleManager.puzzle_candado == true:
		test_node_a.button_right_target_scene = ""
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#var padre = get_tree().get_first_node_in_group("Direction Buttons Configuration")
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#if PuzzleManager.puzzle_candado == true:
		#if padre:
			#var hijo = padre.get_node("Background")
			#
