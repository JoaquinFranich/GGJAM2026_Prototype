extends Area2D

@export var item_data: Inventory_item
@onready var inventario: Inventory = preload("res://Resource/Inventario.tres")

# Este es un objeto reutilizable que cuenta con un sprite y colision
#Detecta si el mouse esta encima del objeto y al hacer click_izq lo añade al inventario y desaparece

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mouse_entered() -> void:
	print("recoger objeto")
	pass # Replace with function body.


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("Recoger_objeto") == true:
		InventoryManager.add_item(item_data)
		queue_free()
	pass # Replace with function body.
