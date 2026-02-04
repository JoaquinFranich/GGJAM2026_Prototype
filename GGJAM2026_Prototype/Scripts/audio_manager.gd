extends Node

## Singleton para gestionar Audio y Música
## Autoload: AudioManager

# Diccionario de sonidos disponibles
# Mapea un nombre clave (String) a la ruta del archivo (String)
var sound_library = {
	# UI
	"ui_hover": "res://Assets/Audio/moverse entre opciones.wav",
	"ui_start": "res://Assets/Audio/boton inicio.wav",
	"inv_open": "res://Assets/Audio/inventario abre.wav",
	"inv_close": "res://Assets/Audio/inventario cierra.wav",
	"item_found": "res://Assets/Audio/encontrar item.wav",
	"puzzle_solved": "res://Assets/Audio/acertijo resuelto.wav",
	
	# Música / Loops
	"musica_menu": "res://Assets/Audio/musica de menu de inicio.wav",
	"amb_dia": "res://Assets/Audio/ambiente dia.wav",
	"amb_mascara": "res://Assets/Audio/ambiente mascara.wav",
	"amb_lluvia": "res://Assets/Audio/lluvia noche ambiente mascara.wav",
	"aleteo_loop": "res://Assets/Audio/aleteo loop.wav",
	
	# SFX One-Shots
	"pasos": "res://Assets/Audio/pasos.wav",
	"cerradura": "res://Assets/Audio/abrir la cerradura.wav",
	"monolito": "res://Assets/Audio/monolito girando.wav",
	"plot_twist": "res://Assets/Audio/plot twist.wav",
	"punalada": "res://Assets/Audio/puñalada.wav",
	"totem": "res://Assets/Audio/totem se activa a lo lejos.wav",
	"paloma": "res://Assets/Audio/paloma.wav",
	"corrupcion": "res://Assets/Audio/corrupcion de la mascara.wav"
}

# Reproductores
var _music_player: AudioStreamPlayer
var _sfx_players: Array[AudioStreamPlayer] = []
var _sfx_pool_size: int = 8
var _current_music_key: String = ""

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS # El audio no debe pausarse si el juego se pausa (opcional)
	
	# Setup Música
	_music_player = AudioStreamPlayer.new()
	_music_player.bus = "Music" # Usamos el bus específico para que funcionen los sliders
	_music_player.name = "MusicPlayer"
	add_child(_music_player)
	
	# Setup SFX Pool
	for i in range(_sfx_pool_size):
		var p = AudioStreamPlayer.new()
		p.bus = "SFX" # Usamos el bus específico para que funcionen los sliders
		p.name = "SFXPlayer_" + str(i)
		add_child(p)
		_sfx_players.append(p)

## Reproduce un efecto de sonido una vez
## Reproduce un efecto de sonido una vez, con opción de duración máxima
func play_sfx(sfx_name: String, pitch_scale: float = 1.0, duration: float = 0.0) -> AudioStreamPlayer:
	if not sound_library.has(sfx_name):
		push_warning("AudioManager: Sonido no encontrado -> " + sfx_name)
		return null
	
	var stream = load(sound_library[sfx_name])
	var player = _get_available_sfx_player()
	
	if player:
		player.stream = stream
		player.pitch_scale = pitch_scale
		player.play()
		
		if duration > 0.0:
			get_tree().create_timer(duration).timeout.connect(player.stop, CONNECT_ONE_SHOT)
		
		return player
	return null

## Reproduce música con crossfade opcional
func play_music(music_name: String, fade_duration: float = 1.0):
	if _current_music_key == music_name:
		return # Ya está sonando
		
	if not sound_library.has(music_name):
		push_warning("AudioManager: Música no encontrada -> " + music_name)
		return
		
	var new_stream = load(sound_library[music_name])
	
	# Si ya hay música sonando, hacemos fade out
	if _music_player.playing:
		var tween = create_tween()
		tween.tween_property(_music_player, "volume_db", -80.0, fade_duration)
		await tween.finished
		_music_player.stop()
		_music_player.volume_db = 0.0 # Reset volumen
	
	_music_player.stream = new_stream
	_music_player.play()
	_current_music_key = music_name
	
	# Fade in (opcional, por ahora directo)
	# Podríamos iniciar en -80 y subir a 0
	
func stop_music(fade_duration: float = 1.0):
	if _music_player.playing:
		var tween = create_tween()
		tween.tween_property(_music_player, "volume_db", -80.0, fade_duration)
		await tween.finished
		_music_player.stop()
		_music_player.volume_db = 0.0
	_current_music_key = ""

func _get_available_sfx_player() -> AudioStreamPlayer:
	for p in _sfx_players:
		if not p.playing:
			return p
	# Si todos están ocupados, usar el más antiguo (o simplemente el primero en la lista para reciclar)
	# Una estrategia simple es devolver el primero para que interrumpa, 
	# o devolver null para no saturar. Usaremos el primero como fallback.
	return _sfx_players[0]
