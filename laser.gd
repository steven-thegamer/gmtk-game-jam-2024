extends CSGCylinder3D

@onready var target = $"../Target"

func _process(delta: float) -> void:
	var length = (target.global_position - global_position).length()
	scale.y = length
	look_at(target.global_position, Vector3.UP) # FIXME: DOES NOT WORK. NO IDEA HOW TO FIX
	
