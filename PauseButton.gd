extends TextureButton

var game_paused_label

func _ready():
	game_paused_label = get_node("/root/Main/GamePausedLabel")
	game_paused_label.visible = false

func _on_pressed():
	if get_tree().paused:
		get_tree().paused = false
		game_paused_label.visible = false
		
	else:
		get_tree().paused = true
		game_paused_label.visible = true
