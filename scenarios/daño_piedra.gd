extends Area2D

@export var damage: int = 10
@export var tick_rate: float = 1.0

var enemy_inside: Node2D = null

func _ready() -> void:
	$DamageTick.wait_time = tick_rate
	$DamageTick.start()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		enemy_inside = body

func _on_body_exited(body: Node2D) -> void:
	if body == enemy_inside:
		enemy_inside = null

func _on_damage_tick_timeout() -> void:
	if is_instance_valid(enemy_inside):
		enemy_inside.take_damage(damage)
