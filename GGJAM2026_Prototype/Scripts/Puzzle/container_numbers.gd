extends HBoxContainer

@onready var inventory_hud: Panel = $"../../inventory_HUD"
@onready var mascara: Area2D = $"../../../../scene/Mascara"
@onready var candado_ui: Panel = $".."

#const maletin_Abierto = preload("uid://bk5nalx0m1fjr")
#const maletin_Vacio = preload("uid://cl0w63ooxtka0")


var candado_Success = [4,7,1]
var candado_output = [0,0,0]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#mascara.visible = false
	#inventory_hud.visible = true
	candado_ui.visible = true
	update_numbers()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#func _on_exit_pressed() -> void:
	#candado_ui.visible = false
	#inventory_hud.visible = true
	#pass # Replace with function body.


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("Click_izq"):
		candado_ui.visible = true
		if candado_output != candado_Success:
			get_tree().change_scene_to_file("res://Scenes/Sub Scenes/test_node_B4.tscn")
		#$"../../../../scene/Area2D/Sprite2D".texture = maletin_Abierto
		#mascara.visible = true
	else:
		print("Combinación incorrecta")
	pass # Replace with function body.


func update_numbers():
	$number_Panel1/number1.text = str(candado_output[0])
	$number_Panel2/number2.text = str(candado_output[1])
	$number_Panel3/number3.text = str(candado_output[2])

func _on_button_up_1_pressed() -> void:
	candado_output[0] = (candado_output[0] + 1) % 10 
	update_numbers()
	pass # Replace with function body.


func _on_button_down_1_pressed() -> void:
	candado_output[0] = (candado_output[0] - 1 + 10) % 10 
	update_numbers()
	pass # Replace with function body.



func _on_button_up_2_pressed() -> void:
	candado_output[1] = (candado_output[1] + 1) % 10 
	update_numbers()
	pass # Replace with function body.


func _on_button_down_2_pressed() -> void:
	candado_output[1] = (candado_output[1] - 1 + 10) % 10 
	update_numbers()
	pass # Replace with function body.

func _on_button_up_3_pressed() -> void:
	candado_output[2] = (candado_output[2] + 1) % 10 
	update_numbers()
	pass # Replace with function body.

func _on_button_down_3_pressed() -> void:
	candado_output[2] = (candado_output[2] - 1 + 10) % 10 
	update_numbers()
	pass # Replace with function body.


func _on_mascara_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("Click_izq"):
		print("Agarraste la mascara")
		candado_ui.queue_free()
		#$"../../../../scene/Area2D/Sprite2D".texture = maletin_Vacio
		inventory_hud.visible = true
	pass # Replace with function body.


func _on_open_pressed() -> void:
	if candado_output == candado_Success:
		PuzzleManager.puzzle_candado = true
		get_tree().change_scene_to_file("res://Scenes/Sub Scenes/test_node_B4.tscn")
	pass # Replace with function body.
