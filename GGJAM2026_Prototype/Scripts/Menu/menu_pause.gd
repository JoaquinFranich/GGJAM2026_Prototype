extends Panel
@onready var menu_pause: Panel = $"."
@onready var menu_options: Panel = $"../menu_Options"
@onready var audio_stream_player: AudioStreamPlayer = $"../AudioStreamPlayer"

# Menu del pausa al presionar la tecla "Esc" y con un boton para regresar al menu de inicio

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	menu_options.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_button_play_pressed() -> void:
	audio_stream_player.play()
	menu_pause.visible = false
	pass # Replace with function body.


func _on_button_options_pressed() -> void:
	audio_stream_player.play()
	menu_options.visible = true
	pass # Replace with function body.


func _on_button_exit_pressed() -> void:
	audio_stream_player.play()
	get_tree().change_scene_to_file("res://Scenes/Menu Scenes/menu.tscn")
	pass # Replace with function body.
