extends Sprite2D
@onready var reja_abierta: Sprite2D = $"../Reja_Abierta"
@onready var reja_cerrada: Sprite2D = $"."
@onready var area_2d: PlaceableZone = $"../Area2D"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if  area_2d.abrir_reja:
		reja_cerrada.visible = false
		reja_abierta.visible = true
	pass
