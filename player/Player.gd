extends CharacterBody2D

# DIRECCIÓN

@export_enum("Up", "Down", "Left", "Right")
var current_direction: String = "Down"

#STATS

var max_health: int = 3

#ESTADOS 

var alive: bool = true
var health: int = 3
var is_attacking: bool = false
var hearts: Array[TextureRect]

# MAIN

@export var hearts_parent: Node

func _ready() -> void:
	$SwordHitbox.monitoring = false
	if hearts_parent == null:
		push_warning("Player: hearts_parent no asignado en el Inspector")
		return
	for child in hearts_parent.get_children():
		hearts.append(child)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Test"):
		take_damage()
		#
	if Input.is_action_just_pressed("Test2"):
		heal()

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
	health = max(health - amount, 0)
	print("[PLAYER] Recibe daño: -", amount, " | HP restante: ", health)
	update_heart_display()
	if health <= 0:
		alive = false
		print("[PLAYER] Muerto")
		queue_free()
		#trigger animación de muerte del jugador
		#(creo que mejor aqui)

#cambiado para que si eres tonto tambien
#puedas desperdiciar pociones full vidaa
func heal(amount: int = 1) -> void:
	if not alive:
		return
	health = min(health + amount, max_health)
	print("[PLAYER] Curado: +", amount, " | HP actual: ", health)
	update_heart_display()

func update_heart_display() -> void:
	for i in range(hearts.size()):
		hearts[i].visible = i < health
