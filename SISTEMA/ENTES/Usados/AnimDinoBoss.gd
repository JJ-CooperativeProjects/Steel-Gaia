extends Node2D

signal disparar_misil(cual)	#Señal que se emite para disparar un misil. cual pueede ser: 1,2,3
signal disparar_misil_dirigido()
signal suelo_listo_levantarse() #Señal que emite cuando se va a levantar del suelo. Es usada por el dino para cambiar de animación entre esta o lanzar misiles.
signal grito() #Emitida en el momento que grita. Se usa para motrar la barra de vida.


signal ataque_rocas()
signal crear_llama()
signal crear_bolas_fuego()

onready var pos_llamas:Position2D = $Position2D
onready var pos_boca:Position2D = $Base/pelvis_control/cuerpo/Pecho/cuello_Control/cuello/cabeza/pos_efecto_cargar_llamas

export (float) var velocidad_movimiento:float = 0.0


func SacudirCamara(a:int,b:int,c:int,d:int,e:Vector2):
	Memoria.camara_actual.sacudir(a,b,c,d,e)

func DispararMisil(cual:int):
	emit_signal("disparar_misil",cual)
	
func DispararMisilDirigido():
	emit_signal("disparar_misil_dirigido")

func CrearLlamas():
	emit_signal("crear_llama")

func ActivarBolasFuego():
	emit_signal("crear_bolas_fuego")
	
func EliminarLlamasSuperiores():
	var llamas = Memoria.nivel_actual.get_node_or_null("CanvasLayer/EFECTO_CAPA_LLAMAS")
	if llamas:
		llamas.queue_free()
	
func CrearLlamasSuperiores():
	var llamaradas = load("res://SISTEMA/EFECTOS/ESPECIALES/EFECTO_CAPA_LLAMAS.tscn").instance()
	Memoria.nivel_actual.get_node("CanvasLayer").add_child(llamaradas)


func _on_Control_grito():
	#print("grito")
	pass # Replace with function body.
