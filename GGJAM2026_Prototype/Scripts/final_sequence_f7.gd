extends "res://Scripts/scene_ui_config.gd"

## Script para la secuencia final de la Escena F7
## Maneja el parpadeo del background y la transición a créditos (F8)

@onready var bg2 = $Background2

var _flash_timer: Timer
var _total_timer: Timer
var _current_flash_interval = 0.5 # Inicio lento
var _min_flash_interval = 0.05 # Límite de velocidad

func _ready():
	# Configuración UI básica
	focus_item_position = Vector2.ZERO
	super._ready()
	
	# Cambiar retrato a policía asustado
	if UI_manager and UI_manager._character_portrait:
		UI_manager._character_portrait.texture = load("res://Assets/Images/Personaje/policia_asustado.png")
	
	# Reproducir audio de entrada tras el fade
	_play_plot_twist_sound()
	
	# Asegurar que BG2 empiece invisible
	if bg2: bg2.visible = false
	
	# Restaurar fade duration por si acaso (aunque venimos de un fade largo)
	# Esperamos a que termine el fade in de entrada
	await get_tree().create_timer(3.0).timeout
	SceneManager.set_fade_duration(0.5) # Restaurar a normal
	
	_start_sequence()

func _start_sequence():
	# Timer para el parpadeo
	_flash_timer = Timer.new()
	_flash_timer.one_shot = true
	_flash_timer.timeout.connect(_on_flash_timeout)
	add_child(_flash_timer)
	_flash_timer.start(_current_flash_interval)
	
	# Timer total de 5 segundos para cambiar de escena
	_total_timer = Timer.new()
	_total_timer.one_shot = true
	_total_timer.wait_time = 5.0
	_total_timer.timeout.connect(_on_sequence_finished)
	add_child(_total_timer)
	_total_timer.start()

func _on_flash_timeout():
	if bg2:
		bg2.visible = not bg2.visible
	
	# Acelerar el parpadeo ("in crescendo")
	_current_flash_interval *= 0.8
	if _current_flash_interval < _min_flash_interval:
		_current_flash_interval = _min_flash_interval
	
	# Siguiente flash
	_flash_timer.start(_current_flash_interval)

func _on_sequence_finished():
	# Detener parpadeo
	if _flash_timer: _flash_timer.stop()
	
	# Transición lenta a Créditos
	SceneManager.set_fade_duration(4.0)
	SceneManager.change_scene("res://Scenes/Sub Scenes/test_node_F8.tscn")

func _play_plot_twist_sound():
	var audio_player = AudioStreamPlayer.new()
	var sfx = load("res://Assets/Audio/plot twist.wav")
	if sfx:
		audio_player.stream = sfx
		add_child(audio_player)
		audio_player.play()
