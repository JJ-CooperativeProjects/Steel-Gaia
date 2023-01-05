extends Enemigo
class_name NPC1
"""
NPC 1
"""
##Estados según el jugador se acerca:
enum estados {TRANQUILO,ALERTA,MUERTO}
var estado:int = estados.TRANQUILO
var jugador_cerca:bool = false


var objetivo = null #El id del jugador enemigo.
# Called when the node enters the scene tree for the first time.
func _ready():

	pass # Replace with function body.

func Caminar(delta):
	velocidad_actual_x = 0
	if velocidad_actual_x in range(-velocidad_movimiento,velocidad_movimiento):
		if direccion_mira == 1:
			velocidad_actual_x += 1 #if !Input.is_action_pressed("correr") else 2.5

		if direccion_mira == -1:
			velocidad_actual_x -= 1 #if !Input.is_action_pressed("correr") else 2.5

	velocidad_actual_x *= velocidad_movimiento
	movimiento.x = lerp(movimiento.x,velocidad_actual_x,0.18)

func CorrerSprint(coeficiente:float):
	velocidad_actual_x = 0
	if velocidad_actual_x in range(-velocidad_movimiento,velocidad_movimiento):
		if direccion_mira == 1:
			velocidad_actual_x += 2.6 * coeficiente #if !Input.is_action_pressed("correr") else 2.5

		if direccion_mira == -1:
			velocidad_actual_x -= 2.6 * coeficiente #if !Input.is_action_pressed("correr") else 2.5

	velocidad_actual_x *= velocidad_movimiento
	movimiento.x = lerp(movimiento.x,velocidad_actual_x,0.25)
	
func _process(delta):
	if $Cuerpo/rayo_mirar_jugador.enabled:
		$Cuerpo/rayo_mirar_jugador.look_at(Memoria.jugador.global_position)
	$Label_debug.text = str(vitalidad) + " " + str(LogicaMirarJugador())

func Girar():
	$Cuerpo.scale.x *= -1
	direccion_mira = $Cuerpo.scale.x

#Cuando alguno de los rayos de control detecta que el NPC debe girar:
func Girar_por_rayo():
	#No hay suelo debajo:
	if not $Cuerpo/rayo_suelo_der.is_colliding() and not $Cuerpo/rayo_frente.is_colliding():
		$Cuerpo.scale.x = 1 if direccion_mira == -1 else -1
		direccion_mira = 1 if direccion_mira == -1 else -1
		
	elif $Cuerpo/rayo_frente.is_colliding():
		$Cuerpo.scale.x = 1 if direccion_mira == -1 else -1
		direccion_mira = 1 if direccion_mira == -1 else -1


func SacudirCamara():
	Memoria.camara_actual.sacudir(15,0,4)

#Retorna true si puede ver al jugador:
func LogicaMirarJugador()->bool:
	var jugador = $Cuerpo/rayo_mirar_jugador.get_collider() as Jugador
	if jugador:
		return true
	return false

func _on_Ente_RecibeDamage(cantidad:float):
	#prints("El jugador recibe damage:", cantidad)
	if LogicaMirarJugador():
		Flash()
		movimiento = Vector2.ZERO
		vector_impulsos = Vector2.ZERO
		puede_recibir_damage = false
		var efecto_parpadeo:EfectoTemporal = load("res://SISTEMA/EFECTOS/Usados/EfectoTemp_golpe_a_enemigo.tscn").instance()
		efecto_parpadeo.mi_objetivo = self
		add_child(efecto_parpadeo)

	
