extends RigidBody3D

@export var axis_scale_by: Vector3 = Vector3.ONE

@onready var mesh = $Mesh
@onready var collision_shape = $CollisionShape3D

func change_size(by: float) -> void:
	# Scale the collider and the mesh not the rigid body
	collision_shape.scale += axis_scale_by * by
	mesh.scale += axis_scale_by * by

func _ready() -> void:
	var initial_scale = scale
	collision_shape.scale *= initial_scale
	mesh.scale *= initial_scale
	scale = Vector3.ONE
