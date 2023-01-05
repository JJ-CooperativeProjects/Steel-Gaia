extends AreaDisparadorEvento

var jugador:Jugador
var activa:bool = false

func _ready():
	yield(get_tree(),"idle_frame")
	jugador = Memoria.jugador
	connect("body_exited",self,"Desactivar")

func _physics_process(delta):
	#Hacer que el jugador siga caminando:
	if activa:
#		jugador.AplicarGravedad(delta)
		jugador.Caminar(delta)
#
#		jugador.movimiento.y = jugador.move_and_slide_with_snap(jugador.movimiento + jugador.AjustarVectorImpulso(), jugador.vector_snap,Vector2.UP,true,4,jugador.SNAP_ANGULO).y
	pass

func EsActivada():
	Memoria.juego_terminado = true
	Memoria.modo_cinematica_activo = true
	jugador = Memoria.jugador
	
	#Hace que el jugador siga caminando:
	activa = true
	jugador.direcciones = Vector2(1,0)
	pass

func Desactivar(body):
	CambioSuave.CambiarEscena("res://SISTEMA/GUI/GameFlow/PantallasUsadas/PantallaCreditos.tscn",3.5,1.5)
	pass
