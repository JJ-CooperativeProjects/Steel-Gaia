extends Resource
class_name BaseSaveData
"""
RECURSO DE BASE PARA CREAR SALVAS DEL JUEGO
"""

##Pantalla de la salva:
export var pantallazo:Texture

##Datos globales:
export var tiene_orbe:bool
export var cubos:int
export var almas_NPC1:int = 0
export var almas_NPC2:int = 0
export var almas_NPC3:int = 0
export var almas_NPC4:int = 0

##Personaje:
export var vida_actual:int 
export var vida_max:int
export var damage:float
export var direccion_mira:int
export var energia_actual:int
export var max_energia:int

export var posicion_actual:Vector2 

#Sobre el nivel:
"""
Un arreglo que va guardando el estado de todos los niveles visitados.
Los datos se guardan en un diccionario por nivel.

Estructura del Arreglo:
	-Diccionarios:
		key -> nombre , value -> ruta del nivel
		key -> persistentes, value -> Arreglo[]

-Estructura del Arreglo de persistentes:
	-Diccionario:
		key-> nodo, value ->ruta del archivo
		key-> ruta del arbol de nodos(esta es la del scene_Tree), value -> Data del nodo(los datos salvados del nodo)
		
"""
export var niveles_visitados:Array

#Metodos:
#Devuelve la posicion del arreglo donde se encuetra el diccionario de un nivel, o null si no existe.
func ObtenerNivelEnSalva(nombre:String):
	for i in niveles_visitados.size():
		var dic:Dictionary = niveles_visitados[i]
		if dic.has(nombre):
			return i
	
	return null

#Salvar un nivel:
func SalvarNivel(nombre_nivel:String, ruta_nivel:String)->Dictionary:
	#el arreglo de persistentes:
	var persistentes:Array = []
	var p_grupo:Array = Memoria.nivel_actual.get_tree().get_nodes_in_group("Persistentes")
	
	for i in p_grupo:
		persistentes.append(i.Salvar())
		pass
		
	#Los persistentes temporales:
	for i in Memoria.persistentes_temporales_a_guardar:
		persistentes.append(i)
	
	#Limpiar temporales:
	Memoria.persistentes_temporales_a_guardar.clear()
	
	var data:Dictionary = {
		nombre_nivel:ruta_nivel,
		"persistentes": persistentes
	}
	
	return data

#Poner un nuevo nivel en la salva:
func AddNuevoNivel(data:Dictionary):
	niveles_visitados.append(data)
	pass
