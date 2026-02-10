extends Node2D

func _ready():
	if global.new_game:
		$player.position.x = global.player_start_posx
		$player.position.y = global.player_start_posy
	else:
		$player.position.x = global.player_exit_map_2_posx
		$player.position.y = global.player_exit_map_2_posy
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_cliffside_transition_point_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		global.current_scene = "map_2"
		global.new_game = false

		get_tree().call_deferred("change_scene_to_file", "res://scenes/map_2.tscn")


func _on_cliffside_transition_point_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		global.transition_scene = false
		
func change_scene():
	if global.transition_scene:
		get_tree().change_scene_to_file("res://scenes/map_2.tscn")
		global.current_scene = "map_2"
		global.new_game = false
		global.transition_scene = false
