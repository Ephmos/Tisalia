extends Area2D

# Velocidad y daño configurables desde el vampiro al instanciar
var speed: float = 200.0
var damage: int = 1
var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	if $AnimatedSprite2D.sprite_frames == null:
		push_error("[BULLET] SpriteFrames no asignado en el editor")
		return
	if abs(direction.y) > abs(direction.x):
		$AnimatedSprite2D.play("down" if direction.y > 0 else "up")
	else:
		$AnimatedSprite2D.play("right" if direction.x > 0 else "left")

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		return
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
