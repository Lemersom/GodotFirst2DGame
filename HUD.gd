extends CanvasLayer

signal start_game

func update_score(score):
	$ScoreLabel.text = str(score)

func show_message(text):
	$MassageLabel.text = text
	$MassageLabel.show()
	$MessageTimer.start()


func show_game_over():
	show_message("Game Over")
	yield($MessageTimer, "timeout")
	$MassageLabel.text = "Foge dos Bixo"
	$MassageLabel.show()
	yield(get_tree().create_timer(1.0), "timeout") #get_tree pega o objeto dessa cena, vai pausar por 1s
	$Button.show()


func _on_Button_pressed():
	$Button.hide()
	emit_signal("start_game")


func _on_MessageTimer_timeout():
	$MassageLabel.hide()
