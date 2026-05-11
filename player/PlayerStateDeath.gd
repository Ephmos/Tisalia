extends StateBase

@export var animations: AnimationPlayer

func start():
	animations.play("Died" + controlled_node.current_direction)
	await animations.animation_finished
