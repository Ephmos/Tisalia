extends StateBase

@export var animations: AnimationPlayer;
@export var actionable_finder: Area2D 

func on_physics_process(_delta):
	if Game.is_in_dialogue:
		return

	controlled_node.velocity = Vector2.ZERO
	animations.play("Idle" + controlled_node.current_direction)

func on_unhandled_input(_event):
	if Input.is_action_just_pressed("Interact"):
		var actionables = actionable_finder.get_overlapping_areas()
		if actionables.size() > 0:
			actionables[0].action()
			return

func on_input(_event):
	if Game.is_in_dialogue:
		return
	
	if Input.is_action_just_pressed("Attack"):
		state_machine.change_to("PlayerStateAttack")
		return
	elif Input.is_action_pressed("Down") \
	or Input.is_action_pressed("Up") \
	or Input.is_action_pressed("Left") \
	or Input.is_action_pressed("Right"):
		state_machine.change_to("PlayerStateWalk")
		return
