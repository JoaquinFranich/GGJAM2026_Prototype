extends HBoxContainer

var candado_Success = [8,5,6]
var candado_output = [0,0,0]
var numbers: Array = [0,1,2,3,4,5,6,7,8,9]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"..".visible = false
	update_numbers()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_exit_pressed() -> void:
	$"..".visible = false
	pass # Replace with function body.


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("Click_izq"):
		$"..".visible = true
	pass # Replace with function body.

func _on_open_candado_pressed() -> void:
	if candado_output == candado_Success:
		print("Candado abierto")
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
