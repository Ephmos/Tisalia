extends StateBase

@export var animations: AnimationPlayer

func start():
	animations.play("Attacking" + controlled_node.current_direction)
	await animations.animation_finished
	state_machine.change_to("PlayerStateIdle")
