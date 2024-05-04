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

var synchPos = Vector3(0,0,0)


var ball_body: RigidBody3D = null
var player_marker: Marker3D = null
var player_body: CharacterBody3D = null
var ball_kicked = false
var kick_time = 0.0
const REATTACH_DELAY = 5.0

func _ready():
	# fix character rotation:
	lookat = get_tree().get_nodes_in_group("cameraController_group_p1")[0].get_node("LookAt_p1")
	
	anim_tree = $AnimationTree
	_animPlayback = anim_tree.get("parameters/playback")
	anim_tree.active = true
	
	ball_body = get_node("../Ball") as RigidBody3D
	kick_time = 0.0 
	
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())

func _physics_process(delta):
	player_marker = get_node("player_marker") as Marker3D
	player_body = get_node(".") as CharacterBody3D
	
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
	
		if not is_on_floor():
			velocity.y -= gravity * delta

		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		if ball_body:
			var distance = player_marker.global_transform.origin.distance_to(ball_body.global_transform.origin)
			if distance < 1.0 and ball_body.global_transform.origin.y < 1.0:
				ball_body.global_transform.origin = ball_body.global_transform.origin.lerp(player_marker.global_transform.origin, 0.6)
				ball_body.linear_velocity = player_body.get_velocity()
				if Input.is_action_just_pressed("kick"):
					var dir_kick = (ball_body.global_transform.origin - player_body.global_transform.origin) * 8.0
					ball_body.apply_central_impulse(Vector3(dir_kick))
					anim_tree.set("parameters/conditions/Kick Ball", true)
					ball_kicked = true
					kick_time = Time.get_ticks_msec()
					ball_body = null
		else:
			if not ball_kicked:
				ball_body = get_node("../Ball") as RigidBody3D
				var ball_in_proximity = player_marker.global_transform.origin.distance_to(ball_body.global_transform.origin) < 1.0
				if ball_in_proximity:
					ball_body.global_transform.origin = player_marker.global_transform.origin
			else:
				if Time.get_ticks_msec() - kick_time >= REATTACH_DELAY * 1000:
					ball_body = get_node("../Ball") as RigidBody3D
					var ball_in_proximity = player_marker.global_transform.origin.distance_to(ball_body.global_transform.origin) < 1.0
					if ball_in_proximity:
						ball_body.global_transform.origin = player_marker.global_transform.origin
		
		synchPos = global_position
		
		var current_node = _animPlayback.get_current_node()
		#print(current_node)
		if current_node == "kick ball":  # Ensure lowercase matches exactly
			#print("Stopping kick animation")  # Check if this line is being reached
			anim_tree.set("parameters/conditions/Kick Ball", false)
			#velocity = Vector3.ZERO
			#Velocity = velocity
			#return 
		
		var turn_strength = Input.get_axis("ui_left", "ui_right")
		var move_strength = Input.get_axis("ui_up", "ui_down")

		rotate_y(-turn_strength * RotationVelocity)


		#var direction = (transform.basis * Vector3(0, 0, move_strength)).normalized()
		#var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")	
		#var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
		var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var camera_transform = get_tree().get_nodes_in_group("cameraController_group_p1")[0].global_transform
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
	
	else:
		global_position = global_position.lerp(synchPos, .5)
		
 
