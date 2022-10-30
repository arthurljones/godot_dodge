extends CanvasLayer

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func setup():
	show_message("Dodge the Creeps!", false)
	$StartButton.show()

func show_message(text:String, temporary:bool = true):
	if temporary:
		$MessageTimer.start()
	else:
		# Stop the timer in case it's currently running
		$MessageTimer.stop()
	$Message.text = text
	$Message.show()

func show_game_over():
	show_message("Game Over")

	# Wait until the MessageTimer has counted down.
	yield($MessageTimer, "timeout")
	
func update_score(score):
	$ScoreLabel.text = str(score)

func update_special_charge(special_charge:float):
	$SpecialCharge.value = special_charge

func _on_StartButton_pressed():
    $StartButton.hide()
    emit_signal("start_game")

func _on_MessageTimer_timeout():
    $Message.hide()