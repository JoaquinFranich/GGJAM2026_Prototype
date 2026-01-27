extends Node

## Singleton para gestionar transiciones entre escenas con efectos de fade
## Uso: SceneManager.change_scene("res://path/to/scene.tscn")

signal transition_started
signal transition_completed

var fade_duration: float = 0.5
var fade_color: Color = Color.BLACK

# Referencia al nodo de overlay para el fade
var fade_overlay: ColorRect

func _ready():
	# Crear overlay para el fade
	fade_overlay = ColorRect.new()
	fade_overlay.color = fade_color
	fade_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fade_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	fade_overlay.visible = false
	add_child(fade_overlay)
	
	# Asegurar que el overlay esté en la capa más alta
	fade_overlay.z_index = 1000

## Cambia a una nueva escena con efecto de fade
## scene_path: Ruta de la escena destino (ej: "res://Scenes/nueva_escena.tscn")
func change_scene(scene_path: String):
	if not ResourceLoader.exists(scene_path):
		push_error("SceneManager: La escena no existe: " + scene_path)
		return
	
	transition_started.emit()
	
	# Fade out
	await fade_out()
	
	# Cambiar escena
	var error = get_tree().change_scene_to_file(scene_path)
	if error != OK:
		push_error("SceneManager: Error al cambiar de escena: " + str(error))
		return
	
	# Resetear el cursor al cambiar de escena
	Input.set_custom_mouse_cursor(null)
	
	# Esperar un frame para que la nueva escena se cargue
	await get_tree().process_frame
	
	# Fade in
	await fade_in()
	
	transition_completed.emit()

## Efecto de fade out (pantalla se oscurece)
func fade_out() -> Signal:
	fade_overlay.modulate.a = 0.0
	fade_overlay.visible = true
	
	var tween = create_tween()
	tween.tween_property(fade_overlay, "modulate:a", 1.0, fade_duration)
	
	await tween.finished
	return transition_completed

## Efecto de fade in (pantalla se aclara)
func fade_in() -> Signal:
	fade_overlay.modulate.a = 1.0
	
	var tween = create_tween()
	tween.tween_property(fade_overlay, "modulate:a", 0.0, fade_duration)
	
	await tween.finished
	fade_overlay.visible = false
	return transition_completed

## Cambiar la duración del fade
func set_fade_duration(duration: float):
	fade_duration = duration

## Cambiar el color del fade
func set_fade_color(color: Color):
	fade_color = color
	if fade_overlay:
		fade_overlay.color = color
