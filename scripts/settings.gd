extends Control

@onready var audio_server: Object = AudioServer
@onready var menu_music: AudioStreamPlayer = MenuMusic
@onready var fpscap_button: CheckButton = $"ParentContainer/GraphicsContainer/FPSCap"
@onready var fullscreen_button: CheckButton = $"ParentContainer/GraphicsContainer/Fullscreen"

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu_scene.tscn")

# Actualiza el estado del botón, dependiendo de si el juego está en pantalla completa o no.
func update_fullscreen_selector(button: CheckButton) -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		button.button_pressed = true
	else:
		button.button_pressed = false

# Actualiza el estado del botón, dependiendo de si el bloqueo de 60 FPS está activado o no
func update_fps_cap_selector(button: CheckButton) -> void:
	if Engine.max_fps == 60:
		button.button_pressed = true
	else:
		button.button_pressed = false
		
# Actualiza el valor de los sliders de volúmen, para que estén sincronizados con sus respectivos buses de audio.
func update_volume_slider(slider: HSlider, bus: String):
	slider.set_value_no_signal(audio_server.get_bus_volume_db(audio_server.get_bus_index(bus)))

func _ready() -> void:
	var hsliders: Dictionary[String, HSlider] = {
			hslider_master = $ParentContainer/SoundContainer/Master,
			hslider_music = $ParentContainer/SoundContainer/Music,
			hslider_volume = $ParentContainer/SoundContainer/Volume}
	
	var audio_buses: Dictionary[String, String] = {
			Master = "Master",
			Music = "Music",
			SFX = "SFX"}
			
	update_fps_cap_selector(fpscap_button)
	update_fullscreen_selector(fullscreen_button)
	update_volume_slider(hsliders["hslider_master"], audio_buses["Master"])
	update_volume_slider(hsliders["hslider_music"], audio_buses["Music"])
	update_volume_slider(hsliders["hslider_volume"], audio_buses["SFX"])
	
func _on_master_value_changed(volume: float) -> void:
	audio_server.set_bus_volume_db(audio_server.get_bus_index("Master"), volume)
	if volume == -5.0:
		audio_server.set_bus_mute(audio_server.get_bus_index("Master"), true)
	else:
		audio_server.set_bus_mute(audio_server.get_bus_index("Master"), false)
		
# Controla que al cambiar el slider al valor mínimo el volúmen se detenga y el bus que la maneja se silencie.
func _on_volume_value_changed(volume: float) -> void:
	audio_server.set_bus_volume_db(audio_server.get_bus_index("SFX"), volume)
	if volume == -1.0:
		audio_server.set_bus_mute(audio_server.get_bus_index("SFX"), true)
	else:
		audio_server.set_bus_mute(audio_server.get_bus_index("SFX"), false)
		
# Controla que al cambiar el slider al valor mínimo la música se detenga y el bus que la maneja se silencie.
func _on_music_value_changed(volume: float) -> void:
	audio_server.set_bus_volume_db(audio_server.get_bus_index("Music"), volume)
	if volume == -1.0:
		menu_music.stream_paused = true
		audio_server.set_bus_mute(audio_server.get_bus_index("Music"), true)
	else:
		menu_music.stream_paused = false
		audio_server.set_bus_mute(audio_server.get_bus_index("Music"), false)
	
# Controla en qué modo está el juego (ventana o pantalla completa)
func _on_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		await get_tree().create_timer(0.1).timeout
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		await get_tree().create_timer(0.1).timeout
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_MAXIMIZE_DISABLED, true)
		get_window().size = Vector2(1280, 720)
		
func _on_fps_cap_toggled(toggled_on: bool) -> void:
	if toggled_on:
		await get_tree().create_timer(0.1).timeout
		Engine.max_fps = 60
	else:
		await get_tree().create_timer(0.1).timeout
		Engine.max_fps = 0
