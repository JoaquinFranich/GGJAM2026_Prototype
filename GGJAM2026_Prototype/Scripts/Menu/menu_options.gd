extends Panel
@onready var music_volume: HSlider = $container_Options/music_Volume
@onready var menu_options: Panel = $"."
@onready var music_value: Label = $container_Options/HBoxContainer/music_value
@onready var sfx_value: Label = $container_Options/HBoxContainer2/sfx_value
@onready var audio_stream_player: AudioStreamPlayer = $"../AudioStreamPlayer"

const DEFAULT_BUS_LAYOUT = preload("uid://bn037rd0xnmvl")

# Se maneja las opciones de config como el volumen y el fullscreen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_music_volume_value_changed(value: float) -> void:
	# audio_stream_player.play()
	AudioManager.play_sfx("ui_hover")
	var bus_Music_Index = AudioServer.get_bus_index("Music")
	var porcentaje = int(((value + 50.0) / 50.0) * 100.0)
	AudioServer.set_bus_volume_db(bus_Music_Index, value)
	Settings.music_Volume = value
	music_value.text = str(int(porcentaje))
	pass # Replace with function body.


func _on_sfx_volume_value_changed(value: float) -> void:
	# audio_stream_player.play()
	AudioManager.play_sfx("ui_hover")
	var bus_Music_Index = AudioServer.get_bus_index("SFX")
	var porcentaje = int(((value + 50.0) / 50.0) * 100.0)
	AudioServer.set_bus_volume_db(bus_Music_Index, value)
	Settings.sfx_Volume = value
	sfx_value.text = str(int(porcentaje))
	pass # Replace with function body.


func _on_checkbox_fullscreen_toggled(toggled_on: bool) -> void:
	# audio_stream_player.play()
	AudioManager.play_sfx("ui_hover")
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		Settings.is_Fullscreen = toggled_on
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		Settings.is_Fullscreen = toggled_on
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	# audio_stream_player.play()
	AudioManager.play_sfx("ui_hover")
	menu_options.visible = false
	pass # Replace with function body.
