extends Button

@onready var ui_puzzle: CanvasLayer = $"../../../.."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	get_parent().next_image()
	ui_puzzle.check_win()
	pass # Replace with function body.
