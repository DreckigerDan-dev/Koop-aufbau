extends Node2D

@onready var resource_label: Label = $CanvasLayer/ResourceLabel
@onready var worker: CharacterBody2D = $Worker

var _holz := 0

func _ready() -> void:
	for resource_node in get_tree().get_nodes_in_group("resource_nodes"):
		resource_node.clicked.connect(_on_resource_clicked)
	worker.gathered.connect(_on_worker_gathered)
	_update_label()

func _on_resource_clicked(resource_node: Area2D) -> void:
	worker.move_to_resource(resource_node)

func _on_worker_gathered(resource_type: String, amount: int) -> void:
	if resource_type == "holz":
		_holz += amount
		_update_label()

func _update_label() -> void:
	resource_label.text = "Holz: %d" % _holz
