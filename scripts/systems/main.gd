extends Node2D

@onready var holz_label: Label = $CanvasLayer/HolzLabel
@onready var stahl_label: Label = $CanvasLayer/StahlLabel
@onready var base_label: Label = $CanvasLayer/BaseLabel

var colony := Colony.new()
var _selected_worker: CharacterBody2D = null

func _ready() -> void:
	colony.resource_changed.connect(_on_resource_changed)

	for worker in get_tree().get_nodes_in_group("workers"):
		worker.gathered.connect(_on_worker_gathered)
	for building in get_tree().get_nodes_in_group("buildings"):
		building.base_selected.connect(_on_base_selected)

	var workers := get_tree().get_nodes_in_group("workers")
	if workers.size() > 0:
		_select_worker(workers[0])

	holz_label.text = "Holz: 0"
	stahl_label.text = "Stahl: 0"
	base_label.text = "Keine Basis ausgewählt"

func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		return

	var world_pos: Vector2 = get_global_mouse_position()
	var query := PhysicsPointQueryParameters2D.new()
	query.position = world_pos
	query.collide_with_areas = true
	query.collide_with_bodies = true
	var results: Array[Dictionary] = get_world_2d().direct_space_state.intersect_point(query, 8)

	var hit_worker: CharacterBody2D = null
	var hit_resource: Area2D = null
	var hit_building: Area2D = null

	for result in results:
		var collider: Object = result["collider"]
		if collider.is_in_group("workers"):
			hit_worker = collider
		elif collider.is_in_group("resource_nodes"):
			hit_resource = collider
		elif collider.is_in_group("buildings"):
			hit_building = collider

	if hit_worker != null:
		_select_worker(hit_worker)
	elif hit_building != null:
		hit_building.become_base()
	elif hit_resource != null:
		if _selected_worker != null:
			_selected_worker.move_to_resource(hit_resource)
	elif _selected_worker != null:
		_selected_worker.move_to_point(world_pos)

func _select_worker(worker: CharacterBody2D) -> void:
	if _selected_worker != null:
		_selected_worker.set_selected(false)
	_selected_worker = worker
	_selected_worker.set_selected(true)

func _on_worker_gathered(resource_type: String, amount: int) -> void:
	colony.add_resource(resource_type, amount)

func _on_resource_changed(resource_type: String, total: int) -> void:
	if resource_type == "holz":
		holz_label.text = "Holz: %d" % total
	elif resource_type == "stahl":
		stahl_label.text = "Stahl: %d" % total

func _on_base_selected(building_name: String) -> void:
	base_label.text = "Basis: %s" % building_name
