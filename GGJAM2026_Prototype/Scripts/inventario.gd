extends Control
@onready var inventory: Panel = $image_Game/Inventory


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inventory.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	inventory.visible = true
	pass # Replace with function body.


func _on_close_inventory_button_pressed() -> void:
	inventory.visible = false
	pass # Replace with function body.
