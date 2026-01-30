extends Node

## Singleton para gestionar transiciones entre escenas con efectos de fade
## Uso: SceneManager.change_scene("res://path/to/scene.tscn")

signal transition_started
signal transition_completed

var fade_duration: float = 0.5
var fade_color: Color = Color.BLACK

# Referencia al nodo de overlay para el fade
var fade_overlay: ColorRect

# Escena actual (ruta). Se actualiza en cada change_scene.
var current_scene: String = ""

# Escena a la que lleva "Volver" global. Por defecto la escena inicial del proyecto.
var volver_target: String = "res://Scenes/Main Scenes/test_node_00.tscn"

# =============================================================================
# SISTEMA DE NAVEGACIÓN CENTRALIZADO
# =============================================================================

# Escenas principales en orden (A, B, C, D, E, F)
# Modifica este array con las rutas reales de tus escenas principales
var main_scenes: Array[String] = [
	"res://Scenes/Main Scenes/test_node_00.tscn",      # 00 (escena principal 1)
	"res://Scenes/Main Scenes/test_node_A.tscn",      # A (descomentar y ajustar cuando existan)
	"res://Scenes/Main Scenes/test_node_B.tscn",      # B
	"res://Scenes/Main Scenes/test_node_C.tscn",      # C
	# "res://Scenes/scene_E.tscn",      # E
	# "res://Scenes/scene_F.tscn",      # F
]

# Subescenas por cada escena principal
# Clave: ruta de la escena principal
# Valor: array ordenado de sus subescenas [A1, A2, A3] o [B1, B2, B3], etc.
var sub_scenes: Dictionary = {
	"res://Scenes/Main Scenes/test_node_A.tscn": [
		"res://Scenes/Sub Scenes/test_node_A1.tscn",       # A1
		"res://Scenes/Sub Scenes/test_node_A2.tscn",     # A2 (descomentar cuando exista)
		"res://Scenes/Sub Scenes/test_node_A3.tscn",     # A3
		"res://Scenes/Sub Scenes/test_node_A4.tscn"
	],
	 "res://Scenes/Main Scenes/test_node_B.tscn": [
		"res://Scenes/Sub Scenes/test_node_B1.tscn",
		"res://Scenes/Sub Scenes/test_node_B2.tscn",
	#     "res://Scenes/B3.tscn",
	 ],
}

# Inventario simple: lista de IDs de ítems recogidos
# Sirve para saber si, al volver, ir directo a la main scene
var inventory: Array[String] = []

# =============================================================================

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

	# Registrar la escena inicial como current_scene (cuando el árbol ya esté listo)
	call_deferred("_set_initial_current_scene")

func _set_initial_current_scene():
	var root = get_tree().current_scene
	if root and root.scene_file_path:
		current_scene = root.scene_file_path

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

	# Actualizar escena actual
	current_scene = scene_path
	
	# Esperar un frame para que la nueva escena se cargue
	await get_tree().process_frame
	
	# Fade in
	await fade_in()
	
	transition_completed.emit()

## Indica si se puede usar "Volver" (no estamos ya en volver_target)
func can_volver() -> bool:
	return volver_target != "" and current_scene != volver_target

## Cambia a la escena configurada como "Volver" (volver_target)
## No hace nada si ya estamos ahí o si volver_target está vacío.
func volver() -> bool:
	if not can_volver():
		return false
	change_scene(volver_target)
	return true

## Define la escena a la que lleva "Volver"
func set_volver_target(path: String) -> void:
	volver_target = path

# =============================================================================
# NAVEGACIÓN POR FOCUSITEM Y BACK
# =============================================================================

## Llamar cuando el jugador hace clic en FocusItem
## Avanza a la siguiente escena/subescena según current_scene
func on_focusitem_clicked() -> bool:
	var next = _get_next_scene()
	if next == "":
		push_warning("SceneManager: No hay escena siguiente desde " + current_scene)
		return false
	change_scene(next)
	return true

## Llamar cuando el jugador hace clic en el botón Volver
## Retrocede a la escena anterior en la cadena
## Si el ítem de la cadena está en inventario, vuelve directo a la main scene
func on_back_clicked() -> bool:
	var back = _get_back_scene()
	if back == "":
		push_warning("SceneManager: No hay escena anterior desde " + current_scene)
		return false
	change_scene(back)
	return true

## Indica si hay una escena siguiente disponible (para habilitar/deshabilitar FocusItem)
func can_advance() -> bool:
	return _get_next_scene() != ""

## Indica si hay una escena anterior disponible (para habilitar/deshabilitar botón Volver)
func can_go_back() -> bool:
	return _get_back_scene() != ""

## Obtiene la siguiente escena disponible (método público)
func get_next_scene() -> String:
	return _get_next_scene()

## Obtiene la escena anterior disponible (método público)
func get_back_scene() -> String:
	return _get_back_scene()

# =============================================================================
# LÓGICA INTERNA DE NAVEGACIÓN
# =============================================================================

## Obtiene la siguiente escena desde current_scene
func _get_next_scene() -> String:
	# 1. ¿Estamos en una main scene?
	if current_scene in main_scenes:
		# Ir a la primera subescena de esta main (si existe)
		if sub_scenes.has(current_scene):
			var subs = sub_scenes[current_scene] as Array
			if subs.size() > 0:
				return subs[0]
		# Si no hay subescenas, ir a la siguiente main scene
		var main_idx = main_scenes.find(current_scene)
		if main_idx >= 0 and main_idx < main_scenes.size() - 1:
			return main_scenes[main_idx + 1]
		return ""
	
	# 2. ¿Estamos en una subescena?
	var parent_main = _get_parent_main_scene(current_scene)
	if parent_main != "":
		var subs = sub_scenes[parent_main] as Array
		var sub_idx = subs.find(current_scene)
		if sub_idx >= 0 and sub_idx < subs.size() - 1:
			# Hay más subescenas, avanzar a la siguiente
			return subs[sub_idx + 1]
		else:
			# Es la última subescena, no hay más (aquí se recogería el ítem)
			return ""
	
	return ""

## Obtiene la escena anterior desde current_scene
func _get_back_scene() -> String:
	# 1. ¿Estamos en una main scene?
	if current_scene in main_scenes:
		# Volver a la main scene anterior (si existe)
		var main_idx = main_scenes.find(current_scene)
		if main_idx > 0:
			return main_scenes[main_idx - 1]
		return ""
	
	# 2. ¿Estamos en una subescena?
	var parent_main = _get_parent_main_scene(current_scene)
	if parent_main != "":
		# Si el ítem de esta cadena está en inventario, volver directo a main
		if _has_item_for_chain(parent_main):
			return parent_main
		
		var subs = sub_scenes[parent_main] as Array
		var sub_idx = subs.find(current_scene)
		if sub_idx > 0:
			# Hay subescena anterior, volver a ella
			return subs[sub_idx - 1]
		else:
			# Es la primera subescena (A1), volver a main (A)
			return parent_main
	
	return ""

## Encuentra la main scene "padre" de una subescena
func _get_parent_main_scene(sub_scene: String) -> String:
	for main in sub_scenes.keys():
		var subs = sub_scenes[main] as Array
		if sub_scene in subs:
			return main
	return ""

# =============================================================================
# INVENTARIO SIMPLE
# =============================================================================

## Verifica si un ítem está en el inventario
func has_item(item_id: String) -> bool:
	return item_id in inventory

## Agrega un ítem al inventario
func add_item(item_id: String) -> void:
	if not has_item(item_id):
		inventory.append(item_id)
		print("SceneManager: Ítem agregado al inventario: " + item_id)

## Remueve un ítem del inventario
func remove_item(item_id: String) -> void:
	inventory.erase(item_id)

## Verifica si se recogió el ítem asociado a una cadena de subescenas
## Por defecto usa la ruta de la main scene como ID del ítem
## Puedes personalizar esta lógica según tu juego
func _has_item_for_chain(main_scene: String) -> bool:
	# Usa la ruta de la main scene como ID del ítem
	# Ejemplo: si recogiste el ítem de la cadena A, llamas add_item("res://Scenes/test_node.tscn")
	return has_item(main_scene)

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
