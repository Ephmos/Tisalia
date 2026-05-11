extends CharacterBody2D

# STATS

@export var max_health: int = 30
@export var xp_reward: int = 10
@export var speed: float = 40.0
@export var scared_speed: float = 90.0

# ESTADOS

var current_health: int
var is_dead: bool = false
var is_scared: bool = false

# MOVIMIENTO

var current_direction: Vector2 = Vector2.ZERO
var is_resting: bool = false
var current_suffix: String = "down"

func _pick_random_direction() -> void:
	var angle = randf() * TAU
	current_direction = Vector2(cos(angle), sin(angle))
	_update_animation()

func _update_animation() -> void:
	var anim_prefix = "idle" if is_resting else "walk"
	if abs(current_direction.x) > abs(current_direction.y):
		current_suffix = "right"
		$AnimatedSprite2D.flip_h = current_direction.x < 0 
	else:
		current_suffix = "down" if current_direction.y > 0 else "up"
		$AnimatedSprite2D.flip_h = false
	$AnimatedSprite2D.play(anim_prefix + "_" + current_suffix)

# MAIN

func _ready() -> void:
	current_health = max_health
	$HealthBar/Bar.max_value = max_health
	$HealthBar/Bar.value = current_health
	_pick_random_direction()
	$MoveTimer.wait_time = 2.0
	$MoveTimer.start()
	print("[RAT] Inicializada. HP: ", current_health)

func _physics_process(_delta: float) -> void:
	if is_dead:
		return
	velocity = current_direction * (scared_speed if is_scared else speed)
	move_and_slide()

# MOVIMIENTO ALEATORIO

func _on_move_timer_timeout() -> void:
	if is_scared:
		_pick_random_direction()
		$MoveTimer.wait_time = 1.0
		$MoveTimer.start()
	elif is_resting:
		is_resting = false
		_pick_random_direction()
		$MoveTimer.wait_time = 2.0
		$MoveTimer.start()
	else:
		is_resting = true
		current_direction = Vector2.ZERO
		_update_animation()
		$MoveTimer.wait_time = 1.0
		$MoveTimer.start()

# RECIBIR DAÑO

func take_damage(damage: int) -> void:
	if is_dead:
		return
	current_health = max(current_health - damage, 0)
	$HealthBar/Bar.value = current_health
	print("[RAT] Recibe daño: -", damage, " | HP restante: ", current_health)
	if not is_scared:
		_start_fleeing()
	if current_health <= 0:
		die()

 #HUIR

func _start_fleeing() -> void:
	is_scared = true
	is_resting = false
	_pick_random_direction()
	$MoveTimer.wait_time = 1.0
	$MoveTimer.start()
	print("[RAT] ¡Huyendo!")

# MUERTE

func die() -> void:
	if is_dead:
		return
	is_dead = true
	velocity = Vector2.ZERO
	current_direction = Vector2.ZERO
	$MoveTimer.stop()
	_drop_xp()
	#FALTA ANIM MUERTE
	$DeathTimer.start()
	print("[RAT] Muerta")

func _drop_xp() -> void:
	var player_node = get_tree().get_first_node_in_group("player")
	if player_node:
		player_node.gain_xp(xp_reward)
		print("[RAT] XP entregada al jugador: ", xp_reward)

func _on_death_timer_timeout() -> void:
	queue_free()
