extends Area2D
class_name AreaDamage
"""
BASE PARA CONSTRUIR AREAS DE DAÑO.
"""
var objetivo:Ente = null
export (float) var damage:float = 10

func _on_AreaDamage_body_entered(body):
	if objetivo!= null:
		damage = objetivo.damage
	
	if body is Escudo:
		body.emit_signal("es_golpeado")
		#print("hit escudo")
		return
		
	
	if body is Ente:
		if body.puede_recibir_damage == true:
			body.emit_signal("RecibeDamage",damage)
	
	set_deferred("monitoring",false)
	pass # Replace with function body.


func _on_AreaDamage_area_entered(area): 
	area.recibe_damage(damage)
	pass # Replace with function body.
