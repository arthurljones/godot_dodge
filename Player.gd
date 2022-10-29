extends Area2D

signal hit

export var speed = 400

# Special charge percent - 0.0 = depleted, 1.0 = charged & ready
export var special_charge:float = 1.0

# Special charge rate in full charges per second
export var special_charge_rate:float = 1.0 / 8.0

export var special_scene: PackedScene

var screen_size
var hidden:bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	hidden = true
	hide()
	screen_size = get_viewport_rect().size

func start(pos):
	position = pos
	hidden = false
	special_charge = 1.0
	show()
	$Body.disabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("exit"):
		get_tree().quit()

	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1

	if not hidden:
		special_charge += delta * special_charge_rate

	if special_charge > 1.0:
		special_charge = 1.0

	if Input.is_action_just_pressed("special"):
		use_special()
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_h = velocity.x < 0
	if velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()

	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func _on_Player_body_entered(body:Node):
	hidden = true
	special_charge = 0
	hide()
	emit_signal("hit")
	$Body.set_deferred("disabled", true)

func use_special():
	if not hidden and special_charge >= 1.0:
		special_charge = 0
		var special = special_scene.instance()
		special.position = position
		get_tree().get_root().get_node("Main").add_child(special)
