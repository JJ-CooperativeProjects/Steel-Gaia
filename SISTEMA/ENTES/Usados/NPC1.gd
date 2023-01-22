tool
extends Enemigo
class_name NPC1
"""
NPC 1
"""
##Estados según el jugador se acerca:
enum estados {TRANQUILO,ALERTA,MUERTO}
var estado:int = estados.TRANQUILO
var jugador_cerca:bool = false

onready var efecto_polvo:PackedScene = preload("res://SISTEMA/EFECTOS/ESPECIALES/EfectoEspecialHumoDisperso.tscn")
onready var efecto_dash:PackedScene = preload("res://SISTEMA/EFECTOS/ESPECIALES/Usados/EfectoEspecial_NPC1_sombra_dash.tscn")
onready var efecto_salpicas_pies:PackedScene = preload("res://SISTEMA/EFECTOS/ESPECIALES/Usados/EfectoEspecial_humo_npc1_pies.tscn")
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

func EfectoDash():
	var i_efecto:EfectoEspecial = efecto_dash.instance()
	i_efecto.global_position = Vector2(global_position.x + (get_node("MEF").coeficiente_correr *5) * direccion_mira,global_position.y)
	i_efecto.coeficiente_shader = get_node("MEF").coeficiente_correr
	Memoria.nivel_actual.add_child(i_efecto)
	var spr:Sprite = i_efecto.get_node("Sprite")
	
	spr.texture = $Cuerpo/Sprite.texture
	spr.hframes = $Cuerpo/Sprite.hframes
	spr.vframes = $Cuerpo/Sprite.vframes
	spr.frame = $Cuerpo/Sprite.frame
	spr.frame_coords = $Cuerpo/Sprite.frame_coords
	spr.scale.x *= direccion_mira #$Cuerpo/Sprite.scale
	
	var i_salpicas:EfectoEspecial = efecto_salpicas_pies.instance()
	i_salpicas.global_position = $Cuerpo/pos_salpica_pies.global_position
	Memoria.nivel_actual.add_child(i_salpicas)

func ActivarColisionesVelociadSube():
	if $MEF.coeficiente_correr > 1.65:
		if not $Cuerpo/Position2D/Area2D.monitoring:
			$Cuerpo/Position2D/Area2D.set_deferred("monitoring",true)
		if not $Cuerpo/Position2D/Escudo/CollisionShape2D.disabled:
			$Cuerpo/Position2D/Escudo/CollisionShape2D.set_deferred("disabled",true)
		

func _process(delta):
	#$Label_debug.text = str(vitalidad) + " " + str(LogicaMirarJugador())
	pass
	
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
	
	#Crear el efecto de polvo:
	var i_polvo:EfectoEspecial = efecto_polvo.instance()
	i_polvo.global_position = Vector2($Cuerpo/pos_golpes_escudo.global_position.x,$Cuerpo/pos_golpes_escudo.global_position.y +25)
	Memoria.nivel_actual.add_child(i_polvo)
#Retorna true si puede ver al jugador:
func LogicaMirarJugador()->bool:
	var jugador = $Cuerpo/rayo_mirar_jugador.get_collider() as Jugador
	if jugador:
		return true
	return false

func _on_Ente_RecibeDamage(cantidad:float,quine:Node2D):
	#prints("El jugador recibe damage:", cantidad)
	if LogicaMirarJugador():
		Flash()
		movimiento = Vector2.ZERO
		vector_impulsos = Vector2.ZERO
		puede_recibir_damage = false
		var efecto_parpadeo:EfectoTemporal = load("res://SISTEMA/EFECTOS/Usados/EfectoTemp_golpe_a_enemigo.tscn").instance()
		efecto_parpadeo.mi_objetivo = self
		add_child(efecto_parpadeo)

	
