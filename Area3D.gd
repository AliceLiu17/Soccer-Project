extends Area3D
signal point_scores

func _on_body_entered(body):
	if body is RigidBody3D:
		point_scores.emit()
