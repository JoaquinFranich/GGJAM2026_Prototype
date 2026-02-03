extends Area2D
class_name PlaceableZone

## Zona donde se puede colocar un item específico
## Si el jugador hace clic con el item correcto seleccionado, se activa el objeto

# Signal that is emitted when an item is successfully placed
signal item_placed

@export var required_item_name: String = ""
@export var placed_node: Node2D # El nodo que se hará visible (ej: La llave/Recompensa)
@export var placed_node_start_visible: bool = false
@export var node_to_hide: Node2D # El nodo que desaparecerá (ej: La paloma)
@export var node_to_hide_start_visible:  = true

var _is_hovering = false
var abrir_reja = false

func _ready():
	# El nodo recompensa empieza oculto
	if placed_node:
		placed_node.visible = placed_node_start_visible
	
	# El nodo a ocultar empieza visible (por defecto en la escena)
	if node_to_hide:
		node_to_hide.visible = node_to_hide_start_visible
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	input_event.connect(_on_input_event)

func _on_mouse_entered():
	_is_hovering = true
	# Feedback visual si traemos un item
	if UI_manager.get_selected_item():
		CursorManager.set_hover_item_cursor()

func _on_mouse_exited():
	_is_hovering = false
	CursorManager.reset_cursor()

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			get_viewport().set_input_as_handled()
			_try_place()

func _try_place():
	if UI_manager.try_place_item(required_item_name):
		# Éxito!
		if placed_node:
			placed_node.visible = true
			print("PlaceableZone: Recompensa mostrada.")
			
		if node_to_hide:
			node_to_hide.visible = false
			print("PlaceableZone: Obstáculo ocultado.")
		
		# Desactivar esta zona para que no se pueda usar de nuevo
		input_pickable = false
		collision_layer = 0
		collision_mask = 0
		
		item_placed.emit()
		abrir_reja = true
		print("PlaceableZone: Item colocado con éxito.")
