extends Node2D
 
func _process(_delta):
	pass

func _on_map_2_exitpoint_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		global.player_exit_map_2_posx = 20
		global.player_exit_map_2_posy = 329
		global.new_game = false
		global.current_scene = "world"

		get_tree().call_deferred("change_scene_to_file", "res://scenes/world.tscn")


func _on_map_2_exitpoint_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		global.player_exit_map_2_posx = 20
		global.player_exit_map_2_posy = 329
		global.new_game = false
		global.current_scene = "world"

		get_tree().call_deferred("change_scene_to_file", "res://scenes/world.tscn")
		
func change_scene():
	if global.transition_scene:
		get_tree().change_scene_to_file("res://scenes/world.tscn")
		global.current_scene = "world"
		global.transition_scene = false


func _on_predilection_cave_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_predilection_cave_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
