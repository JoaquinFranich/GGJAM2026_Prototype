extends "res://Scripts/scene_ui_config.gd"

# Script específico para escena D5 (Candado)
# Se encarga de reproducir el sonido cuando se usa la llave

func _ready():
	super._ready() # Llamada importante
	
	# Buscar la zona de colocación (Area2D)
	var area = get_node_or_null("Area2D")
	if area:
		if not area.item_placed.is_connected(_on_key_placed):
			area.item_placed.connect(_on_key_placed)
	else:
		push_warning("PuzzleD5: No se encontró Area2D")

func _on_key_placed():
	# Reproducir sonido de cerradura
	AudioManager.play_sfx("cerradura")
