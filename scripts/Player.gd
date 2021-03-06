extends Area2D

signal pickup
signal hurt

export (int) var speed
var velocity = Vector2()
var screensize = Vector2(480, 720)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	get_input()
	position += velocity * delta
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0 , screensize.y)
	
	if velocity.length() > 0:
		$AnimatedSprite.animation = "run"
		$AnimatedSprite.flip_h = velocity.x < 0
	else:
		$AnimatedSprite.animation = "idle"

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

func start(pos):
	set_process(true)
	position = pos
	$AnimatedSprite.animation = "idle"

func die():
	# Setting set_process(false) causes the _process()
	# function to no longer be called for this node.
	# when the player has died, they can't be moved
	$AnimatedSprite.animation = "hurt"
	set_process(false)


func _on_Player_area_entered(area):
	if area.is_in_group("coins"):
		area.pickup()
		# calling pickup function from signal
		# _on_Player_pickup() on Main node
		emit_signal("pickup", "coin")
	if area.is_in_group("obstacles"):
		emit_signal("hurt")
		die()
	if area.is_in_group("powerups"):
		area.pickup()
		emit_signal("pickup", "powerup")
		print("get powerups")

