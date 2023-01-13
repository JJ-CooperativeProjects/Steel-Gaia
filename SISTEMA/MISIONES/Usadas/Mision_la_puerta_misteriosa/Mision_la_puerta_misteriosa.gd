extends Mision


func _ready():
	#GestorMisiones_global.connect("objeto_recogido",Memoria,"VerificarCubosOrbe")
	pass

func ChequearSiOrbe()->bool:
	if $Objetivo_obtener_cubos_y_orbe.objetos["Orbe"] == 0:
		return true
		
	return false

func ChequearCubos()->int:
	return 10 - $Objetivo_obtener_cubos_y_orbe.objetos["Cubo"]
