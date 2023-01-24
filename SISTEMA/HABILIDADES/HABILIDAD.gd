extends MEF_base
class_name Habilidad
"""
BASE PARA CONSTRUIR HABILIDADES. UNA HABILIDAD ES BASICAMENTE ALGO QUE SE LE
AÑADE A UN ENTE PARA MEJORAR SU JUGABILIDAD.
"""
#Energia que consume la habilidad
export (float) var consumo_energia:float = 30

var mi_ente = null #Hace referencia al ente al que pertenece.
var mef_ente:MEF_base = null #Hace referencia a la maquina de estados del ente.
onready var mi_ente_anim:AnimationPlayer = null

export (bool) var se_puede_deshabilitar:bool = false #Si una habilidad se puede deshabiliar, podrá ser desactivada durante la partida. Esto se para cambiar de habilidades y deshabilitar las otras.

func _ready():
	Memoria.connect("datos_cargados",self,"AfterCargar")

func DeshabilitarMEF():
	mef_ente.set_process(false)
	mef_ente.set_physics_process(false)
	#mef_ente.set_process_input(false)

#Habilita una máquina de estados. Normalmente la del ente que lleva la habilidad. se le pude pasar un input para que ejecute al activarse.
func HabilitarMEF(input:String = ""):
	mef_ente.set_process(true)
	mef_ente.set_physics_process(true)
	#mef_ente.set_process_input(true)
	
	if input != "":
		mef_ente.call_deferred("GenerarInputPressed",input)

func HabilitarSelf():
	call_deferred("set_process",true)
	call_deferred("set_physics_process",true)

func DeshabilitarSelf():
	if estados.has("espera"):
		estado = estados.espera
		
	set_process(false)
	set_physics_process(false)

func AfterCargar():
	pass
