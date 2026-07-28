extends Area2D

@export var resource_type: String = "holz"
@export var amount: int = 10
@export var visual_color: Color = Color(0.18, 0.49, 0.2)

@onready var visual: Polygon2D = $Visual

func _ready() -> void:
	add_to_group("resource_nodes")
	visual.color = visual_color

func gather(gather_amount: int) -> int:
	var taken: int = min(gather_amount, amount)
	amount -= taken
	if amount <= 0:
		queue_free()
	return taken
