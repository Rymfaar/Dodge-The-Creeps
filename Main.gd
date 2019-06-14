extends Node

# Color(float, float, float, float) avec float entre 0 et 1 (donc diviser par 255)
# When Extra Life == 3 stop ExtraLifeTimer
# Clamp only when ExtraLife changes
# - si j'ai moins de 3 le timer est en route
# - si j'ai plus de 3 le timer s'arrete
# - si je consomme 1 des 3 il faut réactiver le timer

signal kill_all_mobs()

export (PackedScene) var Mob
var score

func _ready():
	randomize()

func game_over():
	$ExtraLifeTimer.stop()
	$HUD.update_score_color(Color(1, 1, 1))
	$Music.stop()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Defeat.play()

func new_game():
	$Player.extra_life = 0
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
	$HUD.update_score_color(Color(1, 0, 0))
	$MobTimer.start()
	$ScoreTimer.start()
	$ExtraLifeTimer.start()
	# Enable Player's hitbox to make sure all old mobs are gone
	$Player/CollisionShape2D.disabled = false

func _on_ExtraLifeTimer_timeout():
	$Player.extra_life += 1
	$Player.extra_life = clamp($Player.extra_life, 0, 2)
	match $Player.extra_life:
		1:
			$HUD.update_score_color(Color(1, 1, 0))
		2:
			$HUD.update_score_color(Color(.28, .82, .8))
		_:
			$HUD.update_score_color(Color(1, 0, 0))
