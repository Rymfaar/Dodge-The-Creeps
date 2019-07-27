extends CanvasLayer

signal start_game

func _ready():
	$ScoreLabel.text = str(0)

func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()

func show_game_over():
	$ScoreLabel.add_color_override("font_color", Color(1, 1, 1))
	show_message("Game Over")
	yield($MessageTimer, "timeout")
	$MessageLabel.text = "Dodge the\nCreeps!"
	$MessageLabel.show()
	yield(get_tree().create_timer(1), 'timeout')
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)

# Update ScoreLabel font color depending on current life
func update_score_color(life):
	match life:
		1:
			$ScoreLabel.add_color_override("font_color", Color(1, 1, 0))
		2:
			get_node("ScoreLabel").add_color_override("font_color", Color(.28, .28, .8))
		_:
			get_node("ScoreLabel").add_color_override("font_color", Color(1, 0, 0))

func _on_MessageTimer_timeout():
	$MessageLabel.hide()

func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")
