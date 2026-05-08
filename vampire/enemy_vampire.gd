extends CharacterBody2D

# STATS

@export var max_health: int = 60
@export var bullet_damage: int = 1
@export var bullet_speed: float = 200.0
@export var bullet_scene: PackedScene
@export var xp_reward: int = 30

# ESTADOS

var current_health: int
var player: Node2D = null
var can_shoot: bool = true
var is_shooting: bool = false
var can_take_damage: bool = true
var is_dead: bool = false
var is_hurt: bool = false
var current_suffix: String = "down"

# MAIN

func _ready() -> void:
	current_health = max_health
	$HealthBar/Bar.max_value = max_health
	$HealthBar/Bar.value = current_health
	print("[VAMPIRE] Inicializado. HP: ", current_health)

func _physics_process(_delta: float) -> void:
	if is_dead:
		return

	if is_hurt or is_shooting:   
		velocity = Vector2.ZERO
		return

	velocity = Vector2.ZERO

	if player:
		_update_direction_suffix()

	$AnimatedSprite2D.play("idle_" + current_suffix)

# DIRECCIÓN

func _update_direction_suffix() -> void:
	if player == null:
		return
	var diff = player.position - position
	if abs(diff.y) > abs(diff.x):
		current_suffix = "down" if diff.y > 0 else "up"
	else:
		current_suffix = "left" if diff.x < 0 else "right"

# AGGRO PLAYER

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		_update_direction_suffix() 
		_try_shoot()

func _on_detection_area_body_exited(body: Node2D) -> void:
	print("[VAMPIRE] detection_area body_exited: ", body.name)
	if body.is_in_group("player"):
		player = null
		print("[VAMPIRE] Jugador fuera de rango")

# SISTEMA DE COMBATE (vampiro → jugador)

func _try_shoot() -> void:
	if player == null or is_dead or is_hurt or not can_shoot:
		return
	can_shoot = false
	is_shooting = true
	$AnimatedSprite2D.play("attack_" + current_suffix)
	$attack_cooldown.start()

func _shoot() -> void:
	if player == null or bullet_scene == null:
		return
	var bullet = bullet_scene.instantiate()
	get_parent().add_child(bullet)
	bullet.global_position = $shoot_origin.global_position
	bullet.direction = (player.global_position - $shoot_origin.global_position).normalized()
	bullet.speed = bullet_speed
	bullet.damage = bullet_damage
	print("[VAMPIRE] Disparo lanzado")

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation.begins_with("attack_"):
		is_shooting = false
		_shoot()
		$attack_cooldown.start()
	elif $AnimatedSprite2D.animation.begins_with("hurt_"):
		is_hurt = false
		_resume_animation()

func _on_attack_cooldown_timeout() -> void:
	can_shoot = true
	_try_shoot()

func _resume_animation() -> void:
	$AnimatedSprite2D.play("idle_" + current_suffix)

# RECIBIR DAÑO (jugador → vampiro)

func take_damage(damage: int) -> void:
	if is_dead or not can_take_damage:
		return
	current_health = max(current_health - damage, 0)
	$HealthBar/Bar.value = current_health
	can_take_damage = false
	$take_damage_cooldown.start()
	if $AnimatedSprite2D.sprite_frames.has_animation("hurt_" + current_suffix):
		is_hurt = true
		$AnimatedSprite2D.play("hurt_" + current_suffix)
	print("[VAMPIRE] Recibe daño: -", damage, " | HP restante: ", current_health)
	if current_health <= 0:
		die()

func _on_take_damage_cooldown_timeout() -> void:
	can_take_damage = true
	if is_hurt:
		is_hurt = false
		_resume_animation()

# DEATH

func die() -> void:
	if is_dead:
		return
	is_dead = true
	velocity = Vector2.ZERO
	print("[VAMPIRE] Muerto")
	_drop_xp() 
	$AnimatedSprite2D.play("death")
	$death_anim_timer.start()

func _on_death_anim_timer_timeout() -> void:
	queue_free()
