extends MEF_base
"""
NPC 2
"""

onready var ente:Enemigo = owner
onready var anim:AnimationPlayer = ente.get_node("Viewport/control_base2/AnimationPlayer")


func _ready():
	_agregar_estado("quieto")
	
	poner_estado_deferred("quieto")

func _physics_process(delta):
	pass

#Logica para cambiar de estados:
func _transiciones(delta):
	return null
#Se ejecuta dentro de un estado constantemente.
func _process_estado(delta):
	pass
#Solo se ejecuta una vez cuando entra en un nuevo estado
func _entrar_estado(nuevo, viejo):
	match nuevo:
		estados.quieto:
			anim.play("Walk V2")
	pass
#Solo se ejecuta una vez cuando sale de un estado.
func _salir_estado(viejo, nuevo):
	pass
