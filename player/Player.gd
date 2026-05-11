extends CharacterBody2D

# DIRECCIÓN

@export_enum("Up", "Down", "Left", "Right")
var current_direction: String = "Down"

#STATS

@export var max_health: int = 30
@export var base_health: int = 30
@export var base_damage: int = 20

#CONSTANTES 

const max_level: int = 100
const xp_base: int = 100
const xp_exponent: float = 1.2
const health_multiplier: float = 1.2
const damage_multiplier: float = 1.2

#ESTADOS 

var alive: bool = true
var is_attacking: bool = false
var current_health: int = 30
var current_level: int = 1
var current_xp: int = 0
var xp_to_next_level: int = 100

# MAIN

func _ready() -> void:
	_recalculate_stats()
	current_health = max_health
	$SwordHitbox.monitoring = false
	_update_health_bar()
	_update_xp_bar()

func _process(_delta: float) -> void:
	if !alive:
		return

# SISTEMA DE ATAQUE (jugador → enemigo)

func start_attack() -> void:
	is_attacking = true
	$SwordHitbox.reset_hits()
	$SwordHitbox.monitoring = true

func end_attack() -> void:
	is_attacking = false
	$SwordHitbox.monitoring = false

# SISTEMA DE VIDA 

func take_damage(amount: int = 1) -> void:
	if not alive:
		return
	current_health = max(current_health - amount, 0)
	$HealthBar/Bar.value = current_health
	print("[PLAYER] Recibe daño: -", amount, " | HP restante: ", current_health)
	if current_health <= 0:
		alive = false
		print("[PLAYER] Muerto")
		$StateMachine.change_to("PlayerStateDeath")
		$Animations.play("Died" + current_direction)
		await $Animations.animation_finished
		#queue_free()
		#trigger animación de muerte del jugador
		#(creo que mejor aqui)

#cambiado para que si eres tonto tambien
#puedas desperdiciar pociones full vidaa
func heal(amount: int = 1) -> void:
	if not alive:
		return
	current_health = min(current_health + amount, max_health)
	print("[PLAYER] Curado: +", amount, " | HP actual: ", current_health)

# SISTEMA DE XP Y NIVELES

func gain_xp(amount: int) -> void:
	if current_level >= max_level:
		return
	current_xp += amount
	print("[PLAYER] +", amount, " XP | Total: ", current_xp, " / ", xp_to_next_level)
	_update_xp_bar()
	# para subir varios niveles de golpe si la XP es suficiente
	while current_xp >= xp_to_next_level and current_level < max_level:
		current_xp -= xp_to_next_level
		_level_up()

func _level_up() -> void:
	current_level += 1
	xp_to_next_level = _calculate_xp_for_level(current_level)
	_recalculate_stats()
	
	# Vida restaurada al subir de nivel
	current_health = max_health
	$HealthBar/Bar.max_value = max_health
	$HealthBar/Bar.value = current_health
	_update_xp_bar()
	print("[PLAYER] ¡LEVEL UP! Nivel: ", current_level," | HP: ", max_health," | Daño espada: ", $SwordHitbox.damage," | Próximo nivel: ", xp_to_next_level, " XP")

func _recalculate_stats() -> void:
	var factor: int = current_level - 1
	#pow es para hacer la potencia de algo
	max_health = int(base_health * pow(health_multiplier, factor))
	$SwordHitbox.damage = max(int(base_damage * pow(damage_multiplier, factor)), 1)

func _calculate_xp_for_level(level: int) -> int:
	return int(xp_base * pow(level, xp_exponent))

# ACTUALIZACIÓN DE BARRAS

func _update_health_bar() -> void:
	$HealthBar/Bar.max_value = max_health
	$HealthBar/Bar.value = current_health

func _update_xp_bar() -> void:
	$XpBar/Bar.max_value = xp_to_next_level
	$XpBar/Bar.value = current_xp
	if current_level >= max_level:
		$XpBar/Bar.value = $XpBar/Bar.max_value
