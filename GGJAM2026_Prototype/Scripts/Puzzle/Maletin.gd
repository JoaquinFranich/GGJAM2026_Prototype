extends Area2D

@onready var pickup_item: Area2D = $"../PickupItem"
@onready var area_2d: Area2D = $"."
@onready var sprite_2d: Sprite2D = $Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_2d.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	


func _on_pickup_item_tree_exited() -> void:
	sprite_2d.visible = true
	pass # Replace with function body.
