extends StateBase

@export var animations: AnimationPlayer

func start():
	controlled_node.start_attack()  
	# Activa SwordHitbox
	animations.play("Attacking" + controlled_node.current_direction)
	await animations.animation_finished
	controlled_node.end_attack()    
	# Desactiva SwordHitbox
	state_machine.change_to("PlayerStateIdle")
