extends "res://Scripts/scene_ui_config.gd"

# Script específico para escena F5 (Monolito)
# Reproduce el sonido del monolito al entrar

func _ready():
	super._ready() # Importante
	
	# Reproducir sonido del monolito
	AudioManager.play_sfx("monolito", 1.0, 5.0) # Limitamos a 5s o lo que dure
