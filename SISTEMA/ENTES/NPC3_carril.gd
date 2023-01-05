extends Path2D
class_name Carril
"""
CLASE ESPECIAL QUE SE ENCARGA DE CREAR UN CARRIL PARA LAS ARAÑAS: NPC3
"""

onready var pathf:PathFollow2D = $PathFollow2D
onready var npc:Ente = $PathFollow2D.get_child(0)

export (float) var tiempo_min_caminar:float = 1.0 
export (float) var tiempo_max_caminar:float = 6.0
func _ready():
	npc.connect("RecibeDamage",$MEF,"LogicaMorir")
	pass

