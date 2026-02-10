extends Node
var player_current_attack = false 
var current_scene ="world" 
var transition_scene = false 
var player_exit_map_2_posx = 1136 
var player_exit_map_2_posy = 323.0 
var player_start_posx = 943.0 
var player_start_posy = 327.0 
var new_game = true 

func finish_changescene(): 
	if transition_scene: 
		transition_scene = false 
		if current_scene == "world": 
			current_scene = "map_2" 
		else: 
			current_scene ="world"
