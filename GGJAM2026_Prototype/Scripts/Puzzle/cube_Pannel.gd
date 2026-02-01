extends Panel

@onready var panel: Panel = $"."
@export var images: Array[Texture2D]
@export var index = 0
var index_Init = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	index_Init = index
	update_image()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	update_image()
	pass # Replace with function body.

func update_image():
	var style = StyleBoxTexture.new()
	style.texture = images[index_Init]
	add_theme_stylebox_override("panel", style) 

func next_image():
	index_Init = (index_Init + 1) % images.size()
	update_image()
	
func get_current_image_index():
	return index_Init
