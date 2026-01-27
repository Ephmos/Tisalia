extends CharacterBody2D

var speed = 40
var chase = false
var player = null


func _physics_process(delta):
	if chase:
		position += (player.position -position)/speed
		move_and_collide(Vector2(0,0)) 
		

func _on_detection_area_body_entered(body):
	player = body
	chase = true


func _on_detection_area_body_exited(body):
	player = null
	chase = false
	
