extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const RotationVelocity = -0.04

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var anim_tree
var _animPlayback
var Velocity : Vector3
var kicked = false
var some_impulse_strength = 10.0

# fix character rotation:
var lookat
var lastLookAtDirection : Vector3

func _ready():
	# fix character rotation
	lookat = get_tree().get_nodes_in_group("cameraController_group_p2")[0].get_node("LookAt_p2")
	
	anim_tree = $AnimationTree
	_animPlayback = anim_tree.get("parameters/playback")
	anim_tree.active = true

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# handles kicking of ball - correctly implemented
	if Input.is_action_just_pressed("kick") and is_on_floor():
		anim_tree.set("parameters/conditions/Kick Ball", true)
	
	var current_node = _animPlayback.get_current_node()
	print(current_node)
	if current_node == "kick ball":  # Ensure lowercase matches exactly
		print("Stopping kick animation")  # Check if this line is being reached
		anim_tree.set("parameters/conditions/Kick Ball", false)
	
	var turn_strength = Input.get_axis("ui_left", "ui_right")
	var move_strength = Input.get_axis("ui_up", "ui_down")

	rotate_y(-turn_strength * RotationVelocity)


	#var direction = (transform.basis * Vector3(0, 0, move_strength)).normalized()
	#var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")	
	#var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var camera_transform = get_tree().get_nodes_in_group("cameraController_group_p2")[0].global_transform
	var camera_forward = -camera_transform.basis.z.normalized()
	var camera_right = camera_transform.basis.x.normalized()
	#var direction = camera_forward * input_dir.y + camera_right * input_dir.x
	#var direction = camera_right * input_dir.x + camera_forward * input_dir.y
	var direction = -camera_forward * input_dir.y + camera_right * input_dir.x
	direction.y = 0  # Ensure no vertical movement
	
	if direction:
		# rotate player according to camera rotation
		# anything low like .1 can break it...
		var lerpDirection = lerp(lastLookAtDirection, Vector3(lookat.global_position.x, global_position.y, lookat.global_position.z), 0.3)
		look_at(lerpDirection)
		lastLookAtDirection = lerpDirection
		
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
