extends Area2D

signal hit
signal immune

export var SPEED = 400 # How fast the player will move (pixels/sec)
var screen_size # Size of the game window
var extra_life

# When a prefab/node is created and enters the scene tree 
func _ready():
	hide()
	screen_size = get_viewport_rect().size
	extra_life = 0
	$Shield.modulate = Color(0,.75,1)
	$Shield.visible = false
	#$ShieldOn.interpolate_property($Shield, "scale", $Shield.scale, Vector2(0.395,0.395), 1,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	#$ShieldOff.interpolate_property($Shield, "scale", $Shield.scale, Vector2(0,0), 1,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

# Describe what the node/prefab will do at each frame / delta:
# - check for inputs
# - move in the given direction
# - play the appropriate animation
func _process(delta):
	var velocity = Vector2() # Player movement vector
	if Input.is_action_pressed("ui_right") == true or Input.is_key_pressed(KEY_D) == true:
        velocity.x = 1
	if Input.is_action_pressed("ui_left") == true or Input.is_key_pressed(KEY_Q) == true or Input.is_key_pressed(KEY_A) == true:
		velocity.x = -1
	if Input.is_action_pressed("ui_up") == true or Input.is_key_pressed(KEY_Z) == true or Input.is_key_pressed(KEY_W) == true:
		velocity.y = -1
	if Input.is_action_pressed("ui_down") == true or Input.is_key_pressed(KEY_S) == true:
		velocity.y = 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
		$Trail.emitting = true
		$AnimatedSprite.play() # the '$' character is a shortcut to the get_node() function
	else:
		$Trail.emitting = false
		$AnimatedSprite.stop()
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x) # Clamping a value means restricting it to a given range
	position.y = clamp(position.y, 0, screen_size.y)
	if velocity.x != 0:
		$AnimatedSprite.animation = "MoveX"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = (true if velocity.x < 0 else false)
	elif velocity.y != 0:
		$AnimatedSprite.animation = "MoveY"
		$AnimatedSprite.flip_v = (true if velocity.y > 0 else false)

# Will be called when a RigidBody2D collide with the Player:
# - Hide the Player
# - throw signal 'hit'
# - disable collision so the 'hit' signal is send only once
func _on_Player_body_entered(body):
	$CollisionShape2D.set_deferred("disabled", true)
	if extra_life == 0:
		hide()
		emit_signal("hit")
	else:
		emit_signal("immune")
		$Shield.visible = true
		#$ShieldOn.start()
		#yield($ShieldOn, "tween_completed")

func start(pos):
	position = pos
	show()
# Player's hitbox will be enabled when StartTimer stops (cf. Main.gd)

func _on_ImmunityTimer_timeout():
	$CollisionShape2D.set_deferred("disabled", false)
	#$ShieldOff.start()
	#yield($ShieldOff, "tween_completed")
	$Shield.visible = false
