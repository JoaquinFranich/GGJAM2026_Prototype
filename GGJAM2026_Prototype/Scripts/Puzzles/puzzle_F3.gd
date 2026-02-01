extends "res://Scripts/scene_ui_config.gd"

# Script específico para la escena F3 (Piedras Monolito)
# Hereda de scene_ui_config para mantener la funcionalidad básica de UI

var stones_placed_count: int = 0
const REQUIRED_STONES = 3

func _ready():
	super._ready() # Importante: Llama al _ready del padre
	
	# Buscar todas las zonas de colocación en la escena (Recursivo)
	var zones = _find_zones_recursive(self)
	print("F3: Zonas encontradas: ", zones.size())
			
	# Conectar señal
	for zone in zones:
		if not zone.item_placed.is_connected(_on_stone_placed):
			zone.item_placed.connect(_on_stone_placed)
			
	# CHEQUEO DE SEGURIDAD (FALLBACK)
	# Esperamos un poco más que el padre (scene_ui_config) para sobrescribir la UI
	await get_tree().process_frame
	await get_tree().process_frame
	_check_inventory_for_win()

func _check_inventory_for_win():
	# Si detectamos las 3 piedras en el inventario, habilitamos avanzar
	var inventory_items = UI_manager._inventory_data.items
	var found_1 = false
	var found_2 = false
	var found_3 = false
	
	print("F3 Fallback check. Items en inventario:")
	for item in inventory_items:
		if item:
			print("- ", item.name)
			if item.name == "piedra_puzzle_1": found_1 = true
			if item.name == "piedra_puzzle_2": found_2 = true
			if item.name == "piedra_puzzle_3": found_3 = true
		
	if found_1 and found_2 and found_3:
		print("F3 (Fallback): Piedras detectadas. Flecha UP activada.")
		var btn_up = UI_manager.get_direction_button("up")
		if btn_up:
			btn_up.visible = true
			if "target_scene" in btn_up:
				btn_up.target_scene = "res://Scenes/Sub Scenes/test_node_F4.tscn"
	else:
		print("F3 (Fallback): No se encontraron las 3 piedras requeridas.")

func _find_zones_recursive(node: Node) -> Array:
	var result = []
	for child in node.get_children():
		if child is PlaceableZone:
			result.append(child)
		# Buscar en los hijos de los hijos
		if child.get_child_count() > 0:
			result.append_array(_find_zones_recursive(child))
	return result

func _on_stone_placed():
	stones_placed_count += 1
	print("F3: Piedra colocada (", stones_placed_count, "/", REQUIRED_STONES, ")")
	
	if stones_placed_count >= REQUIRED_STONES:
		call_deferred("_finish_puzzle")

func _finish_puzzle():
	print("F3: ¡Puzzle completado! Avanzando a F4...")
	# Esperar un poco para que el jugador vea la última piedra
	await get_tree().create_timer(1.0).timeout
	SceneManager.change_scene("res://Scenes/Sub Scenes/test_node_F4.tscn")
