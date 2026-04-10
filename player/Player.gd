extends CharacterBody2D

@export_enum("Up", "Down", "Left", "Right")
var current_direction: String = "Down"
signal life_changed(player_hearts)
var max_hearts : int = 2
var hearts : float = max_hearts

func damage(damage : int, direcction : int, force : int):
	hearts -= damage *0.5
	emit_signal("life_changed", hearts)
	#if hearts <=0:
		#llamar a die
func _ready() -> void:
	life_changed.connect(get_node("../UI/Life").on_player_life_changed)
	emit_signal("life_changed",max_hearts)
