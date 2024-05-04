extends Node3D

var player1_points = 0
var player2_points = 0

var max_points = 1 # Change to any number
var initial_ball_position : Vector3
@export var PlayerScene : PackedScene

var initial_player1_position : Vector3
var initial_player2_position : Vector3
 
var initialSpawnPositions = []
var spawnPoints = {
	1: Vector3(37.855, -27.4329, -9.432819), # Spawn point for player 1
	2: Vector3(37.8407, -27.4329, -19.30601), # Spawn point for player 2
	}
	# Add more spawn points as needed}
func _ready():
	initial_ball_position = get_node("Ball").global_transform.origin
	initial_player1_position = get_node("Player1").global_transform.origin
	initial_ball_position = get_node("Ball").global_transform.origin
	
	var index = 0
	# Store initial spawn positions
	for spawn in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
		initialSpawnPositions.append(spawn.global_position)

	# Instantiate players
	for i in GameManager.Players:
		var currentPlayer = PlayerScene.instantiate()
		currentPlayer.name = str(GameManager.Players[i].id)
		add_child(currentPlayer)
		# Set initial spawn positions
		currentPlayer.global_position = initialSpawnPositions[index]
		index += 1

func resetPlayerPositions():
	#for player_id in GameManager.Players.keys():
		#var player_node = get_node(str(GameManager.Players[player_id].id))
		#if spawnPoints.has(player_id):
			#player_node.global_transform.origin = spawnPoints[player_id]
			#print(spawnPoints[player_id])
		#else:
			#print("Warning: Player ID " + str(player_id) + " has no corresponding spawn point.")

	var ball = get_node("Ball")
	ball.global_transform.origin = initial_ball_position
	ball.linear_velocity = Vector3(0, 0, 0)
	ball.angular_velocity = Vector3(0, 0, 0)
	
	# Reset any other relevant game state
	#print("Game Reset")


func _process(delta):
	pass


func _on_area_3d_point_scores():
	resetPlayerPositions()


func _on_area_3d_point_scores2():
	resetPlayerPositions()




func _on_left_side_body_entered(body):
	resetPlayerPositions()


func _on_right_side_body_entered(body):
	resetPlayerPositions()
