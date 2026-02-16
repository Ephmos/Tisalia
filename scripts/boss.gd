extends CharacterBody2D

var speed = 40
var chase = false
var player = null

var player_in_attack_zone = false
var health = 400
var can_take_damage = true
var is_dead = false
var is_attacking = false
var can_attack = true


func _physics_process(_delta):
	if is_dead:
		return
		
	enemy_damaged()
	if health <= 0:
		die()
		return
		
	if is_attacking:
		velocity = Vector2.ZERO
		return

	if chase:
		position += (player.position -position)/speed
		move_and_collide(Vector2(0,0))
		$AnimatedSprite2D.play("walk")
		
		if (player.position.x - position.x) < 0:	
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else :
		$AnimatedSprite2D.play("Idle")
		
	if player_in_attack_zone:
		attack()

func _on_detection_area_body_entered(body):
	player = body
	chase = true


func _on_detection_area_body_exited(_body):
	player = null
	chase = false

func  enemy():
	pass

func _on_boss_hitbox_body_entered(body):
	if body.has_method("player"):
		player_in_attack_zone = true
	
func _on_boss_hitbox_body_exited(body):
	if body.has_method("player"):
		player_in_attack_zone = false
	

func enemy_damaged():
	if player_in_attack_zone and global.player_current_attack:
		if can_take_damage:
			health -= 20
			$take_damage_cooldown.start()
			can_take_damage = false
			print("plant health: ", health)
			


func _on_take_damage_cooldown_timeout():
	can_take_damage = true


func _on_death_anim_timer_timeout():
	self.queue_free()	

func die():
	is_dead = true
	velocity = Vector2.ZERO

	$AnimatedSprite2D.play("death")
	$death_anim_timer.start()
	
func attack():
	if is_attacking or is_dead or !can_attack:
		return

	is_attacking = true
	can_attack = false
	velocity = Vector2.ZERO
	$AnimatedSprite2D.play("attack")
	$deal_dmg.start()

func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "attack":
		if chase:
			$AnimatedSprite2D.play("walk")
		else:
			$AnimatedSprite2D.play("Idle")


func _on_deal_dmg_timeout():
	is_attacking = false
	can_attack = true
	if player_in_attack_zone:
		dealDmgToPlayer(20) 

	if chase:
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("Idle")
		
func dealDmgToPlayer(damage):
	if player.has_method("take_damage"):
		player.take_damage(damage)
	
