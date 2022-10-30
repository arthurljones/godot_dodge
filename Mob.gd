extends RigidBody2D

signal killed

# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]
	$AnimatedSprite.playing = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func die():
	emit_signal("killed")
	$DeathAnim.play("fadeout")
	$AnimatedSprite.playing = false
	linear_velocity = Vector2.ZERO
	$CollisionShape2D.set_deferred("disabled", true)

func _on_DeathAnim_animation_finished(anim_name:String):
	print("mob anim finish")
	queue_free()
