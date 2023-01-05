extends Trampa
class_name TrampaAmetralladora

export (int,1,10) var disparos_por_ronda:int = 20

enum posiciones {PARED_DERECHA, PARED_IZQUIERDA, TECHO, PISO}
export (posiciones) var posicion = posiciones.TECHO

export (float) var tiempo_ronda_disparos:float = 1


onready var bala = preload("res://SISTEMA/OBJETOS/TRAMPAS/disparo_ametralladora.tscn")

enum estados{ESPERANDO, APAGADA, ACTIVANDOSE,BUSCANDO, DISPARANDO,DESACTIVANDOSE, MUERTE}
var estado:int = estados.ESPERANDO

var objetivo:Ente = null

var angulo_inicio:float = 0
var angulo:float = 0

func _ready():
	estado = estados.ESPERANDO if activa else estados.APAGADA
	$AnimationPlayer.play("esperando") if estado == estados.ESPERANDO else $AnimationPlayer.play("apagado")
	
func Activar():
	lista_para_reactivar = false
	estado = estados.ESPERANDO
	$AnimationPlayer.play("esperando")
	_on_ZonaActivacion_body_entered(Memoria.jugador)
	pass

func Desactivar():
	if es_bucle:
		estado = estados.ESPERANDO
		_on_ZonaActivacion_body_entered(Memoria.jugador)

func _process(delta):

		pass

func _physics_process(delta):
	$Label.text = str(estado)
	if estado == estados.ESPERANDO:
		if $RayCast2D.is_colliding():
			_on_ZonaActivacion_body_entered($RayCast2D.get_collider())
			
#	elif estado == estados.BUSCANDO:
#		$Cuerpo/brazo1/base.look_at(objetivo.global_position)
		
func CrearDisparo():
	match posicion:
		posiciones.PARED_DERECHA:
			Disparo(0,-1,-90)
			pass
		posiciones.PARED_IZQUIERDA:
			Disparo(0,1,90)
			pass
		posiciones.TECHO:
			Disparo(-1,0,0)
			pass
		posiciones.PISO:
			Disparo(1,0,-180)
			pass
func Disparo(dir:int,dir_y:int,minus:int):
	var new_bala = bala.instance()
	new_bala.rotate($Cuerpo/brazo1/base.rotation- deg2rad(minus))
	new_bala.global_position = $Cuerpo/brazo1/base/Position2D.global_position
	new_bala.movimiento = Vector2(dir,dir_y).rotated($Cuerpo/brazo1/base.rotation)
	Memoria.nivel_actual.add_child(new_bala)
	
func _on_ZonaActivacion_body_entered(body):
	if estado == estados.ESPERANDO:
		estado = estados.ACTIVANDOSE
		objetivo = body
		$AnimationPlayer.play("activar")
		yield ($AnimationPlayer,"animation_finished")
		
		estado = estados.BUSCANDO
		match posicion:
			posiciones.TECHO:
				if objetivo.global_position.x > global_position.x:
					$Cuerpo/brazo1/base.rotation_degrees -= 90
				elif objetivo.global_position.x < global_position.x:
					$Cuerpo/brazo1/base.rotation_degrees += 90
				pass
			posiciones.PARED_DERECHA:
				if objetivo.global_position.y > global_position.y:
					$Cuerpo/brazo1/base.rotation_degrees -= 90
				elif objetivo.global_position.y < global_position.y:
					$Cuerpo/brazo1/base.rotation_degrees += 90
				pass
			posiciones.PARED_IZQUIERDA:
				if objetivo.global_position.y > global_position.y:
					$Cuerpo/brazo1/base.rotation_degrees += 90
				elif objetivo.global_position.y < global_position.y:
					$Cuerpo/brazo1/base.rotation_degrees -= 90
				pass
			posiciones.PISO:
				if objetivo.global_position.x > global_position.x:
					$Cuerpo/brazo1/base.rotation_degrees += 90
				elif objetivo.global_position.x < global_position.x:
					$Cuerpo/brazo1/base.rotation_degrees -= 90
		
		angulo_inicio = $Cuerpo/brazo1/base.rotation_degrees
		
		estado = estados.DISPARANDO
		var tween:SceneTreeTween 
		var valor_final:float = 180 / disparos_por_ronda
		var base:Sprite = $Cuerpo/brazo1/base
		match posicion:
			posiciones.TECHO:
				if objetivo.global_position.x > global_position.x:
					$AnimationPlayer.play_backwards("disparos")
				elif objetivo.global_position.x < global_position.x:
					$AnimationPlayer.play("disparos")
					pass
				pass
			
			posiciones.PARED_DERECHA:
				if objetivo.global_position.y > global_position.y:
					$AnimationPlayer.play_backwards("disparos")

				elif objetivo.global_position.y < global_position.y:
					$AnimationPlayer.play("disparos")
				pass
			posiciones.PARED_IZQUIERDA:
				if objetivo.global_position.y > global_position.y:
					$AnimationPlayer.play("disparos")

				elif objetivo.global_position.y < global_position.y:
					$AnimationPlayer.play_backwards("disparos")

				pass
			posiciones.PISO:
				if objetivo.global_position.x > global_position.x:
					$AnimationPlayer.play("disparos")

					
				elif objetivo.global_position.x < global_position.x:
					$AnimationPlayer.play_backwards("disparos")

		yield($AnimationPlayer,"animation_finished")
		#Desactivarse:
		estado = estados.DESACTIVANDOSE
		tween = get_tree().create_tween()
		tween.tween_property(base,"rotation_degrees",float(-90),0.5)
		yield(tween,"finished")
		
		$AnimationPlayer.play_backwards("activar")
		yield($AnimationPlayer,"animation_finished")
		estado = estados.ESPERANDO if activa else estados.APAGADA
		lista_para_reactivar = true
		Desactivar()
	pass # Replace with function body.
