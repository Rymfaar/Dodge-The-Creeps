extends Node

signal kill_all_mobs()

export (PackedScene) var Mob
var score

func _ready():
	randomize()

func game_over():
	$Music.stop()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Defeat.play()

func new_game():
	emit_signal("kill_all_mobs")
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get ready")
	$Music.play()

func _on_MobTimer_timeout():
	# Choose a random location on Path2D.
	$MobSpawner/MobSpawnLocation.set_offset(randi())
	# Create a Mob instance and add it to the scene.
	var mob = Mob.instance()
	# When starting a new game, the signal 'kill_all_mobs' will be emitted so remaining mobs will call the destroy function
	connect("kill_all_mobs", mob, "destroy")
	add_child(mob)
	# Set the mob's direction perpendicular to the path direction.
	var direction = $MobSpawner/MobSpawnLocation.rotation + PI/2
	# Set the mob's position to a random location.
	mob.position = $MobSpawner/MobSpawnLocation.position
	# Add some randomness to the direction.
	direction += rand_range(-PI/4, PI/4)
	mob.rotation = direction
	# Set the velocity (speed & direction).
	mob.linear_velocity = Vector2(rand_range(mob.MIN_SPEED, mob.MAX_SPEED), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	# Enable Player's hitbox to make sure all old mobs are gone
	$Player/CollisionShape2D.disabled = false