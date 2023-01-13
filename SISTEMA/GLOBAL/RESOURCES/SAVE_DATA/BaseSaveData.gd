extends Resource
class_name BaseSaveData
"""
RECURSO DE BASE PARA CREAR SALVAS DEL JUEGO
"""

##Pantalla de la salva:
export var pantallazo:Texture

##Datos globales:
export var almas_NPC1:int = 0
export var almas_NPC2:int = 0
export var almas_NPC3:int = 0
export var almas_NPC4:int = 0

export var misiones:Array
export var misiones_terminadas:Array

#Sobre el nivel:
"""
Un arreglo que va guardando el estado de todos los niveles visitados.
Los datos se guardan en un diccionario por nivel.

>>> persistentes: Nodos que persisten entre escena y escena. Se borran y se crean de nuevo.
>>> imborrables: Son elementos que se crean durante el diseño del nivel y no se crean ni se borran, pero guardan su estado entre niveles.
>>> eventos: Los eventos son areas que generan cambios en el juego. Pueden ser persistentes (siempre se quedan) o de una sola ejecucion (se borran una vez terminados)
Estructura del Arreglo:
	-Diccionarios:
		key -> nombre , value -> ruta del nivel
		key -> persistentes, value -> Arreglo[]
		key -> imborrables, value -> Arreglo[]

-Estructura del Arreglo de persistentes:
	-Diccionario:
		key-> nodo, value ->ruta del archivo
		key-> ruta del arbol de nodos(esta es la del scene_Tree), value -> Data del nodo(los datos salvados del nodo)
		
"""
export var niveles_visitados:Array

##Ruta del ultimo nivel visitado:
export (String,FILE) var ultimo_nivel:String

#Metodos:
#Devuelve la posicion del arreglo donde se encuetra el diccionario de un nivel, o null si no existe.
func ObtenerNivelEnSalva(nombre:String):
	for i in niveles_visitados.size():
		var dic:Dictionary = niveles_visitados[i]
		if dic["nombre"]== nombre:
			return i
	
	return null

#Salvar un nivel:
"""
func SalvarNivel(nombre_nivel:String, ruta_nivel:String)->Dictionary:
	#el arreglo de persistentes:
	var persistentes:Array = []
	var p_grupo:Array = Memoria.nivel_actual.get_tree().get_nodes_in_group("Persistentes")
	
	for i in p_grupo:
		persistentes.append(i.Salvar())
		pass
	
	#Los imborrables:
	var imborrables:Array = []
	var g_imborrables:Array = Memoria.nivel_actual.get_tree().get_nodes_in_group("imborrables")
	
	for i in g_imborrables:
		imborrables.append(i.Salvar())
	
	#Los eventos:
	var eventos:Array = []
	var g_eventos:Array = Memoria.nivel_actual.get_tree().get_nodes_in_group("evento")
	
	for i in g_eventos:
		eventos.append(i.Salvar())
	
	#Los persistentes temporales:
	for i in Memoria.persistentes_temporales_a_guardar.get("persistentes"):
		persistentes.append(i)
	
	for i in Memoria.persistentes_temporales_a_guardar.get("eventos"):
		eventos.append(i)
	
	for i in Memoria.persistentes_temporales_a_guardar.get("imborrables"):
		imborrables.append(i)
	
	#Limpiar temporales:
	Memoria.persistentes_temporales_a_guardar = {
		"persistentes": [],
		"imborrables": [],
		"eventos": []
	}
	
	var data:Dictionary = {
		nombre_nivel:ruta_nivel,
		"persistentes": persistentes,
		"imborrables": imborrables,
		"eventos": eventos
	}
	
	return data

func SalvarNivel(nombre_nivel:String, ruta_nivel:String)->Dictionary:
	var persistentes:Array = []
	var p_grupo:Array = Memoria.nivel_actual.get_tree().get_nodes_in_group("Persistentes")
	
	var persistentes_hijos:Array = []
	#Salva los persistentes:
	for i in p_grupo:
		var nodo:Node = i as Node
		#verificar si el padre es persistente tambien:
		if nodo.get_parent().is_in_group("Persistentes"):
			persistentes_hijos.append(nodo)
			continue
		persistentes.append(i.Salvar())
		pass
	
	while not persistentes_hijos.empty():
		for i in persistentes_hijos:
			var nodo:Node = i as Node
			#Ver si el padre de primer nivel ya fue guardado:
			for dato in persistentes:
				if nodo.get_parent().name == dato["nombre"]:
					if dato.has("hijo"):
						dato["hijo"].append(i.Salvar())
					else:
						dato.hijo = [i.Salvar()]
					persistentes_hijos.erase(i)
					continue
				else:
					#verificar si es hijo de segundo nivel:
					if dato.has("hijo"):
						for c_dato in dato["hijo"]:
							if c_dato["nombre"] == nodo.get_parent().name:
								if c_dato.has("hijo"):
									c_dato["hijo"].append(nodo.Salvar())
								else:
									c_dato.hijo = [nodo.Salvar()]
								
								persistentes_hijos.erase(i)
								continue

	var data:Dictionary = {
		nombre_nivel:ruta_nivel,
		"persistentes": persistentes,
		#"imborrables": imborrables,
		#"eventos": eventos
	}
	return data

func SalvarNivel(nombre_nivel:String, ruta_nivel:String)->Dictionary:
	var persistentes:Array = []
	
	
	#Solo los persistentes de primer nivel.
#	for i in Memoria.nivel_actual.get_children():
#		var nodo:Node = i as Node
#		if nodo.is_in_group("Persistentes"):
#			pass
	persistentes = MetodoBuscar(Memoria.nivel_actual.get_children(),Memoria.nivel_actual,[])
	
	#Finalmente...
	var data:Dictionary = {
		"persistentes": persistentes
	}
	return data
	pass
	
func MetodoBuscar(nodos:Array,nodo_padre:Node,arreglo:Array)->Array:
	for i in nodos:
		var nodo:Node = i as Node
		
		#print(nodo.get_path().get_name_count()-2)
		if nodo.is_in_group("Persistentes"):
			arreglo.append(nodo.Salvar({}))
			
		###
		if nodo.get_child_count() != 0:
			MetodoBuscar(nodo.get_children(),nodo,arreglo)
	
	return arreglo

func MetodoOrdenadDatos(arreglo:Array):
	#Obtener el indice más pequeño:
	pass
"""
func SalvarNivel(nombre_nivel:String, ruta_nivel:String)->Dictionary:
	var data = Memoria.nivel_actual.Salvar({})
	
	return data
	pass





#Poner un nuevo nivel en la salva:
func AddNuevoNivel(data:Dictionary):
	niveles_visitados.append(data)
	pass



