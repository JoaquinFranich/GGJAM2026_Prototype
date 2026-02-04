extends "res://Scripts/scene_ui_config.gd"

@onready var video_player: VideoStreamPlayer = $VideoStreamPlayer

const CAMBIO_SEGUNDO = 16
const VELOCIDAD_LENTA = 0.4
const VELOCIDAD_NORMAL = 1.0
var cambio = false
var _audio_player: AudioStreamPlayer

func _ready():
	SceneManager.activo = false
	DialogueManager.activo = false
	UI_manager.activo = false
	UI_manager.visible = false
	await get_tree().process_frame
	video_player.speed_scale = VELOCIDAD_LENTA
	video_player.play()
	video_player.finished.connect(_on_video_finished)
	# Configurar audio en loop
	_audio_player = AudioStreamPlayer.new()
	var sfx = load("res://Assets/Audio/corrupcion de la mascara.wav")
	if sfx:
		_audio_player.stream = sfx
		add_child(_audio_player)
		_audio_player.play()
		# Conectar señal finished para hacer loop manual
		_audio_player.finished.connect(_on_audio_finished)

func _on_audio_finished():
	if video_player.is_playing():
		_audio_player.play()

func _process(delta):
	if video_player.is_playing() and not cambio:
		if video_player.stream_position >= CAMBIO_SEGUNDO:
			video_player.speed_scale = VELOCIDAD_NORMAL
			cambio = true

func _on_video_finished():
	if _audio_player:
		_audio_player.stop()
		
	print("F8: Créditos terminados. Volviendo al menú.")
	SceneManager.activo = true
	DialogueManager.activo = true
	UI_manager.activo = true
	UI_manager.visible = true
	SceneManager.change_scene("res://Scenes/Menu Scenes/menu.tscn")
