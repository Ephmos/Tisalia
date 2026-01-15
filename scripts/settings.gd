extends Control

@onready var audio_server: Object = AudioServer
@onready var menu_music: AudioStreamPlayer = MenuMusic

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu_scene.tscn")

# Actualizar el valor del slider, al que el bus tiene en el momento actual
func _ready() -> void:
	var hslider_music: HSlider = $VBoxContainer/Music
	var hslider_volume: HSlider = $VBoxContainer/Volume
	hslider_music.set_value_no_signal(audio_server.get_bus_volume_db(audio_server.get_bus_index("Music")))
	hslider_volume.set_value_no_signal(audio_server.get_bus_volume_db(audio_server.get_bus_index("SFX")))
	
# Controla que al cambiar el slider al valor mínimo la música se detenga y el bus que la maneja se silencie.
func _on_music_value_changed(volume: float) -> void:
	if volume == -1.0:
		menu_music.stream_paused = true
		audio_server.set_bus_mute(audio_server.get_bus_index("Music"), true)
		audio_server.set_bus_volume_db(audio_server.get_bus_index("Music"), -1.0)
	else:
		menu_music.stream_paused = false
		audio_server.set_bus_mute(audio_server.get_bus_index("Music"), false)
		audio_server.set_bus_volume_db(audio_server.get_bus_index("Music"), volume)

# Controla que al cambiar el slider al valor mínimo el volúmen se detenga y el bus que la maneja se silencie.
func _on_volume_value_changed(volume: float) -> void:
	if volume == -1.0:
		audio_server.set_bus_mute(audio_server.get_bus_index("SFX"), true)
		audio_server.set_bus_volume_db(audio_server.get_bus_index("SFX"), -1.0)
	else:
		audio_server.set_bus_mute(audio_server.get_bus_index("SFX"), false)
		audio_server.set_bus_volume_db(audio_server.get_bus_index("SFX"), volume)
