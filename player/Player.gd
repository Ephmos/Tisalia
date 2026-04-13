extends CharacterBody2D

# Implementado por David Kallimoulline y Javier Jaén
# 12/04/2026 - Se debe separar en diferentes scripts y sumar funcionalidad, por ahora se mantiene así con propósitos
# funcionales, no modificar hasta haber realizado la primera 2da entrega
@export_enum("Up", "Down", "Left", "Right")
var current_direction: String = "Down"
var alive : bool = true
var hearts : Array[TextureRect]
var health = 3

func _ready() -> void:
	var hearts_parent = $"../../HealthBar/HBoxContainer"
	for child in hearts_parent.get_children():
		hearts.append(child)
			
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Test"):
		take_damage()
		
	if Input.is_action_just_pressed("Test2"):
		heal()
			
func take_damage():
	if health > 0:
		health -= 1
		update_heart_display()	
	
func heal():
	if (health < 3):
		health += 1
		update_heart_display()
	
func update_heart_display():
	for i in range(hearts.size()):
		hearts[i].visible = i < health
		
	if health <= 0:
		alive = false
