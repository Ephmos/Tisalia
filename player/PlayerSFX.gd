extends AudioStreamPlayer2D

var sword_slash_sfx = preload("res://audio/SwordSlash.wav")

func play_sword_slash_sfx():
	stream = sword_slash_sfx
	pitch_scale = randf_range(0.95, 1.05)
	volume_db = randf_range(-1.5, 0.0)
	play()
