extends CharacterBody2D

var enemy_in_attack_range = false
var health = 160
var player_alive = true
var attack_ip = false
var is_dead = false


const speed = 150
var current_dir = "none"

func _ready():
	$AnimatedSprite2D.play("Idle")

func _physics_process(delta):
	if is_dead:
		return
		
	player_movement(delta)
	attack()
	
	if health <= 0:
		die() # cargar el menu o posible respawn	

	
func player_movement(_delta):
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
			if !attack_ip:
				anim.play("side_Idle")
	if dir == "left":
		anim.flip_h = true
		if direction == 1:
			anim.play("side_walk")
		elif direction == 0:
			if !attack_ip:
				anim.play("side_Idle")
	if dir == "down":
		anim.flip_h = true
		if direction == 1:
			anim.play("front_walk")
		elif direction == 0:
			if !attack_ip:
				anim.play("Idle")
	if dir == "up":
		anim.flip_h = true
		if direction == 1:
			anim.play("back_walk")
		elif direction == 0:
			if !attack_ip:
				anim.play("back_Idle")

func player():
	pass

func attack():
	if Input.is_action_just_pressed("attack"):
		global.player_current_attack = true
		attack_ip = true
		if current_dir =="right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("side_attack")
			$enemy_dmg.start()
		if current_dir =="left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("side_attack")
			$enemy_dmg.start()
		if current_dir == "up":
			$AnimatedSprite2D.play("back_attack")
			$enemy_dmg.start()
		if current_dir == "down" or current_dir == "none":
			$AnimatedSprite2D.play("front_attack")
			$enemy_dmg.start()
		
func take_damage(damage):
	if is_dead:
		return

	health -= damage
	print("Player health:", health)

	if health <= 0:
		die()

func _on_enemy_dmg_timeout():
	$enemy_dmg.stop()
	global.player_current_attack = false
	attack_ip = false

func die():
	is_dead = true
	player_alive = false
	health = 0
	print("Has muerto")
	$AnimatedSprite2D.play("death")
	$death_anim_timer.start()
	get_tree().change_scene_to_file("res://scenes/menu_scene.tscn")
	

func _on_death_anim_timer_timeout():
		queue_free()
