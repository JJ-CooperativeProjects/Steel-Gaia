extends Ente
class_name Enemigo
"""
CLASE QUE DEFINE UNA ENTIDAD BASE PARA CONSTRUIR ENEMIGOS.
"""
signal es_destruido()

onready var explosion_morir:PackedScene = preload("res://SISTEMA/EFECTOS/ESPECIALES/Explosion_muerte_NPC.tscn")

export (Array,String,FILE, "*.tscn") var posibles_objetos_soltar:Array = []


func Girar():
	$Cuerpo.scale.x *= -1
	direccion_mira = $Cuerpo.scale.x

func MirarObjetivo(objetivo):
	if is_instance_valid(objetivo):
		match direccion_mira:
			1:
				if objetivo.global_position.x < global_position.x:
					Girar()
					return

			-1:
				if objetivo.global_position.x > global_position.x:
					Girar()
					return
				pass
	
#Meteto pensado para sobrescribir con un algoritmo. Devolverá un Diccionario con datos sobre la colision.
func DetectarObjetivo()->Dictionary:
	return {}



func _on_Ente_RecibeDamage(cantidad:float):
	#prints("El jugador recibe damage:", cantidad)
	Flash()
	movimiento = Vector2.ZERO
	vector_impulsos = Vector2.ZERO
	puede_recibir_damage = false
	var efecto_parpadeo:EfectoTemporal = load("res://SISTEMA/EFECTOS/Usados/EfectoTemp_golpe_a_enemigo.tscn").instance()
	efecto_parpadeo.mi_objetivo = self
	add_child(efecto_parpadeo)
