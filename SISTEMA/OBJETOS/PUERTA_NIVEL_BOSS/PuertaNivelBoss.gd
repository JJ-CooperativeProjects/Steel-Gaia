extends Node2D

signal terminado() #emitida cuando se desbloquea la cerradura.

var visitado:bool = false #Para saber si la puerta ya fue visitada por el jugador.
var puzzle:Puzzle = null

var desactivado:bool = false
func _ready():
	$AreaDisparadorEvento_por_tecla.connect("teclas_pulsadas",self,"InteractuarConPuerta")
	
	pass
	
func _process(delta):
	$Label.text = str($AreaDisparadorEvento_por_tecla.activo)

func InteractuarConPuerta():
	if not desactivado:
		print("activar el puzzle")
		var mensaje:MensajeTomaDecisiones
		mensaje = load("res://SISTEMA/GUI/Mensaje Toma de Decisiones/Usados/Dialogo_jugador_puzzle.tscn").instance()
		Memoria.nivel_actual.get_node("CanvasLayer").add_child(mensaje)
		if not visitado:
			pass
			
		
		else:
			mensaje.texto.text = "Debería asegurarme te tener todas las piezas primero antes de volver a intentarlo. \n\n>>¿Interactuar de todos modos?"
		
		mensaje.boton1.connect("button_up",self,"ActivarPuzzle",[mensaje])
		mensaje.boton2.connect("button_up",self,"CerrarMensaje", [mensaje])
		pass

func ActivarPuzzle(mensaje_previo:MensajeTomaDecisiones):
	mensaje_previo.queue_free()
	puzzle = preload("res://SISTEMA/GUI/Puzzle/Puzzle.tscn").instance() as Puzzle
	puzzle.connect("juego_perdido",self,"MeterExplosionFallarPuzzle",[puzzle])
	puzzle.connect("juego_ganado",self,"queue_free")
	puzzle.connect("juego_ganado",self,"DesactivarCerradura")
	Memoria.nivel_actual.get_node("CanvasLayer").add_child(puzzle)
	
	visitado = true
	desactivado = true
	
	pass
func DesactivarCerradura():
	emit_signal("terminado")

func CerrarMensaje(mensaje:MensajeTomaDecisiones):
	get_tree().paused = false
	Memoria.juego_pausado = false
	$AreaDisparadorEvento_por_tecla.activo = true
	mensaje.queue_free()
	pass

func MeterExplosionFallarPuzzle(id_mensaje:int,i_puzzle:Puzzle):
	print("juego perdido")
	var mina:MinaNeutral = load("res://UTILIZABLES/Trampas/MinaNeutral.tscn").instance()
	mina.global_position = Memoria.jugador.global_position
	Memoria.nivel_actual.get_node("TRAMPAS/MINAS").add_child(mina)
	mina.explotar()
	
	i_puzzle.queue_free()
	
	get_tree().paused = false
	
	var timer:SceneTreeTimer = get_tree().create_timer(2.0)
	timer.connect("timeout",self, "MostrarMensajeSobreFracaso",[id_mensaje])
	
	
func MostrarMensajeSobreFracaso(id:int):
	var mensaje:MensajeTomaDecisiones = load("res://SISTEMA/GUI/Mensaje Toma de Decisiones/Usados/Dialogo_jugador_puzzle2.tscn").instance()
	
	mensaje.get_node("Mensaje/Mensaje").add_keyword_color("conseguir", Color(0.048004, 0.903251, 0.945313))
	mensaje.get_node("Mensaje/Mensaje").add_keyword_color("esas", Color(0.048004, 0.903251, 0.945313))
	mensaje.get_node("Mensaje/Mensaje").add_keyword_color("piezas", Color(0.048004, 0.903251, 0.945313))
	
	
	
	Memoria.nivel_actual.get_node("CanvasLayer").add_child(mensaje)
	match id:
		1:
			mensaje.texto.text = "¡Creo que debo apresurarme la próxima vez!"
		2:
			mensaje.texto.text = "Creo que tengo todo lo que se necesita, no debería abandonar a la ligera."
	
	mensaje.boton1.connect("button_up",self,"CerrarMensaje", [mensaje])
	desactivado = false
