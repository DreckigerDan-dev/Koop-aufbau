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
	var workers := get_tree().get_nodes_in_group("workers")
	for worker in workers:
		worker.gathered.connect(_on_worker_gathered)
		worker.clicked.connect(_on_worker_clicked)

	if workers.size() > 0:
		_on_worker_clicked(workers[0])

	holz_label.text = "Holz: 0"
	stahl_label.text = "Stahl: 0"
	base_label.text = "Keine Basis ausgewählt"

func _on_worker_clicked(worker: CharacterBody2D) -> void:
	print("[Main] Arbeiter-Klick empfangen: ", worker.name)
	if _selected_worker != null:
		_selected_worker.set_selected(false)
	_selected_worker = worker
	_selected_worker.set_selected(true)

func _on_resource_clicked(resource_node: Area2D) -> void:
	print("[Main] Ressourcen-Klick empfangen: ", resource_node.name, " selected_worker=", _selected_worker)
	if _selected_worker == null:
		return
	_selected_worker.move_to_resource(resource_node)

func _unhandled_input(event: InputEvent) -> void:
	# Klick auf Gebäude/Ressource/Arbeiter wird schon vorher über deren
	# eigenes input_event verarbeitet; hier landet nur ein Klick auf leeren Boden.
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("[Main] Klick auf leeren Boden, selected_worker=", _selected_worker)
		if _selected_worker != null:
			_selected_worker.move_to_point(get_global_mouse_position())

func _on_worker_gathered(resource_type: String, amount: int) -> void:
	colony.add_resource(resource_type, amount)

func _on_resource_changed(resource_type: String, total: int) -> void:
	if resource_type == "holz":
		holz_label.text = "Holz: %d" % total
	elif resource_type == "stahl":
		stahl_label.text = "Stahl: %d" % total

func _on_base_selected(building_name: String) -> void:
	base_label.text = "Basis: %s" % building_name
