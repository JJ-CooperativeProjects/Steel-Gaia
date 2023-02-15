extends Node2D
class_name SpawnPoint

signal ReiniciarSpawn() ##Señal que se emite para reiniciar el proceso.
signal NodoEsDestruido() ##Siempre que uno de los nodos instanciados es destruido, se emite.
"""
Clase que implementa el concepto de SpawnPoint

El nodo ZONAS_SPAWN, debe contener como hijos nodos de tipo Position2D.
Estos son usados por el algoritmo para instanciar los nodos.
"""
##Aquí poner los packageScene de los nodos que va a instanciar. Como mínimo debe tener 1.
export (Array, PackedScene) var nodos_a_instanciar:Array = []

##Si instanciar aleatorio, entonces coge uno de los nodos cualesquiera y lo crea:
export (bool) var nodo_aleatorio:bool = true
##Si se instanciarán aleatoriamente o en una posición específica:
export (bool) var posicion_aleatoria:bool = false

##Al cargar el nivel, cuánto tiempo tarda en crear la primera instancia:
export (float) var tiempo_arranque:float = 1.0

##Cantidad de nodos a instanciar por vuelta:
export (int) var cantidad_por_ronda:int = 1

##Maximo de instancias a la vez. Controla la máxima cantidad de copias que tiene activa en el juego
export (int) var maximo_instancias:int = 10

##Si es infinito, estará creando instancias siempre que las instancias activas sea menor que el maximo_instancias.
##Si es falso, cuando llegue al máximo de instancias, no creará ni una más.
export (bool) var es_inifinito:bool = true

##El spawn point puede crear rondas periódicas. Este timer permite eso. Si es 0, se considera que no es periódico.
export (float) var tiempo_entre_rondas:float = 10


var instancias_activas:int = 0 #La cantidad de copias que están actualmente activas en el juego.
var total_de_copias_creadas:int = 0 #Controla el total de copias que se han creado. Si su valor alcanza el maximo_instancias y no es infinito, se entiende que terminó de instanciar para siempre.

var contador:SceneTreeTimer

func _process(delta):
	$Label.text = "ACTIVAS: " + str(instancias_activas) + " MAX: " + str(maximo_instancias)+ " TOTAL: " + str(total_de_copias_creadas)


func Logica():
	contador = null
	if not nodos_a_instanciar.empty():
		match es_inifinito:
			true:
				if not instancias_activas >= maximo_instancias:
					Instanciar()
			false:
				if not total_de_copias_creadas >= maximo_instancias:
					Instanciar()
				else:
					$MEF.poner_estado_deferred($MEF.estados.apagado)
				pass
		
		if not is_instance_valid(contador):
			if tiempo_entre_rondas > 0:
				contador = get_tree().create_timer(tiempo_entre_rondas)
				contador.connect("timeout",self,"Logica")

func Instanciar():
	var rand:float = 0
	var r_posicion:float = 0
	
	if nodo_aleatorio:
		rand = randi() % (nodos_a_instanciar.size())

	if posicion_aleatoria:
		r_posicion = randi() %  $ZONAS_SPAWN.get_children().size()
	
	var nodo:Node2D = nodos_a_instanciar[rand].instance() as Node2D
	
	nodo.global_position = $ZONAS_SPAWN.get_child(r_posicion).global_position
	
	
	Memoria.nivel_actual.get_node("ENEMIGOS").call_deferred("add_child",nodo)
	
	nodo.call_deferred("AfterCargar")
	
	instancias_activas += 1
	total_de_copias_creadas += 1
	
	nodo.connect("tree_exiting",self,"emit_signal",["NodoEsDestruido"])

	pass


func _on_AreaVisibilidadAjustable_screen_entered():
	$AreaVisibilidadAjustable.ProcesarNodos(false)
	
	contador = get_tree().create_timer(tiempo_arranque)
	contador.connect("timeout",self,"Logica")
	pass # Replace with function body.




func _on_AreaVisibilidadAjustable_screen_exited():
	if is_instance_valid(contador):
		contador = null
	$AreaVisibilidadAjustable.ProcesarNodos(true)
	
	pass # Replace with function body.


func _on_SpawnPoint_NodoEsDestruido():
	instancias_activas -= 1
	pass # Replace with function body.
