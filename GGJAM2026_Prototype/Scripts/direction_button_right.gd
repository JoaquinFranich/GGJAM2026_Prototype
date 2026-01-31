extends Button

## Script para el botón de dirección derecha (Avanzar)
## Avanza a la siguiente subescena

# Escena destino cuando se hace clic (opcional, si se define sobrescribe el comportamiento por defecto)
var target_scene: String = ""

func _ready():
	# Deshabilitar el focus visual para que no se muestre el recuadro al hacer clic
	focus_mode = Control.FOCUS_NONE
	
	# Conectar señales de hover para cambio de cursor
	if not mouse_entered.is_connected(_on_mouse_entered):
		mouse_entered.connect(_on_mouse_entered)
	if not mouse_exited.is_connected(_on_mouse_exited):
		mouse_exited.connect(_on_mouse_exited)
	
	if not button_down.is_connected(_on_button_down):
		button_down.connect(_on_button_down)
	if not button_up.is_connected(_on_button_up):
		button_up.connect(_on_button_up)

func _on_mouse_entered():
	CursorManager.set_hand_cursor()

func _on_mouse_exited():
	CursorManager.reset_cursor()

func _on_button_down():
	CursorManager.set_click_cursor()

func _on_button_up():
	CursorManager.set_hand_cursor()
