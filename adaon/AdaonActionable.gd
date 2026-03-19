extends Area2D

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

func action() -> void:
	Game.is_in_dialogue = true
	DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start)
	await DialogueManager.dialogue_ended
	Game.is_in_dialogue = false
