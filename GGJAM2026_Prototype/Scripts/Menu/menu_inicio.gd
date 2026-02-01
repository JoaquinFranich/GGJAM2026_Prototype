extends Control

@onready var menu_options: Panel = $menu_Options
@onready var music_volume: HSlider = $menu_Options/container_Options/music_Volume
@onready var sfx_volume: HSlider = $menu_Options/container_Options/sfx_Volume
@onready var checkbox_fullscreen: CheckBox = $menu_Options/container_Options/checkbox_Fullscreen
@onready var color_rect: ColorRect = $CanvasLayer/ColorRect
@onready var music_menu: AudioStreamPlayer = $Music_menu

# Menu de inicio que cuenta con el menud de opciones, iniciar el juego o salir de este

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SceneManager.activo = false
	DialogueManager.activo = false
	UI_manager.activo = false
	UI_manager.visible = false
	music_menu.play()
	color_rect.visible = true
	color_rect.modulate.a = 1.5
	fade_out()
	music_volume.value = Settings.music_Volume
	sfx_volume.value = Settings.sfx_Volume
	checkbox_fullscreen.button_pressed = Settings.is_Fullscreen
	menu_options.visible = false
	pass # Replace with function body.

func fade_out():
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 0.0, 2.5)
	tween.finished.connect(_on_fade_finished)

func fade_in():
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 1.5, 2.5)
	tween.finished.connect(_on_fade_finished)

func _on_fade_finished():
	color_rect.visible = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_play_pressed() -> void:
	$SFX_button.play()
	await get_tree().create_timer(0.5).timeout
	color_rect.visible = true
	color_rect.modulate.a = 0.0
	fade_in()
	await get_tree().create_timer(2.5).timeout
	SceneManager.activo = true
	DialogueManager.activo = true
	UI_manager.activo = true
	UI_manager.visible = true
	get_tree().change_scene_to_file("res://Scenes/Main Scenes/test_node_00.tscn")
	pass # Replace with function body.


func _on_button_options_pressed() -> void:
	$SFX_button.play()
	menu_options.visible = true
	pass # Replace with function body.


func _on_button_exit_pressed() -> void:
	$SFX_button.play()
	get_tree().quit()
	pass # Replace with function body.


func _on_music_menu_finished() -> void:
	music_menu.play()
	pass # Replace with function body.
