extends Control
@onready var score_label = $Label


var emily_score = 0
var alice_score = 0
const winning_score = 2

@export var Player1 : Node
var initial_ball_position: Vector3
var initial_player_spawn_points = []
@export var Ball : Node

func update_score_label():
	score_label.text = "Emily: " + str(emily_score) + "\n" + "Alice: " + str(alice_score)

func _on_area_3d_point_scores():
	emily_score += 1
	update_score_label()
	check_game_over()
	#print(emily_score)

func _on_area_3d_point_scores2():
	alice_score += 1
	update_score_label()
	check_game_over()
	#print(alice_score)

func _ready():
	Ball = get_node("../Ball")
	update_score_label()
	for spawn_point in get_tree().get_nodes_in_group("PlayerSpawnPoint"):
		initial_player_spawn_points.append(spawn_point.global_transform.origin)
	initial_ball_position = Ball.global_transform.origin
	
func check_game_over():
	if emily_score >= winning_score:
		#print("Emily Wins!")
		game_over("Emily")
	elif alice_score >= winning_score:
		#print("Alice Wins!")
		game_over("Alice")
		
func game_over(winner: String):	
	var game_over_screen = preload("res://game_over_screen.tscn").instantiate()
	get_tree().root.add_child(game_over_screen)
	self.hide()
	
	game_over_screen.set_winner_title(winner)
	#$Timer.stop() # stop any ongoing game timers
	self.queue_free() # free this scene


func _on_left_side_body_entered(body):
		alice_score -= 1
		update_score_label()



func _on_right_side_body_entered(body):
	emily_score -= 1
	update_score_label()
