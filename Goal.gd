extends Area3D

signal goal_scored(score)

signal point_scores

var goal = false
var soccer_ball

#func _ready():
	#soccer_ball = get_tree().get_nodes_in_group("soccer_ball")[0]

#func _on_body_entered(body: PhysicsBody3D):
	#if body.is_in_group("soccer_ball") and not goal:
		#print("Goal Scored!")
		#goal = true
		#
		#emit_signal("goal_scored", 1) # emit signal to indicate a score has been made
		
func _on_body_entered(body):
	if body is RigidBody3D:
		point_scores.emit()
