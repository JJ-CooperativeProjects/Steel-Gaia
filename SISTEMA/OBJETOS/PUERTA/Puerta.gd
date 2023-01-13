extends Trampa

export (bool) var esta_cerrada:bool = false

func _ready():
	Memoria.connect("datos_cargados",self,"DespuesCargar")
	

func Activar():
	if esta_cerrada:
		$AnimationPlayer.play("abrir")
		esta_cerrada = false
	
	else:
		$AnimationPlayer.play("cerrar")
		esta_cerrada = true
	# = false
	
func Salvar(data_vacio:Dictionary= {})->Dictionary:
	data_vacio = .Salvar({})
	data_vacio.merge({
		"esta_cerrada": esta_cerrada
	})
	
	return data_vacio
	pass

func Cargar(data:Dictionary):
	.Cargar(data)
	esta_cerrada = data.esta_cerrada



func _on_AnimationPlayer_animation_finished(anim_name):
	#lista_para_reactivar = true
	pass # Replace with function body.

func DespuesCargar():
	if esta_cerrada:
		$AnimationPlayer.play("cerrar")
	else:
		$AnimationPlayer.play("abrir")
	lista_para_reactivar = false
