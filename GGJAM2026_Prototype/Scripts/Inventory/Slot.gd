extends Button

## Script para un Slot individual del inventario
## Se encarga de mostrar la imagen del item asignado

# Referencia al TextureRect hijo que mostrará el item
@onready var slot_image: TextureRect = $SlotImage

# Item actual en este slot
var _current_item: InventoryItem

func _ready():
	# Configuración visual automática para asegurar consistencia
	flat = true
	focus_mode = 0 # FOCUS_NONE
	
	# Asegurarse de que la imagen del slot esté configurada
	if not slot_image:
		slot_image = get_node_or_null("SlotImage")
	
	# Conexiones para interacción
	pressed.connect(_on_pressed)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

## Actualiza el slot con la información del item
func update_slot(item: InventoryItem):
	_current_item = item
	if not slot_image:
		return
		
	if !item:
		slot_image.visible = false
		slot_image.texture = null
		tooltip_text = ""
		disabled = true # Deshabilitar si está vacío
	else:
		slot_image.visible = true
		slot_image.texture = item.texture
		tooltip_text = item.name
		disabled = false

func _on_pressed():
	if _current_item:
		UI_manager.select_item(_current_item)

func _on_mouse_entered():
	if _current_item:
		CursorManager.set_hover_item_cursor()

func _on_mouse_exited():
	CursorManager.reset_cursor()
