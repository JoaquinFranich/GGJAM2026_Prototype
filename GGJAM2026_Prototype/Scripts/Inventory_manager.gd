extends Node

# Se encarga de manejar el inventario de manera global sin importar la escena
# Es un singleton

@export var inventario: Inventory = preload("res://Resource/Inventario.tres")
const max_Slots = 6

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_item(item: Inventory_item) -> bool :
	if inventario.items.size() >= 6 :
		print("Inventario lleno")
		return false
	else:
		print("Objeto añadido al inventario")
		inventario.items.append(item)
		notify_ui()
		return true

func notify_ui():
	get_tree().call_group("inventory_ui", "update_slots")
