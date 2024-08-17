extends Node3D

@onready var target = $"../Target"

func _process(delta: float) -> void:
	var length = (target.global_position - global_position).length()
	scale.z = length
	look_at(target.global_position, Vector3.UP)
	
