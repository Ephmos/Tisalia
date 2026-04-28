extends Area2D

#swing = ataque en curso

@export var damage: int = 20
var _already_hit: Array = []  
# para que no pegue perma almacena los bodys 
# que ya han recibido daño

# Vacía la lista para que el nuevo swing empiece limpio
func reset_hits() -> void:
	_already_hit.clear()


func on_body_entered(body: Node2D) -> void:
	if body in _already_hit:
		return
	if body.has_method("take_damage"):
		# Registramos el cuerpo como ya golpeado en este swing
		_already_hit.append(body)
		body.take_damage(damage)
