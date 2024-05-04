extends Node3D

# GOAL: Follow our character and rotate camera
var player 
@export var sensitivity := 5

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("Player")[0] # "Player" = group name
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED # capture our mouse

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = player.global_position
	$Camera3D_p1.look_at(player.get_node("LookAt_p1").global_position)

# move mouse to help player rotate
func _input(event):
	if event is InputEventMouseMotion:
		# take 2D to 3D, so divide 1000 for 1-1 translation
		# upper and lower bounds in rotation, clamping
		var tempRotation = rotation.x - event.relative.y / 1000 * sensitivity
		rotation.y -= event.relative.x / 1000 * sensitivity
		tempRotation = clamp(tempRotation, -1, -0.2) # floor, top of character
		rotation.x = tempRotation
