extends CharacterBody2D

const speed = 100
var current_dir = "none"

func _ready():
	$AnimatedSprite2D.play("Idle")

func _physics_process(delta):
	player_movement(delta)
	
func player_movement(delta):
	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		play_animation(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		play_animation(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		play_animation(1)
		velocity.y = speed
		velocity.x = 0
	elif Input.is_action_pressed("ui_up"):
		current_dir = "up"
		play_animation(1)
		velocity.y = -speed
		velocity.x = 0
	else:
		play_animation(0)
		velocity.x = 0
		velocity.y = 0
	move_and_slide()
	
func play_animation(direction):
	var dir =  current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if direction == 1:
			anim.play("side_walk")
		elif direction == 0:
			anim.play("side_Idle")
	if dir == "left":
		anim.flip_h = true
		if direction == 1:
			anim.play("side_walk")
		elif direction == 0:
			anim.play("side_Idle")
	if dir == "down":
		anim.flip_h = true
		if direction == 1:
			anim.play("front_walk")
		elif direction == 0:
			anim.play("Idle")
	if dir == "up":
		anim.flip_h = true
		if direction == 1:
			anim.play("back_walk")
		elif direction == 0:
			anim.play("back_Idle")
		
