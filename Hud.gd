extends CanvasLayer

signal start_game

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func show_message(text):
    $Message.text = text
    $Message.show()
    $MessageTimer.start()

func show_game_over():
	show_message("Game Over")

	# Wait until the MessageTimer has counted down.
	yield($MessageTimer, "timeout")
	
func update_score(score):
	$ScoreLabel.text = str(score)

func _on_StartButton_pressed():
    $StartButton.hide()
    emit_signal("start_game")

func _on_MessageTimer_timeout():
    $Message.hide()