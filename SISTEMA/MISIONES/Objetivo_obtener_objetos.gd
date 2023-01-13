extends Objetivo
class_name ObjetivoObtenerObjetos


#Key ->nombre del objeto, value-> cantidad
export (Dictionary) var objetos:Dictionary

func _ready():
	GestorMisiones_global.connect("objeto_recogido",self,"VerificarObjetos")
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
	pass
	
func VerificarSiTodosConseguidos()->bool:
	for i in objetos:
		if objetos.get(i) != 0:
			return false
	return true
