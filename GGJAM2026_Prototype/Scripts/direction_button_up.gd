extends Button

## Script para el botón de dirección arriba (Mirar arriba)
## Cambia a escena del techo (solo en escenas específicas)

# Escena destino cuando se hace clic (debe ser configurada por la escena)
var target_scene: String = ""

func _ready():
	# Deshabilitar el focus visual para que no se muestre el recuadro al hacer clic
	focus_mode = Control.FOCUS_NONE
	
	# Conectar señales de hover para cambio de cursor
	if not mouse_entered.is_connected(_on_mouse_entered):
		mouse_entered.connect(_on_mouse_entered)
	if not mouse_exited.is_connected(_on_mouse_exited):
		mouse_exited.connect(_on_mouse_exited)
	
	# Conectar señal pressed
	if not pressed.is_connected(_on_pressed):
		pressed.connect(_on_pressed)
	
	if not button_down.is_connected(_on_button_down):
		button_down.connect(_on_button_down)
	if not button_up.is_connected(_on_button_up):
		button_up.connect(_on_button_up)

func _on_pressed():
	if target_scene != "" and ResourceLoader.exists(target_scene):
		SceneManager.change_scene(target_scene)
	else:
		push_warning("DirectionButtonUp: target_scene no configurada o no existe")

func _on_mouse_entered():
	CursorManager.set_hand_cursor()

func _on_mouse_exited():
	CursorManager.reset_cursor()

func _on_button_down():
	CursorManager.set_click_cursor()

func _on_button_up():
	CursorManager.set_hand_cursor()
