extends Node2D

# CONFIG

@export var disappear_delay: float = 2.0
@export var damage_multiplier: float = 1.5

# ESTADOS

var show_area: bool = false
var is_active: bool = false
var is_buffed: bool = false
var player_inside: Node2D = null

# MAIN

func _ready() -> void:
	$AnimatedSprite2D.visible = false
	$BuffArea.visible = false
	$AnimatedSprite2D.animation_finished.connect(_on_animation_finished)

# ÁREA — detecta al jugador

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not is_active:
		player_inside = body
		_activate()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		_remove_buff()
		player_inside = null

# CICLO DEL TÓTEM

func _activate() -> void:
	is_active = true
	$AnimatedSprite2D.visible = true
	show_area = true
	queue_redraw()
	$AnimatedSprite2D.play("appear")
	print("[BUFF TOTEM] Activado")

func _apply_buff() -> void:
	if player_inside == null or is_buffed:
		return
	is_buffed = true
	player_inside.get_node("SwordHitbox").damage = int(player_inside.get_node("SwordHitbox").damage * damage_multiplier)
	print("[BUFF TOTEM] Daño buffado a: ", player_inside.get_node("SwordHitbox").damage)

func _remove_buff() -> void:
	if player_inside == null or not is_buffed:
		return
	is_buffed = false
	player_inside.get_node("SwordHitbox").damage = int(player_inside.get_node("SwordHitbox").damage / damage_multiplier)
	print("[BUFF TOTEM] Daño revertido a: ", player_inside.get_node("SwordHitbox").damage)

func _deactivate() -> void:
	$AnimatedSprite2D.play("disappear")
	show_area = false
	queue_redraw()
	print("[BUFF TOTEM] Desactivándose")

func _on_buff_timer_timeout() -> void:
	if player_inside != null:
		$BuffTimer.start()
	else:
		_deactivate()

func _on_animation_finished() -> void:
	match $AnimatedSprite2D.animation:
		"appear":
			$AnimatedSprite2D.play("buff")
			_apply_buff()
			$BuffTimer.start()
		"buff":
			pass
		"disappear":
			$AnimatedSprite2D.visible = false
			is_active = false

# ÁREA VISUAL

func _draw() -> void:
	if show_area:
		draw_circle(Vector2.ZERO, $Area2D/CollisionShape2D.shape.radius, Color(0.794, 0.188, 1.0, 0.235))
