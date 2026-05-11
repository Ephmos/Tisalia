extends Node2D

# CONFIG

@export var disappear_delay: float = 2.0
@export var max_potions: int = 3    
var show_area: bool = false

# ESTADOS

var is_active: bool = false
var player_inside: Node2D = null

# MAIN

func _ready() -> void:
	$AnimatedSprite2D.visible = false
	$HealArea.visible = false 
	$AnimatedSprite2D.animation_finished.connect(_on_animation_finished)

# ÁREA — detecta al jugador

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not is_active:
		player_inside = body
		_activate()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inside = null

# CICLO DEL TÓTEM

func _activate() -> void:
	is_active = true
	$AnimatedSprite2D.visible = true
	show_area = true
	queue_redraw()
	$AnimatedSprite2D.play("appear")
	print("[TOTEM] Activado")

func _heal_player() -> void:
	if player_inside == null:
		return
	if player_inside.has_method("heal"):
		player_inside.heal(player_inside.max_health)
		#LOGICA POCIONES
	#if player_inside.has_method("refill_potions"):
	#	player_inside.refill_potions(max_potions)
	#print("[TOTEM] Jugador curado y pociones recargadas")

func _deactivate() -> void:
	$AnimatedSprite2D.play("disappear")
	show_area = false
	queue_redraw()
	print("[TOTEM] Desactivándose")

func _on_heal_timer_timeout() -> void:
	if player_inside != null:
		$HealTimer.start()
	else:
		_deactivate()

func _on_animation_finished() -> void:
	match $AnimatedSprite2D.animation:
		"appear":
			$AnimatedSprite2D.play("heal")
			_heal_player()
			$HealTimer.start()
		"heal":
			pass  
		"disappear":
			$AnimatedSprite2D.visible = false
			is_active = false

func _draw() -> void:
	if show_area:
		draw_circle(Vector2.ZERO, $Area2D/CollisionShape2D.shape.radius, Color(0.3, 0.9, 0.3, 0.15))
