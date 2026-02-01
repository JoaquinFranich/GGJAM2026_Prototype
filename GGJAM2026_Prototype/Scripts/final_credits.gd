extends "res://Scripts/scene_ui_config.gd"

## Script para Créditos Finales (F8)
## Reproduce el video y luego vuelve al menú (o termina).

func configure_ui():
	# Ocultar toda la UI estándar para ver el video limpio
	if UI_manager:
		UI_manager.visible = false
	
	_setup_video()

func _setup_video():
	print("F8: Iniciando Créditos...")
	
	# Intentar usar el nodo manual si existe
	var video_player = get_node_or_null("VideoStreamPlayer")
	
	if not video_player:
		print("F8: Creando reproductor por código...")
		video_player = VideoStreamPlayer.new()
		video_player.name = "CreditsPlayer"
		add_child(video_player)
		# Cargar video
		var video_stream = load("res://Assets/Video/creditos finales video recortado FINAL FINAL.ogv")
		if video_stream:
			video_player.stream = video_stream
		else:
			push_error("F8: No se pudo cargar el video.")
			return
	
	# FORZAR TAMAÑO Y POSICIÓN (Hardcoded para asegurar que se vea)
	video_player.anchors_preset = Control.PRESET_TOP_LEFT
	video_player.position = Vector2.ZERO
	video_player.size = Vector2(1920, 1080)
	video_player.expand = true
	video_player.autoplay = true
	video_player.z_index = 100 # Asegurar que esté por encima de todo
	
	# Ocultar el fondo si existe para evitar conflictos de dibujo
	var bg = get_node_or_null("Background")
	if bg:
		bg.visible = false
	
	# Asegurar que esté por encima del fondo (en árbol)
	move_child(video_player, get_child_count() - 1)
	
	# Conectar señal de fin si no está conectada
	if not video_player.finished.is_connected(_on_credits_finished):
		video_player.finished.connect(_on_credits_finished)
	
	# Esperar un frame porsiacaso
	await get_tree().process_frame
	
	print("F8: Reproduciendo video...")
	video_player.play()
	
	# AUDIO AMBIENTE EXTRA
	var audio_player = AudioStreamPlayer.new()
	var sfx = load("res://Assets/Audio/corrupcion de la mascara.wav")
	if sfx:
		audio_player.stream = sfx
		add_child(audio_player)
		audio_player.play()
	

func _on_credits_finished():
	print("F8: Créditos terminados. Volviendo al menú.")
	SceneManager.change_scene("res://Scenes/Menu Scenes/menu.tscn")
