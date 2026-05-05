extends Area2D

# STATS

@export var speed: float = 200.0
@export var damage: int = 1

# ESTADOS

var direction: Vector2 = Vector2.ZERO

# MAIN

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

# IMPACTO (bala → jugador)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("[BULLET] Impacto con: ", body.name)
		body.take_damage(damage)
		queue_free()

# FUERA DE PANTALLA

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
