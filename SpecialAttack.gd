extends Area2D

# Explosion size at its largest, in pixels
export var max_radius:float = 120.0
export var animation_param:float = 0.0
# Current explosion current_radius
var current_radius:float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("explode")

func _draw():
	var color = Color.orange
	color.a = 0.5
	draw_circle(Vector2.ZERO, current_radius, color)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	current_radius = max_radius * animation_param
	$CollisionShape2D.shape.radius = current_radius
	# Force redraw to update the explosion circle
	update()

func _on_AnimationPlayer_animation_finished(_anim_name:String):
	queue_free()

func _on_Node2D_body_entered(body:Node):
	# Kill enemies that touch the explosion
	if body.has_method("die"):
		body.die()

