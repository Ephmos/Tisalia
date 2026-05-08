extends Control

func _ready() -> void:
	hide()

func resume_button_pressed() -> void:
	resume()

func exit_button_pressed() -> void:
	get_tree().quit()

func resume():
	get_tree().paused = false
	hide()
	
func pause():
	get_tree().paused = true
	show()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Pause") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("Pause") and get_tree().paused:
		resume()
