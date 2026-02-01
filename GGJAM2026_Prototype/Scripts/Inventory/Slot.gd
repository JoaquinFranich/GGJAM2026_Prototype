extends Button

## Script para un Slot individual del inventario
## Se encarga de mostrar la imagen del item asignado

# Referencia al TextureRect hijo que mostrará el item
@onready var slot_image: TextureRect = $SlotImage

func _ready():
	# Configuración visual automática para asegurar consistencia
	flat = true
	focus_mode = 0 # FOCUS_NONE
	
	# Asegurarse de que la imagen del slot esté configurada
	if not slot_image:
		slot_image = get_node_or_null("SlotImage")

## Actualiza el slot con la información del item
func update_slot(item: InventoryItem):
	if not slot_image:
		return
		
	if !item:
		slot_image.visible = false
		slot_image.texture = null
		# Deshabilitar tooltip o interacción si está vacío
		tooltip_text = ""
	else:
		slot_image.visible = true
		slot_image.texture = item.texture
		tooltip_text = item.name
