extends CharacterBody2D

# STATS

@export var speed: float = 40.0
@export var max_health: int = 200
@export var attack_damage: int = 1

# ESTADOS

var current_health: int
var chase: bool = false
var player: Node2D = null
var player_in_attack_zone: bool = false
var can_take_damage: bool = true
var is_dead: bool = false
var is_attacking: bool = false
var can_attack: bool = true
var current_suffix: String = "down"
var is_hurt: bool = false

# MAIN

func _ready() -> void:
	current_health = max_health
	$HealthBar/Bar.max_value = max_health
	$HealthBar/Bar.value = current_health
	print("[BOSS] Inicializado. HP: ", current_health)

func _physics_process(_delta: float) -> void:
	if is_dead:
		return

	if is_hurt:
		velocity = Vector2.ZERO
		return

	if is_attacking:
		velocity = Vector2.ZERO
		return

	if chase and player:
		_update_direction_suffix()
		_move_towards_player()
	else:
		velocity = Vector2.ZERO
		$AnimatedSprite2D.play("idle_" + current_suffix)

	if player_in_attack_zone:
		attack()

func _move_towards_player() -> void:
	position += (player.position - position) / speed
	move_and_slide()
	$AnimatedSprite2D.play("walk_" + current_suffix)

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
	print("[BOSS] detection_area body_entered: ", body.name, " | en grupo player: ", body.is_in_group("player"))
	if body.is_in_group("player"):
		player = body
		chase = true
		print("[BOSS] Chase activado")

func _on_detection_area_body_exited(body: Node2D) -> void:
	print("[BOSS] detection_area body_exited: ", body.name)
	if body.is_in_group("player"):
		player = null
		chase = false
		print("[BOSS] Chase desactivado")

# HITBOX DE ATAQUE (boss → jugador)

func _on_boss_hitbox_body_entered(body: Node2D) -> void:
	print("[BOSS] hitbox body_entered: ", body.name, " | en grupo player: ", body.is_in_group("player"))
	if body.is_in_group("player"):
		player_in_attack_zone = true

func _on_boss_hitbox_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_attack_zone = false

# LÓGICA DE ATAQUE BOSS

func attack() -> void:
	if is_attacking or is_dead or not can_attack:
		return
	is_attacking = true
	can_attack = false
	velocity = Vector2.ZERO
	$AnimatedSprite2D.play("attack_" + current_suffix)
	$deal_dmg.start()

func _on_deal_dmg_timeout() -> void:
	is_attacking = false
	can_attack = true
	if player_in_attack_zone and player:
		_deal_damage_to_player(attack_damage)
	_resume_animation()

func _deal_damage_to_player(damage: int) -> void:
	if player and player.has_method("take_damage"):
		print("[BOSS] Atacando al jugador. Daño: ", damage)
		player.take_damage(damage)	

func _resume_animation() -> void:
	if chase:
		$AnimatedSprite2D.play("walk_" + current_suffix)
	else:
		$AnimatedSprite2D.play("idle_" + current_suffix)

# RECIBIR DAÑO (jugador → boss)

func take_damage(damage: int) -> void:
	if is_dead or not can_take_damage:
		return
	current_health = max(current_health - damage, 0)
	$HealthBar/Bar.value = current_health
	can_take_damage = false
	is_hurt = true
	$take_damage_cooldown.start()
	$AnimatedSprite2D.play("hurt_" + current_suffix)
	print("[BOSS] Recibe daño: -", damage, " | HP restante: ", current_health)
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
	print("[BOSS] Muerto")
	$AnimatedSprite2D.play("death")
	$death_anim_timer.start()

func _on_death_anim_timer_timeout() -> void:
	queue_free()

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation.begins_with("attack_"):
		_resume_animation()
	elif $AnimatedSprite2D.animation.begins_with("hurt_"):
		is_hurt = false
		_resume_animation()
