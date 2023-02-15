extends MEF_base

onready var ente:Ente 
onready var anim:AnimationPlayer

func _ready():
	_agregar_estado("espera")
	_agregar_estado("quieto_mallas")
	_agregar_estado("camina_mallas_up_down")
	_agregar_estado("camina_mallas_left_right")

	poner_estado_deferred(estados.espera)
	
	set_process(false)
	set_physics_process(false)


func _transiciones(delta):
	print("mmmmasdasd")
	match estado:
		estados.espera:
			if !ente.QuietoEnMalla():
				if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
					return estados.camina_mallas_left_right
				
				if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):
					return estados.camina_mallas_up_down
			else:
				return estados.quieto_mallas
			
		estados.quieto_mallas:
			if !ente.QuietoEnMalla():
				print("se movio")
				if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
					return estados.camina_mallas_left_right
				
				if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):
					return estados.camina_mallas_up_down
			pass
		
		estados.camina_mallas_up_down, estados.camina_mallas_left_right:
			if ente.QuietoEnMalla():
				return estados.quieto_mallas
			
			if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
					return estados.camina_mallas_left_right
				
			if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):
				return estados.camina_mallas_up_down
			
			pass
			
	ente.get_node("Label").text = estado
	
func _entrar_estado(nuevo, viejo):
	match nuevo:
		estados.quieto_mallas:
			anim.play("malla_quieto")

		
		estados.camina_mallas_left_right:
			anim.play("malla_caminar_left_right")

		
		estados.camina_mallas_up_down:
			anim.play("malla_caminar_up_down")
