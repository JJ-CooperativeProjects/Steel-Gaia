extends Node2D
class_name Intercambiador

"""
UN INTERCAMBIADOR O PORTAL SE ENCAGA DE CONECTAR UN NIVEL CON OTRO 
"""

##La ruta del nivel al que se conecta:
export (String, FILE) var ruta_proximo_nivel:String

##El nombre del nodo que se usará para llevar al jugador (seguramente otro intercambiador).
export (String) var id_spawn_point:String

##En caso de que este nodo se use para traer al jugador:
export (int,-1,1) var direccion_del_jugador:int = 1

##Si inicialmente está desactivado:
export (bool) var desactivado:bool = false

func _ready():
	$AreaDisparadorEvento_por_tecla.connect("teclas_pulsadas",self,"Cambiar")
	
	
		
##Metodo que inicializa el cambio de escena:
func Cambiar():
	if not desactivado:
		#Salvar los datos:
		Memoria.SalvarRapido()
		
		if !id_spawn_point == "":
			Memoria.spawn_point_id = id_spawn_point 
		
		#Cambiar escena:
		Memoria.cambiando = true
		CambioSuave.CambiarEscena(ruta_proximo_nivel)
	
	
	pass

func Salvar()->Dictionary:
	var data:Dictionary = {
		"ruta_nodo": get_path(),
		"ruta_file": filename,
		"desactivado": desactivado
	}
	return data
	pass

func Cargar(data:Dictionary,nodo = null):
	if nodo:
		Memoria.nivel_actual.get_node("AREAS_EVENTOS").add_child(nodo)
		nodo.desactivado = data.desactivado
		return
		
	desactivado = data.desactivado
	
	pass
	
