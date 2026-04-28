extends CharacterBody2D

# STATS

@export var speed: float = 40.0
@export var max_health: int = 100
@export var attack_damage: int = 20

# ESTADOS

var health: int
var chase: bool = false
var player: Node2D = null
var player_in_attack_zone: bool = false
var can_take_damage: bool = true
var is_dead: bool = false
var is_attacking: bool = false
var can_attack: bool = true

# MAIN

func _ready() -> void:
	health = max_health

func _physics_process(_delta: float) -> void:
	if is_dead:
		return

	if is_attacking:
		velocity = Vector2.ZERO
		return

	if chase and player:
		_move_towards_player()
	else:
		$AnimatedSprite2D.play("Idle")

	if player_in_attack_zone:
		attack()

func _move_towards_player() -> void:
	position += (player.position - position) / speed
	move_and_collide(Vector2.ZERO)
	$AnimatedSprite2D.play("walk")
	$AnimatedSprite2D.flip_h = (player.position.x - position.x) < 0

# AGGRO PLAYER

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		chase = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = null
		chase = false

# HITBOX DE ATAQUE (enemigo → jugador)

func _on_enemy_plant_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_attack_zone = true

func _on_enemy_plant_hitbox_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_attack_zone = false

# LÓGICA DE ATAQUE PLANTA

func attack() -> void:
	if is_attacking or is_dead or not can_attack:
		return
	is_attacking = true
	can_attack = false
	velocity = Vector2.ZERO
	$AnimatedSprite2D.play("attack")
	$deal_dmg.start()

func _on_deal_dmg_timeout() -> void:
	is_attacking = false
	can_attack = true
	if player_in_attack_zone and player:
		_deal_damage_to_player(attack_damage)
	_resume_animation()

func _deal_damage_to_player(damage: int) -> void:
	if player and player.has_method("take_damage"):
		player.take_damage(damage)

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "attack":
		_resume_animation()

func _resume_animation() -> void:
	if chase:
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("Idle")

# RECIBIR DAÑO (jugador → enemigo)═

func take_damage(damage: int) -> void:
	if is_dead or not can_take_damage:
		return
	health = max(health - damage, 0)
	can_take_damage = false
	$take_damage_cooldo.start()
	if health <= 0:
		die()

func _on_take_damage_cooldown_timeout() -> void:
	can_take_damage = true

# DEATH

func die() -> void:
	if is_dead:
		return
	is_dead = true
	velocity = Vector2.ZERO
	$AnimatedSprite2D.play("death")
	$death_anim_timer.start()

func _on_death_anim_timer_timeout() -> void:
	queue_free()
