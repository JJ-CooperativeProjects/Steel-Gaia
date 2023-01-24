extends Node
class_name MEF_base

signal animacion_termina() #Siempre que una animacion es terminada.
signal sm_termina() #Se emite cuando una animación sale de una maquina de estados.


var estado:String = ""		#Estado actual
var estado_anterior:String = ""		#Almacena el estado anterior
var estados:Dictionary = {}		#Almacena todos los estados

var fuera_de_pantalla:bool = false #Controla si el ente está en pantalla o no.

var timer_de_transicion:SceneTreeTimer = null #Un timer para detectar cuando una estado es terminado por el tiempo.


# Called when the node enters the scene tree for the first time.
func _ready():
	_agregar_estado("muerte")
	
	connect("animacion_termina",self,"_on_animacion_termina")
	connect("sm_termina", self, "_on_sm_termina")
	
	#Estados utilizados por todos.
	#...
	pass # Replace with function body.

func _process(delta):
	if estado != "":
		_process_estado(delta)
		var transicion = _transiciones(delta)
		if transicion != null:
			_poner_estado(transicion)



#Logica para cambiar de estados:
func _transiciones(delta):
	return null
#Se ejecuta dentro de un estado constantemente.
func _process_estado(delta):
	pass
#Solo se ejecuta una vez cuando entra en un nuevo estado
func _entrar_estado(nuevo, viejo):
	pass
#Solo se ejecuta una vez cuando sale de un estado.
func _salir_estado(viejo, nuevo):
	pass



##Auxiliares##
func _poner_estado(nuevo):
	estado_anterior = estado
	estado = nuevo
	
	if estado_anterior != "":
		_salir_estado(estado_anterior, nuevo)
	if nuevo != "":
		_entrar_estado(nuevo, estado_anterior)

func _agregar_estado(nuevo_estado:String):
	estados[nuevo_estado] = nuevo_estado
	
func _activar_timer(tiempo:float, estado_actual:String):
	timer_de_transicion = get_tree().create_timer(tiempo)
	timer_de_transicion.connect("timeout",self,"_on_animacion_termina",[estado_actual])

func _detener_timer():
	timer_de_transicion.disconnect("timeout",self,"_on_animacion_termina")
	timer_de_transicion = null

func poner_estado_deferred(estado:String):
	call_deferred("_poner_estado", estado)


func LogicaMorir(cantida_dagno,quien:Node2D):
	var ente = get_parent() as Ente
	#print(cantida_dagno)
	ente.set_vitalidad(ente.get_vitalidad() - cantida_dagno) 
	
	if ente.vitalidad <= 0:
		#print("muerte!!")
		#Crea las almas:
		var rand:int =randi()%4+1
		var objetos_drops:Array = ente.posibles_objetos_soltar
		for i in objetos_drops:
			for a in rand:
				var objeto:ObjetoColectable = load(i).instance()
				objeto.global_position = Vector2(rand_range(ente.global_position.x-10,ente.global_position.x+10),rand_range(ente.global_position.y-10,ente.global_position.y+10))
				Memoria.nivel_actual.get_node("OBJETOS").call_deferred("add_child",objeto)
		
		poner_estado_deferred(estados.muerte)

#Genera una entra de control desde código. Útil para programar IAs con controles. O enviar inputs a otras máquinas de estado.
func GenerarInputPressed(input:String):
	var ev = InputEventAction.new()
	ev.action = input
	ev.pressed = true
	Input.parse_input_event(ev)
	pass


func _on_animacion_termina(animacion:String):
	
	pass

func _on_sm_termina():
	pass
