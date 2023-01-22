extends MEF_base
class_name Habilidad
"""
BASE PARA CONSTRUIR HABILIDADES. UNA HABILIDAD ES BASICAMENTE ALGO QUE SE LE
AÑADE A UN ENTE PARA MEJORAR SU JUGABILIDAD.
"""
var mi_ente = null #Hace referencia al ente al que pertenece.
var mef_ente:MEF_base = null #Hace referencia a la maquina de estados del ente.
onready var mi_ente_anim:AnimationPlayer = null


func _ready():
	Memoria.connect("datos_cargados",self,"AfterCargar")

func DeshabilitarMEF():
	mef_ente.set_process(false)
	mef_ente.set_physics_process(false)

func HabilitarMEF():
	mef_ente.set_process(true)
	mef_ente.set_physics_process(true)


func HabilitarSelf():
	call_deferred("set_process",true)
	call_deferred("set_physics_process",true)

func DeshabilitarSelf():
	set_process(false)
	set_physics_process(false)

func AfterCargar():
	pass
