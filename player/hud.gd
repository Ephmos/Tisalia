extends CanvasLayer

@onready var gold_label: Label = $HBoxContainer/GoldLabel
@onready var gold_icon: TextureRect = $HBoxContainer/GoldIcon

func _ready() -> void:
	Events.gold_updated.connect(_on_gold_updated)
	gold_icon.texture = load("res://sprites/coins.png")
	gold_label.text = "0"

func _on_gold_updated(total_gold: int) -> void:
	gold_label.text = str(total_gold)
	var tween = create_tween()
	tween.tween_property(gold_label, "scale", Vector2(1.3, 1.3), 0.1)
	#tween.tween_property(gold_label, "scale", Vector2(1.0, 1.0), 0.1)
