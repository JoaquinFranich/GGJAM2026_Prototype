extends Control
#@onready var hud_inventory: Panel = $inventory_HUD
#@onready var inventory_hud: Panel = $inventory_HUD/Inventory
@onready var menu_pause: Panel = $menu_Pause
@onready var music_volume: HSlider = $menu_Options/container_Options/music_Volume
@onready var sfx_volume: HSlider = $menu_Options/container_Options/sfx_Volume
@onready var checkbox_fullscreen: CheckBox = $menu_Options/container_Options/checkbox_Fullscreen
@onready var ui: CanvasLayer = $".."
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


@onready var inventario: Inventory = preload("res://Resource/inventory.tres")
#@onready var slots: Array = $inventory_HUD/Inventory/grid_Inventory.get_children()

# SCRIPT DEL HUD Incluye la interfaz de usuario del inventario, menu de pausa y menu de opciones
#Ademas en esta se estable los valores globales del inventario, volumen y fullscreen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("inventory_ui")
	#update_slots()
	music_volume.value = Settings.music_Volume
	sfx_volume.value = Settings.sfx_Volume
	checkbox_fullscreen.button_pressed = Settings.is_Fullscreen
	#hud_inventory.visible = true
	#inventory_hud.visible = false
	menu_pause.visible = false
	pass # Replace with function body.

#func update_slots():
	#for i in range(min(inventario.items.size(), slots.size())):
		#slots[i].update(inventario.items[i])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Abrir_menu_de_pausa") == true:
		ui.visible = true
		menu_pause.visible = true
	pass


#func _on_close_inventory_button_pressed() -> void:
	#inventory_hud.visible = false
	#pass # Replace with function body.
#
#
#func _on_open_inventory_button_pressed() -> void:
	#inventory_hud.visible = true
	#pass # Replace with function body.
