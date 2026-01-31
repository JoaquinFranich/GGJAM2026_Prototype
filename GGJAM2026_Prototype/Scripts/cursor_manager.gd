class_name CursorManager
extends Node

## Singleton/Static helper para gestionar el cursor del juego
## Carga, cachea y aplica cursores personalizados con soporte de escalado

const HAND_CURSOR_PATH = "res://Assets/Images/Cursor/puntero_001.png"
const CLICK_CURSOR_PATH = "res://Assets/Images/Cursor/puntero_002.png"
const CURSOR_SCALE = Vector2(0.4, 0.4)

static var _hand_cursor_texture: Texture2D = null
static var _click_cursor_texture: Texture2D = null

## Establece el cursor de "Mano" (interactuable)
static func set_hand_cursor():
	if _hand_cursor_texture == null:
		_hand_cursor_texture = _load_and_process_cursor(HAND_CURSOR_PATH)
	
	if _hand_cursor_texture:
		Input.set_custom_mouse_cursor(_hand_cursor_texture)

## Establece el cursor de "Clic" (presionado)
static func set_click_cursor():
	if _click_cursor_texture == null:
		_click_cursor_texture = _load_and_process_cursor(CLICK_CURSOR_PATH)
	
	if _click_cursor_texture:
		Input.set_custom_mouse_cursor(_click_cursor_texture)

## Restaura el cursor por defecto del sistema
static func reset_cursor():
	Input.set_custom_mouse_cursor(null)

## Carga y procesa la imagen del cursor (genérico)
static func _load_and_process_cursor(path: String) -> Texture2D:
	if not ResourceLoader.exists(path):
		push_error("CursorManager: No se encontró la imagen del cursor en " + path)
		return null

	var texture_resource = load(path)
	if texture_resource:
		var image: Image = texture_resource.get_image()
		
		# Calcular nuevo tamaño
		var original_size = image.get_size()
		var new_width = int(original_size.x * CURSOR_SCALE.x)
		var new_height = int(original_size.y * CURSOR_SCALE.y)
		
		# Redimensionar
		image.resize(new_width, new_height, Image.INTERPOLATE_BILINEAR)
		
		# Crear textura desde la imagen modificada
		return ImageTexture.create_from_image(image)
	return null
