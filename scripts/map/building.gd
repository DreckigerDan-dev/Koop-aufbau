extends Area2D

signal base_selected(building_name: String)

@export var normal_color: Color = Color(0.55, 0.42, 0.25)
@export var base_color: Color = Color(1.0, 0.85, 0.1)

@onready var visual: Polygon2D = $Visual

func _ready() -> void:
	add_to_group("buildings")
	input_event.connect(_on_input_event)
	visual.color = normal_color

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_become_base()

func _become_base() -> void:
	# Nur ein Gebäude gleichzeitig kann Basis sein.
	for building in get_tree().get_nodes_in_group("buildings"):
		building.visual.color = building.normal_color
	visual.color = base_color
	base_selected.emit(name)
