extends RigidBody2D

export var MIN_SPEED = 150 # Minimum speed range
export var MAX_SPEED = 250 # Maximum speed range
var mob_types = ["Flyer", "Swimmer", "Walker"]

# When a prefab/node is created and enters the scene tree 
func _ready():
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]
	$AnimatedSprite.play()

# Will be called when a Mob exits the screen
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
