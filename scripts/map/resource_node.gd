extends Area2D

signal clicked(resource_node: Area2D)

@export var resource_type: String = "holz"
@export var amount: int = 10

func _ready() -> void:
	add_to_group("resource_nodes")
	input_event.connect(_on_input_event)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		clicked.emit(self)

func gather(gather_amount: int) -> int:
	var taken: int = min(gather_amount, amount)
	amount -= taken
	if amount <= 0:
		queue_free()
	return taken
