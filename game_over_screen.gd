extends CanvasLayer

@onready var winner_title = $PanelContainer/MarginContainer/Rows/winner_label

func set_winner_title(winner: String):
	if winner:
		#### SET WINNER NAME TITLE
		winner_title.text = winner + " Wins!"

func _on_restart_button_pressed(): # a cop out - doesnt work bc player 2 is not shown at all
	print("restart")
	#get_tree().quit()

	# Restart the game
	#var executable_path = OS.get_executable_path()
	#OS.execute(executable_path, [])
	
func _on_quit_button_pressed():
	get_tree().quit()

func _ready():
	pass
