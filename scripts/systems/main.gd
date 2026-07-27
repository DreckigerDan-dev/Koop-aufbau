extends Node2D

@onready var holz_label: Label = $CanvasLayer/HolzLabel
@onready var stahl_label: Label = $CanvasLayer/StahlLabel
@onready var base_label: Label = $CanvasLayer/BaseLabel

var colony := Colony.new()
var _selected_worker: CharacterBody2D = null

func _ready() -> void:
	colony.resource_changed.connect(_on_resource_changed)

	for resource_node in get_tree().get_nodes_in_group("resource_nodes"):
		resource_node.clicked.connect(_on_resource_clicked)
	for building in get_tree().get_nodes_in_group("buildings"):
		building.base_selected.connect(_on_base_selected)
	for worker in get_tree().get_nodes_in_group("workers"):
		worker.gathered.connect(_on_worker_gathered)
		worker.clicked.connect(_on_worker_clicked)

	holz_label.text = "Holz: 0"
	stahl_label.text = "Stahl: 0"
	base_label.text = "Keine Basis ausgewählt"

func _on_worker_clicked(worker: CharacterBody2D) -> void:
	if _selected_worker != null:
		_selected_worker.set_selected(false)
	_selected_worker = worker
	_selected_worker.set_selected(true)

func _on_resource_clicked(resource_node: Area2D) -> void:
	if _selected_worker == null:
		return
	_selected_worker.move_to_resource(resource_node)

func _on_worker_gathered(resource_type: String, amount: int) -> void:
	colony.add_resource(resource_type, amount)

func _on_resource_changed(resource_type: String, total: int) -> void:
	if resource_type == "holz":
		holz_label.text = "Holz: %d" % total
	elif resource_type == "stahl":
		stahl_label.text = "Stahl: %d" % total

func _on_base_selected(building_name: String) -> void:
	base_label.text = "Basis: %s" % building_name
