extends CharacterBody2D

signal gathered(resource_type: String, amount: int)

const SPEED := 120.0
const GATHER_DURATION := 1.5

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

var _target_resource: Area2D = null
var _gathering := false

func move_to_resource(resource_node: Area2D) -> void:
	if _gathering:
		return
	_target_resource = resource_node
	nav_agent.target_position = resource_node.global_position

func _physics_process(_delta: float) -> void:
	if _gathering or _target_resource == null:
		velocity = Vector2.ZERO
		return

	if nav_agent.is_navigation_finished():
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
