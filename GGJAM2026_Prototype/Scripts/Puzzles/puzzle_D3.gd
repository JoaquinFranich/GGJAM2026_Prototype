extends "res://Scripts/scene_ui_config.gd"

# Script específico para escena D3 (Paloma)
# Se encarga de reproducir el sonido cuando se usa el objeto Pipas

func _ready():
	super._ready() # Llamada importante
	
	# Buscar la zona de colocación (Area2D)
	var area = get_node_or_null("Area2D")
	if area:
		if not area.item_placed.is_connected(_on_pipas_placed):
			area.item_placed.connect(_on_pipas_placed)
	else:
		push_warning("PuzzleD3: No se encontró Area2D")

func _on_pipas_placed():
	# Reproducir sonido de aleteo
	# Usamos play_sfx porque es una acción puntual (aunque el archivo se llame loop)
	AudioManager.play_sfx("aleteo_loop", 1.0, 3.0) # Limitamos a 3s por si acaso es muy largo
