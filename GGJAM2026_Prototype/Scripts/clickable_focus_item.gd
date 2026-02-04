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
func _on_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT:
			if mouse_event.pressed:
				CursorManager.set_click_cursor()
				
				# 1. Verificar si tenemos una meta-data de destino (puesta por UI_manager)
				var target_scene = get_meta("target_scene", "")
				var dialogue_text = get_meta("dialogue", "")
				
				# 2. Si hay destino, ir allí DIRECTAMENTE
				if target_scene != "" and ResourceLoader.exists(target_scene):
					SceneManager.change_scene(target_scene)
					# Opcional: emitir señal local si es necesario
				
				# 2b. Si hay diálogo, mostrarlo
				elif dialogue_text != "":
					DialogueManager.show_dialogue([dialogue_text])
				
				# 3. Si NO hay destino, usar comportamiento por defecto
				else:
					SceneManager.on_focusitem_clicked()
			else:
				# Al soltar (pressed = false), volver a mano
				CursorManager.set_hand_cursor()

## Cambia el cursor a mano al pasar el mouse
func _on_mouse_entered():
	CursorManager.set_hand_cursor()

## Restaura el cursor al salir
func _on_mouse_exited():
	CursorManager.reset_cursor()
