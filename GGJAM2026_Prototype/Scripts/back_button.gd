extends Button

## 
## USO:
## 1. Asigna este script al nodo Button en tu escena
## 2. Asigna este script al Button
## 3. Al hacer clic, llama automáticamente a SceneManager.on_back_clicked()
##
## El botón se deshabilita automáticamente si no hay escena anterior


func _ready():
	# Deshabilitar el focus visual para que no se muestre el recuadro al hacer clic
	focus_mode = Control.FOCUS_NONE
	
	# Conectar la señal pressed si no está conectada
	if not pressed.is_connected(_on_pressed):
		pressed.connect(_on_pressed)
	
	# Conectar señales para feedback visual del cursor
	if not button_down.is_connected(_on_button_down):
		button_down.connect(_on_button_down)
	if not button_up.is_connected(_on_button_up):
		button_up.connect(_on_button_up)
	
	# Actualizar estado del botón (habilitado/deshabilitado)
	_update_button_state()

func _on_pressed():
	# Asegurar que el botón no tenga focus después del clic
	release_focus()
	SceneManager.on_back_clicked()

## Actualiza si el botón debe estar habilitado o no
func _update_button_state():
	disabled = not SceneManager.can_go_back()

## Llamar esto si necesitas actualizar el estado manualmente
func refresh():
	_update_button_state()

## Cambia el cursor a mano al pasar el mouse
func _on_mouse_entered():
	CursorManager.set_hand_cursor()

## Restaura el cursor al salir
func _on_mouse_exited():
	CursorManager.reset_cursor()

func _on_button_down():
	CursorManager.set_click_cursor()

func _on_button_up():
	# Al soltar, volvemos al cursor de mano (porque seguimos sobre el botón)
	CursorManager.set_hand_cursor()
