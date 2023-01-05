extends KinematicBody2D
class_name Ente
"""
CLASE QUE DEFINE A UNA ENTIDAD
"""
signal RecibeDamage(cantidad)
signal Muere() #Emitida cuando un ente muere.

const NORMAL = Vector2.UP
const SNAP_DIR = Vector2.DOWN
const SNAP_L = 8.0
const SNAP_ANGULO = deg2rad(47)


##velocidad máxima de movimiento.
export (float) var velocidad_movimiento:float = 150.45
export (float) var velocidad_salto:float = 500
##Vector utilizado externamiente para crear efectos en el movimiento.
export (Vector2) var vector_impulsos:Vector2 = Vector2.ZERO
##Vitalidad:
export (int) var max_vitalidad:int = 100
export (int) onready var vitalidad:int = 100	setget set_vitalidad, get_vitalidad
##Damage:
export (float) var damage:float = 5		setget set_damage


onready var cuerpo:Node2D = $Cuerpo
onready var anim:AnimationPlayer = $AnimationPlayer
onready var tree:AnimationTree = $AnimationTree

var movimiento:Vector2 = Vector2.ZERO
var vector_snap:Vector2 = SNAP_DIR * SNAP_L
var direccion_mira:int = 1	#1= derecha -1 = izquierda

var puede_recibir_damage:bool = true
var en_escalera:bool = false #Se pone a true cuando está en un area de escalera.

##Velocidad actual en x:
export (float) var velocidad_actual_x:float = 1
export (float) var velocidad_actual_y:float = 1

#METODOS========================================================================
func _ready():
	ConectarSegnales()
	set_vitalidad(max_vitalidad)
	
#METODOS AUXILIARES=============================================================
func ConectarSegnales():
	connect("RecibeDamage",$MEF,"LogicaMorir")
#Aplica una fuerza constante en el eje Y del movimiento.
func AplicarGravedad(delta):
	movimiento.y += Memoria.gravedad * delta if movimiento.y < 850 else 0

func AplicarGravedadAtaque(delta):
	movimiento.y += (Memoria.gravedad*0.25) * delta if movimiento.y < 50 else 0

#retorna true si quieto, de lo contrario false:
func Quieto()->bool:
	if movimiento.x < 50 and movimiento.x > -50:
		return true
	return false

#gira al ente:
func Girar()->float:
	if movimiento.x > 0:
		cuerpo.scale.x = 1  
		direccion_mira = 1
	elif movimiento.x < 0:
		cuerpo.scale.x = -1
		direccion_mira = -1
	#cuerpo.scale.x *= -1
	return cuerpo.scale.x
	
func AjustarVectorImpulso()->Vector2:
	if $Cuerpo.scale.x < 0:
		return Vector2(vector_impulsos.x * -1, vector_impulsos.y)
	return Vector2(vector_impulsos.x * 1, vector_impulsos.y)

func ReiniciarVectorSnap():
	vector_snap = SNAP_DIR * SNAP_L

#movimieto base de caminar:
func Caminar(delta)->Vector2:
	return Vector2.ZERO
	pass

func Saltar():
	vector_snap = Vector2.ZERO
	movimiento.y -= velocidad_salto

#Override para poner el efecto de flasheo al recibir damage
func Flash():
	pass

func Salvar()->Dictionary:
	var data:Dictionary = {}
	
	return data

func Cargar(data:Dictionary):
	pass
#SET-GET========================================================================
func set_vitalidad(valor:int):
	vitalidad = valor

func get_vitalidad()->int:
	return vitalidad

func set_damage(valor:float):
	damage = valor
#SEÑALES========================================================================
func _on_Ente_RecibeDamage(cantidad:float):
	#prints("El jugador recibe damage:", cantidad)
	Flash()
	movimiento = Vector2.ZERO
	vector_impulsos = Vector2.ZERO
	puede_recibir_damage = false
	
	if vitalidad - cantidad > 0:
		var efecto_parpadeo:EfectoTemporal = load("res://SISTEMA/EFECTOS/Usados/EfectoParpadeo.tscn").instance()
		efecto_parpadeo.mi_objetivo = self
		add_child(efecto_parpadeo)
		
		var efecto_golpe:EfectoTemporal = load("res://SISTEMA/EFECTOS/Usados/EfectoTemp_golpe_a_enemigo.tscn").instance()
		efecto_golpe.mi_objetivo = self
		add_child(efecto_golpe)
	
	
	
	pass # Replace with function body.
