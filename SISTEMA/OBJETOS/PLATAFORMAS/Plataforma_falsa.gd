extends Plataforma
class_name PlataformaFalsa

signal activar_deteccion()
signal regenerarse()

export (float) var tiempo_para_caerse:float = 3
export (bool) var se_regenera:bool = false
export (float) var tiempo_antes_de_regenerarse:float = 10.0

var posicion_inicial:Vector2

var unidad_arriba:Ente = null

enum estados {NADA,CHEQUEAR,CAERSE,REGENERARSE}
var estado = estados.NADA

var movimiento:Vector2 = Vector2.ZERO

func _ready():
	posicion_inicial = global_position
	

func _physics_process(delta):
	match estado:
		estados.NADA:
			if unidad_arriba != null:
				if unidad_arriba.get_node("MEF").estado == "quieto":
					#print("Ahora sii!!!")
					var timer:SceneTreeTimer = get_tree().create_timer(tiempo_para_caerse)
					timer.connect("timeout",self,"emit_signal",["activar_deteccion"])
					estado = estados.CHEQUEAR
				pass
			pass
		estados.CHEQUEAR:
			
			pass
		estados.CAERSE:
			if is_on_floor():
				emit_signal("regenerarse")
				estado = estados.REGENERARSE
			movimiento.y += Memoria.gravedad * delta
			movimiento = move_and_slide(movimiento,Vector2.UP)
			
			
			pass
func Activar():
	visible = true
	$Area2D.set_deferred("monitoring",true)
	$Area_activar_falsa.set_deferred("monitoring",true)
	set_process(true)
	set_physics_process(true)
	collision_layer = 0b00000000000000010000
	collision_mask = 0b00000000001000000111
	
func Desactivar():
	visible = false
	$Area2D.set_deferred("monitoring",false)
	$Area_activar_falsa.set_deferred("monitoring",false)
	set_physics_process(false)
	set_process(false)
	
	collision_layer = 0b00000000000000000000
	collision_mask = 0b00000000000000000000
	
	yield(get_tree(),"idle_frame")
	global_position = posicion_inicial
	estado = estados.NADA

func _on_Area_activar_falsa_body_entered(body):
	unidad_arriba = body
#	var timer:SceneTreeTimer = get_tree().create_timer(tiempo_para_caerse)
#	timer.connect("timeout",self,"emit_signal",["activar_deteccion"])
	pass # Replace with function body.


func _on_Plataforma_falsa_activar_deteccion():
#	if !$Area_activar_falsa.get_overlapping_bodies().empty():
#		caerse = true
	estado = estados.CAERSE
	pass # Replace with function body.


func _on_Area_activar_falsa_body_exited(body):
	if body == unidad_arriba:
		unidad_arriba = null
	pass # Replace with function body.


func _on_VisibilityNotifier2D_screen_exited():
	#emit_signal("regenerarse")
	pass # Replace with function body.


func _on_Plataforma_falsa_regenerarse():
	if se_regenera:
		Desactivar()
		var timer:SceneTreeTimer = get_tree().create_timer(tiempo_antes_de_regenerarse)
		timer.connect("timeout",self,"Activar")
		pass
	else:
		queue_free()
	pass # Replace with function body.
