class_name Colony
extends RefCounted

signal resource_changed(resource_type: String, total: int)

var resources: Dictionary = {"holz": 0, "stahl": 0}

func add_resource(resource_type: String, amount: int) -> void:
	resources[resource_type] = resources.get(resource_type, 0) + amount
	resource_changed.emit(resource_type, resources[resource_type])
