extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var animation_param:float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	print("special ready")
	$AnimationPlayer.play("explode")

func _draw():
	var radius = $CollisionShape2D.shape.radius * animation_param
	var color = Color.maroon
	color.a = 0.5
	print("special draw param %f radius %f" % [animation_param, radius])
	draw_circle(Vector2.ZERO, radius, color)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update()

func _on_AnimationPlayer_animation_finished(anim_name:String):
	print("special anim complete")
	queue_free()

func _on_Node2D_body_entered(body:Node):
	# Kill enemies that touch the explosion
	body.queue_free()

