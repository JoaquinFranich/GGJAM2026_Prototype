extends Button

## Script reutilizable para el botón "Volver"
##
## USO:
## 1. Crea un nodo Button en tu escena
## 2. Asigna este script al Button
## 3. Al hacer clic, llama automáticamente a SceneManager.on_back_clicked()
##
## El botón se deshabilita automáticamente si no hay escena anterior

var hand_cursor = preload("res://Assets/Images/HandCursor.png")

func _ready():
	# Deshabilitar el focus visual para que no se muestre el recuadro al hacer clic
	focus_mode = Control.FOCUS_NONE
	
	# Conectar la señal pressed si no está conectada
	if not pressed.is_connected(_on_pressed):
		pressed.connect(_on_pressed)
	
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
	Input.set_custom_mouse_cursor(hand_cursor)

## Restaura el cursor al salir
func _on_mouse_exited():
	Input.set_custom_mouse_cursor(null)
