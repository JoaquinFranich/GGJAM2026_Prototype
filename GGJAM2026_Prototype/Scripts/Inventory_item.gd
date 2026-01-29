extends Resource

# Recurso para crear un item con un nombre e imagen para el inventario
# Esto no crea el objeto sino la data para el inventario

class_name Inventory_item

@export var name: String = ""
@export var texture: Texture2D
