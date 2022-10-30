extends Node

export var mob_scene: PackedScene
export var mob_death_score:int = 3

var score

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	setup()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$HUD.update_special_charge($Player.special_charge)

func setup():
	set_score(0)
	get_tree().call_group("mobs", "queue_free")
	$HUD.setup()

func new_game():
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.show_message("Get Ready")
	$Music.play()

func game_over():
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$ResetTimer.start()

func _on_MobTimer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instance()

	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("MobPath/MobSpawn")
	mob_spawn_location.offset = randi()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Listen for the mob's death
	mob.connect("killed", self, "_on_mob_killed")
	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

func _on_ScoreTimer_timeout():
	set_score(score + 1)

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func set_score(new_score):
	score = new_score
	$HUD.update_score(score)

func _on_ResetTimer_timeout():
	setup()

func _on_mob_killed():
	print("_on_mob_killed")
	set_score(score + mob_death_score)
