extends Sprite

signal RecibeDamage(cantidad) 

export (int) var vitalidad:int  = 1000

var mi_padre:Ente

var puede_recibir_damage:bool = true

func _ready():
	connect("RecibeDamage",self,"OnRecibeDamage")
	
	


func OnRecibeDamage(cantidad:float):
	#print(name + ": ha recibido daño!")
	vitalidad -= cantidad
	
	puede_recibir_damage = false
	var efecto_parpadeo:EfectoTemporal = load("res://SISTEMA/EFECTOS/Usados/EfectoTemp_golpe_a_enemigo_self_modulate.tscn").instance()
	efecto_parpadeo.mi_objetivo = self
	add_child(efecto_parpadeo)
	
	pass
