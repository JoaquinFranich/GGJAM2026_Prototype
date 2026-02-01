extends Area2D

## Script para objetos recolectables en el mundo
## Al hacer clic, intenta añadirse al inventario a través de UI_manager

@export var item_data: InventoryItem

var _is_hovering = false

func _ready():
	# Asegurarse de ser detectable
	input_pickable = true
	
	# Auto-asignar textura si hay item_data y tenemos un Sprite hijo
	if item_data and item_data.texture:
		var sprite = get_node_or_null("Sprite2D")
		if sprite and sprite.texture == null:
			sprite.texture = item_data.texture
	
	# Debug y Tracking de Hover
	if not mouse_entered.is_connected(_on_mouse_entered_logic):
		mouse_entered.connect(_on_mouse_entered_logic)
	if not mouse_exited.is_connected(_on_mouse_exited_logic):
		mouse_exited.connect(_on_mouse_exited_logic)

func _on_mouse_entered_logic():
	_is_hovering = true
	# CursorManager.set_hand_cursor() # Opcional: Feedback visual

func _on_mouse_exited_logic():
	_is_hovering = false
	# CursorManager.reset_cursor() # Opcional

func _unhandled_input(event):
	if _is_hovering and event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			print("PickupObject (Fallback): Click detectado por _unhandled_input")
			_collect_item()
			get_viewport().set_input_as_handled() # Evitar doble click si _input_event reviviera

func _on_input_event(_viewport, event, _shape_idx):
	print("PickupObject: Evento recibido: ", event.as_text(), " | Clase: ", event.get_class())
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			print("PickupObject: Click detectado en ", name)
			_collect_item()

func _collect_item():
	print("PickupObject: Intentando recolectar ", name)
	if not item_data:
		push_warning("PickupObject: No hay item_data asignado en " + name)
		return
		
	# Intentar registrar en UI_manager
	if UI_manager and UI_manager.has_method("register_item"):
		var success = UI_manager.register_item(item_data)
		print("PickupObject: Resultado de recolección: ", success)
		if success:
			# Efecto visual/sonoro podría ir aquí
			queue_free()
	else:
		push_error("PickupObject: UI_manager no encontrado o no tiene método register_item")
