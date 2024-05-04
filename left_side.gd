extends Area3D
signal out

func _on_body_entered(body):
	if body is RigidBody3D:
		out.emit()

