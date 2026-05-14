extends Node2D

@onready var gold_label: Label = $GoldLabel
@onready var gold_icon: Sprite2D = $GoldIcon

func setup(amount: int, spawn_position: Vector2) -> void:
	global_position = spawn_position
	gold_label.text = "+%d" % amount
	gold_icon.texture = load("res://sprites/coins.png")
	_play_animation()

func _play_animation() -> void:
	# Valores iniciales
	modulate.a = 1.0
	scale = Vector2(0.5, 0.5)

	var tween = create_tween()
	tween.set_parallel(true)

	# Sube ligeramente hacia arriba
	tween.tween_property(self, "global_position:y", global_position.y - 40, 0.8)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_QUAD)

	# Aparece con un pop de escala
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.2)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_BACK)

	# Se desvanece al final
	tween.tween_property(self, "modulate:a", 0.0, 0.8)\
		.set_ease(Tween.EASE_IN)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_delay(0.3)

	# Se destruye al terminar
	tween.chain().tween_callback(queue_free)
