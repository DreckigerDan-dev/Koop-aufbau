extends CharacterBody2D

signal gathered(resource_type: String, amount: int)
signal clicked(worker: CharacterBody2D)

const SPEED := 120.0
const GATHER_DURATION := 1.5

@export var normal_color: Color = Color(0.2, 0.4, 0.8)
@export var selected_color: Color = Color(0.4, 0.8, 1.0)

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var visual: Polygon2D = $Visual

var _target_resource: Area2D = null
var _moving := false
var _gathering := false

func _ready() -> void:
	add_to_group("workers")
	input_event.connect(_on_input_event)
	visual.color = normal_color

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("[Worker] geklickt: ", name)
		clicked.emit(self)

func set_selected(is_selected: bool) -> void:
	print("[Worker] ", name, " ausgewählt: ", is_selected)
	visual.color = selected_color if is_selected else normal_color

func move_to_point(target_position: Vector2) -> void:
	if _gathering:
		return
	print("[Worker] ", name, " -> move_to_point ", target_position)
	_target_resource = null
	_moving = true
	nav_agent.target_position = target_position

func move_to_resource(resource_node: Area2D) -> void:
	if _gathering:
		return
	print("[Worker] ", name, " -> move_to_resource ", resource_node.name)
	_target_resource = resource_node
	_moving = true
	nav_agent.target_position = resource_node.global_position

func _physics_process(_delta: float) -> void:
	if _gathering or not _moving:
		velocity = Vector2.ZERO
		return

	if nav_agent.is_navigation_finished():
		_moving = false
		if _target_resource != null:
			_start_gathering()
		return

	var next_point: Vector2 = nav_agent.get_next_path_position()
	velocity = global_position.direction_to(next_point) * SPEED
	move_and_slide()

func _start_gathering() -> void:
	_gathering = true
	velocity = Vector2.ZERO
	await get_tree().create_timer(GATHER_DURATION).timeout

	if is_instance_valid(_target_resource):
		var resource_type: String = _target_resource.resource_type
		var taken: int = _target_resource.gather(_target_resource.amount)
		gathered.emit(resource_type, taken)

	_target_resource = null
	_gathering = false
