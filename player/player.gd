extends CharacterBody3D

@export var laser: Node3D
@onready var eyes = $Eyes
@export var target_node : Node3D

const SPEED = 5.0
const ROTATION_SPEED = 5.0
const JUMP_VELOCITY = 5.0
const FRICTION = 0.5

var is_firing: bool = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Friction
	velocity *= Vector3(FRICTION, 1, FRICTION)
	
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Make player rotate on Y axis with A-D keys
	var rotate_direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	rotate_y(-rotate_direction * ROTATION_SPEED * delta)

	# Move the player with W-S keys in the direction we are facing
	var move_amount = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	var move_direction = transform.basis.z.normalized()
	velocity += move_direction * SPEED * move_amount
	
	if is_firing:
		update_laser()

	move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == 1:
		if event.is_pressed() and not is_firing:
			fire_laser()
		else:
			stop_firing()


func direction_to_euler(vector: Vector3) -> Vector3:
	# Normalize the vector
	vector = vector.normalized()
	# Calculate yaw (ψ)
	var yaw = atan2(vector.y, vector.x)
	# Calculate pitch (θ)
	var pitch = asin(-vector.z)
	# Roll (φ) is typically zero for direction vectors
	var roll = 0
	return Vector3(yaw, pitch, roll)


func update_laser(length: float = 100) -> void:
	var mouse_position = get_viewport().get_mouse_position()
	# Raycast from the camera and pick any colliding object
	var camera = get_viewport().get_camera_3d()
	var from = camera.project_ray_origin(mouse_position)
	var to = from + camera.project_ray_normal(mouse_position) * length
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = space.intersect_ray(query)
	
	var target = to
	if result:
		target = result.position
	target_node.global_position = target
	laser.global_position = eyes.global_position


func fire_laser() -> void:
	is_firing = true
	laser.show()

func stop_firing() -> void:
	is_firing = false
	laser.hide()
