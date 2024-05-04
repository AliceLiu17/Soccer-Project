extends RigidBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const RotationVelocity = -0.04
const DAMPING = 0.1

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	var current_velocity = get_linear_velocity()
	var new_velocity = current_velocity.lerp(Vector3.ZERO, DAMPING * delta)
	set_linear_velocity(new_velocity)
