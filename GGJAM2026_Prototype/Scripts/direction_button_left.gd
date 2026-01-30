extends Button

## Script para el botón de dirección izquierda (Volver)
## Usa el mismo comportamiento que back_button pero específico para UI_manager

var hand_cursor = preload("res://Assets/Images/HandCursor.png")

func _ready():
	# Deshabilitar el focus visual para que no se muestre el recuadro al hacer clic
	focus_mode = Control.FOCUS_NONE
	
	# Conectar señales de hover para cambio de cursor
	if not mouse_entered.is_connected(_on_mouse_entered):
		mouse_entered.connect(_on_mouse_entered)
	if not mouse_exited.is_connected(_on_mouse_exited):
		mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered():
	Input.set_custom_mouse_cursor(hand_cursor)

func _on_mouse_exited():
	Input.set_custom_mouse_cursor(null)
