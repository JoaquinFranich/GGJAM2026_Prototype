extends Button

@onready var slot_object: Sprite2D = $CenterContainer/Panel/slot_Object

# Estos son los slots del inventario, maneja si se pueden ver
# Gracias a la data recibidad del objeto puede establecer la imagen al inventario

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func update(item: Inventory_item):
	if !item:
		slot_object.visible = false
	else:
		slot_object.visible = true
		slot_object.texture = item.texture
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
