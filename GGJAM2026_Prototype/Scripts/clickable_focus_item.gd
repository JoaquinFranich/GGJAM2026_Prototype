extends Node2D

## Script reutilizable para FocusItem (o cualquier objeto clickeable que avance de escena)
## 
## USO:
## 1. Asigna este script al nodo FocusItem (Sprite2D con Area2D hijo)
## 2. Asegúrate de que el Area2D tenga un CollisionShape2D configurado
## 3. Al hacer clic, llama automáticamente a SceneManager.on_focusitem_clicked()
##
## CURSOR:
## - Al pasar el mouse sobre el área, cambia a cursor de mano
## - Al salir, vuelve al cursor normal

var hand_cursor = preload("res://Assets/Images/HandCursor.png")

func _ready():
	# Buscar el Area2D hijo
	var area = _find_area2d()
	if area:
		# Conectar señales
		if not area.input_event.is_connected(_on_area_input_event):
			area.input_event.connect(_on_area_input_event)
		if not area.mouse_entered.is_connected(_on_mouse_entered):
			area.mouse_entered.connect(_on_mouse_entered)
		if not area.mouse_exited.is_connected(_on_mouse_exited):
			area.mouse_exited.connect(_on_mouse_exited)
	else:
		push_warning("ClickableFocusItem: No se encontró un Area2D hijo en " + name)

## Busca el Area2D en los hijos del nodo
func _find_area2d() -> Area2D:
	for child in get_children():
		if child is Area2D:
			return child
	return null

## Maneja el clic en el área
func _on_area_input_event(viewport: Node, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_LEFT:
			# Delegar toda la lógica de navegación al SceneManager
			SceneManager.on_focusitem_clicked()

## Cambia el cursor a mano al pasar el mouse
func _on_mouse_entered():
	Input.set_custom_mouse_cursor(hand_cursor)

## Restaura el cursor al salir
func _on_mouse_exited():
	Input.set_custom_mouse_cursor(null)
