extends Habilidad

var ente:Ente
var MEF_padre:Node
var habilidades_padre:Node

var habilidades_desactivadas:Array

func _ready():
	_agregar_estado("modo_cinematica")
	_agregar_estado("escuchar")
	
	poner_estado_deferred("escuchar")
	
	set_deferred("ente", get_parent().get_parent())
	set_deferred("MEF_padre", get_parent().get_parent().get_node("MEF"))
	set_deferred("habilidades_padre", get_parent())
	
	Memoria.connect("modo_cinematica",self,"escuchar_modo_cinematica")


func _physics_process(delta):
	match estado:
		estados.modo_cinematica:
			ente.AplicarGravedad(delta)
			ente.movimiento.y = ente.move_and_slide_with_snap(ente.movimiento + ente.AjustarVectorImpulso(),ente.vector_snap,Vector2.UP,true,4,ente.SNAP_ANGULO).y
			


func _entrar_estado(nuevo, viejo):
	match nuevo:
		estados.modo_cinematica:
			ente.movimiento.x = 0
			ente.anim.play("quieto")
			



func escuchar_modo_cinematica(valor:bool):
	if valor:
		MEF_padre.set_physics_process(false)
		MEF_padre.set_process(false)
		
		for i in habilidades_padre.get_children():
			var hab:= i as Habilidad

			if hab != self:
				hab.set_process_input(false)
				hab.set_process(false)
				hab.set_physics_process(false)
		
		poner_estado_deferred(estados.modo_cinematica)
		return
	
	MEF_padre.set_physics_process(true)
	MEF_padre.set_process(true)
	
	for i in habilidades_padre.get_children():
		var hab:= i as Habilidad
		
		if hab != self:
			hab.set_process_input(true)
			hab.set_process(true)
			hab.set_physics_process(true)
	
	poner_estado_deferred(estados.escuchar)
