extends Enemigo
class_name NanoBot

export (float) var tiempo_de_vida:float = 8.0

onready var efecto_muerte:PackedScene = preload("res://SISTEMA/EFECTOS/ESPECIALES/Usados/MuerteNanoBot.tscn")
func _ready():
	var timer_vida:SceneTreeTimer = get_tree().create_timer(tiempo_de_vida)
	timer_vida.connect("timeout",$MEF,"_poner_estado",["muerte"])
	
	$AreaDamage.damage = damage
	
	pass # Replace with function body.

func Quieto()->bool:
	if movimiento.x < 10 and movimiento.x > -10:
		return true
	return false
	
func Impulso():
	velocidad_actual_x = 0
	if velocidad_actual_x in range(-velocidad_movimiento,velocidad_movimiento):
		if direccion_mira > 0:
			velocidad_actual_x += 4 #if !Input.is_action_pressed("correr") else 2.5

		if direccion_mira < 0:
			velocidad_actual_x -= 4 #if !Input.is_action_pressed("correr") else 2.5
	velocidad_actual_x *= velocidad_movimiento
	
func Caminar(delta):
	movimiento.x = lerp(movimiento.x,velocidad_actual_x,0.12)
func Saltar():
	vector_snap = Vector2.ZERO
	movimiento.y -= velocidad_salto
func CaminarAtaqueSalto(delta):
	velocidad_actual_x = 0
	if velocidad_actual_x in range(-velocidad_movimiento,velocidad_movimiento):
		if direccion_mira > 0:
			velocidad_actual_x += 6 #if !Input.is_action_pressed("correr") else 2.5

		if direccion_mira < 0:
			velocidad_actual_x -= 6 #if !Input.is_action_pressed("correr") else 2.5
	velocidad_actual_x *= velocidad_movimiento
	movimiento.x = lerp(movimiento.x,velocidad_actual_x,0.28)
