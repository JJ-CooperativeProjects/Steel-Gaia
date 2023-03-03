extends Sprite

signal RecibeDamage(cantidad,objetivo) 
signal RecibeDamageRoto(cantidad,objetivo)

export (int) var vitalidad:int  = 1000

var mi_padre:Ente

var puede_recibir_damage:bool = true
var destruido:bool = false

var posiciones:Array

func _ready():
	connect("RecibeDamage",self,"OnRecibeDamage")
	
	var nod:Node2D = get_node_or_null("posiciones_explosion")
	if nod:
		posiciones = nod.get_children()


func OnRecibeDamage(cantidad:float,quien:Node2D):
	puede_recibir_damage = false
	var efecto_parpadeo:EfectoTemporal = load("res://SISTEMA/EFECTOS/Usados/EfectoTemp_golpe_a_enemigo_self_modulate.tscn").instance()
	efecto_parpadeo.mi_objetivo = self
	add_child(efecto_parpadeo)
	
	if destruido:
		emit_signal("RecibeDamageRoto",cantidad,quien)
		return

	if vitalidad - cantidad <= 0:
		destruido = true
		texture = load("res://RECURSOS/IMAGENES/ENEMIGOS/DinoBoss/D-Moler_MechaSaurus_roto.png")
		emit_signal("RecibeDamageRoto",cantidad,quien)
		
		var efecto_pedazos:PackedScene = preload("res://SISTEMA/EFECTOS/ESPECIALES/Usados/EE_PedazosDino.tscn")
		
		var efecto = efecto_pedazos.instance()
		efecto.global_position = global_position
		Memoria.nivel_actual.add_child(efecto)
		for i in posiciones:
			var efecto1 = efecto_pedazos.instance()
			efecto1.global_position = i.global_position
			
			Memoria.nivel_actual.add_child(efecto1)
	else:
		vitalidad -= cantidad
		
		var efecto_golpe:EfectoEspecial = load("res://SISTEMA/EFECTOS/ESPECIALES/EfectoEspecial_golpe_escudo.tscn").instance()

		efecto_golpe.global_position = Memoria.jugador.get_node("Cuerpo/pos_golpes_pugnos").global_position
		
		Memoria.nivel_actual.add_child(efecto_golpe)

