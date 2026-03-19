extends StateBase

@export var movement_speed : float = 70
@export var animations: AnimationPlayer
@export var actionable_finder: Area2D 
var character_direction : Vector2

func on_physics_process(_delta):
	if Game.is_in_dialogue:
		return
		
	character_direction.x = Input.get_axis("Left", "Right")
	character_direction.y = Input.get_axis("Up", "Down")
	
	if character_direction:
		controlled_node.velocity = character_direction * movement_speed
	else:
		controlled_node.velocity = controlled_node.velocity.move_toward(Vector2.ZERO, movement_speed)

	if controlled_node.velocity == Vector2.ZERO:
		state_machine.change_to("PlayerStateIdle")
		return
		
	if abs(character_direction.x) > abs(character_direction.y):
		if character_direction.x > 0:
			controlled_node.current_direction = "Right"
			movement_speed = 70
			animations.play("WalkingRight")
		else:
			controlled_node.current_direction = "Left"
			movement_speed = 70
			animations.play("WalkingLeft")
	else:
		if character_direction.y > 0:
			controlled_node.current_direction = "Down"
			movement_speed = 70
			animations.play("WalkingDown")
		else:
			controlled_node.current_direction = "Up"
			movement_speed = 70
			animations.play("WalkingUp")
		
	controlled_node.move_and_slide()
	
func on_unhandled_input(_event):
	if Input.is_action_just_pressed("Interact"):
		var actionables = actionable_finder.get_overlapping_areas()
		if actionables.size() > 0:
			var obj = actionables[0]
			obj.action()
			return
	
func on_input(_event):
	if Game.is_in_dialogue:
		return
	
	if Input.is_action_just_pressed("Attack"): #and Game.weapons_withdraw:
		controlled_node.velocity = Vector2.ZERO
		state_machine.change_to("PlayerStateAttack")
		return
