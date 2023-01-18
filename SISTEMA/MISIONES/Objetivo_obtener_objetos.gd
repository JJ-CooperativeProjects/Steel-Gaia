extends Objetivo
class_name ObjetivoObtenerObjetos

onready var i_gui := GuiJugador.get_node("GUI")
#Key ->nombre del objeto, value-> cantidad
export (Dictionary) var objetos:Dictionary

func _ready():
	GestorMisiones_global.connect("objeto_recogido",self,"VerificarObjetos")
	
	ActualizarInterfaz()
	get_parent().connect("mision_terminada",self,"ActualizarInterfaz")
	pass

func VerificarObjetos(id_objeto:String, cantidad:int):
	prints(objetos,id_objeto)
	if objetos.has(id_objeto):
		if objetos[id_objeto] > 0:
			objetos[id_objeto] -= cantidad

		if objetos.get(id_objeto) <= 0:
			objetos[id_objeto] = 0
		
	if VerificarSiTodosConseguidos():
		terminado = true
		emit_signal("objetivo_terminado")
		prints("Objetivo Terminado!!:",name)
	
	ActualizarInterfaz()
	pass
	
func VerificarSiTodosConseguidos()->bool:
	for i in objetos:
		if objetos.get(i) != 0:
			return false
	return true

func ActualizarInterfaz():
	if get_parent().estado != get_parent().estados.TERMINADA:
		#Actualizar interfaz cubos:
		if objetos["Cubo"] != 10:
			i_gui.get_node("Cubos").visible = true
			i_gui.get_node("Cubos/Label").text = "x " + str(10 - objetos["Cubo"])
		else:
			i_gui.get_node("Cubos").visible = false
		
		#Actualizar el orbe:
		if objetos["Orbe"] == 0:
			i_gui.get_node("Orbe").visible = true
		else:
			i_gui.get_node("Orbe").visible = false
	else:
		i_gui.get_node("Cubos").visible = false
		i_gui.get_node("Orbe").visible = false
	pass
