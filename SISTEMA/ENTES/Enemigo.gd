tool
extends Ente
class_name Enemigo
"""
CLASE QUE DEFINE UNA ENTIDAD BASE PARA CONSTRUIR ENEMIGOS.
"""
signal es_destruido()
export (bool) var girar:bool = false
onready var explosion_morir:PackedScene = preload("res://SISTEMA/EFECTOS/ESPECIALES/Explosion_muerte_NPC.tscn")

##Es la direccion inicial en la que mira el personaje cuando empieza el juego.
export (int,-1,1) var direccion_mira_inicial:int = 1
export (Array,String,FILE, "*.tscn") var posibles_objetos_soltar:Array = []


var objetivo:Node2D = null

func _ready():
	if not girar:
		$Cuerpo.scale.x = 1
		direccion_mira = $Cuerpo.scale.x
	else:
		$Cuerpo.scale.x = -1
		direccion_mira = $Cuerpo.scale.x
		pass

func _process(delta):
	if Engine.editor_hint:
		if not girar:
			$Cuerpo.scale.x = 1
			direccion_mira = $Cuerpo.scale.x
		else:
			$Cuerpo.scale.x = -1
			direccion_mira = $Cuerpo.scale.x
		pass
	pass

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

func MirarObjetivoConRayo(obj:Node2D)->bool:
	if is_instance_valid(obj):
		if $Cuerpo/rayo_mirar_jugador.enabled:
			$Cuerpo/rayo_mirar_jugador.look_at(obj.global_position)
			
			if $Cuerpo/rayo_mirar_jugador.is_colliding():
				return true
			
	return false
			#$Cuerpo/rayo_mirar_jugador.cast_to = obj.global_position
#Meteto pensado para sobrescribir con un algoritmo. Devolverá un Diccionario con datos sobre la colision.
func DetectarObjetivo()->Dictionary:
	return {}

#Metodo que devuelve true, si la direccion en la que mira es a favor de la posicion del objetivo:
func ObjetivoDelante(obj:Node2D)->bool:
	if is_instance_valid(obj):
		match direccion_mira:
			1:
				if obj.global_position > global_position:
					return true
			-1:
				if obj.global_position < global_position:
					return true
	return false


func _on_Ente_RecibeDamage(cantidad:float,quien:Node2D):
	#prints("El jugador recibe damage:", cantidad)
	Flash()
	movimiento = Vector2.ZERO
	vector_impulsos = Vector2.ZERO
	puede_recibir_damage = false
	var efecto_parpadeo:EfectoTemporal = load("res://SISTEMA/EFECTOS/Usados/EfectoTemp_golpe_a_enemigo.tscn").instance()
	efecto_parpadeo.mi_objetivo = self
	add_child(efecto_parpadeo)
