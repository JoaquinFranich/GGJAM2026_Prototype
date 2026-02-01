extends Sprite2D
@onready var pickup_item: Area2D = $"../PickupItem"
@onready var piedras: Array = $"../scene/Piedras".get_children()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if pickup_item:
		pickup_item.visible = false
	pass # Replace with function body.


func _process(_delta: float) -> void:
	# 1. SEGURIDAD: Si el objeto ya no existe (fue recogido), dejamos de procesar
	if not is_instance_valid(pickup_item):
		set_process(false) # Desactivamos este script para ahorrar recursos
		return
		
	# 2. Si ya es visible, no hace falta seguir comprobando
	if pickup_item.visible:
		return
		
	check_piedras()

func check_piedras():
	var todas_listas = true
	
	for piedra in piedras:
		# Verificamos que la piedra exista antes de leer su propiedad .correct
		if is_instance_valid(piedra) and not piedra.correct:
			todas_listas = false
			break 
	
	if todas_listas:
		# Verificamos de nuevo antes de cambiar la visibilidad
		if is_instance_valid(pickup_item):
			print("¡Todas las piedras están en su lugar!")
			pickup_item.visible = true
