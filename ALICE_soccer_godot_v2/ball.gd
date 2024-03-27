extends RigidBody3D
@export var force = 0.2  # Adjust this value as needed
const DECELERATION_RATE = 5.0  # Rate at which the ball decelerate

var synchPos = Vector3(0,0,0)


func _process(delta):
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	


# Adjust these parameters as needed
func _physics_process(delta):
	# Apply linear damping to gradually reduce velocity
	var current_velocity = get_linear_velocity()
	var new_velocity = current_velocity.lerp(Vector3.ZERO, DECELERATION_RATE * delta)
	set_linear_velocity(new_velocity)



	
func _integrate_forces(state):
	if Input.is_action_just_pressed("kick"):
		var character_direction = -global_transform.basis.z
		var kick_direction = character_direction.rotated(Vector3.UP, global_transform.basis.get_euler().y)
		apply_impulse(global_transform.origin, kick_direction.normalized() * force)
		
		# Reset angular velocity to zero
		set_angular_velocity(Vector3.ZERO)
