extends Node2D
@export var solution: Array = [
	0,0,0,0,
	0,0,0,0,
	0,0,0,0
]
@onready var grid_container: GridContainer = $UI/HUD/GridContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func check_win():
	var grid = grid_container.get_children()
	var i = 0
	for panel in grid:
		if panel.get_current_image_index() != solution[i]:
			return
		i += i
	print("Correcto")
