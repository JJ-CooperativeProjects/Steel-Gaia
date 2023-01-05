extends Trampa
class_name TrampaMinaElectromagnetica

export (float) var max_distancia_salto:float = 32.00

enum estados{ESPERANDO, APAGADA, SALTANDO,CARGANDO,ESTALLANDO,MUERTE}
var estado:int = estados.ESPERANDO


func _ready():
	estado = estados.ESPERANDO if activa else estados.APAGADA
	$AnimationPlayer.play("esperando") if estado == estados.ESPERANDO else $AnimationPlayer.play("apagada")

func Activar():
	lista_para_reactivar = false
	estado = estados.ESPERANDO
	$AnimationPlayer.play("esperando")
	_on_ZonaActivacion_body_entered(self)
	pass

func Desactivar():
	pass

#func _process(delta):
#	#$Label.text = str(estado)
	

func _on_ZonaActivacion_body_entered(body):
	if estado == estados.ESPERANDO:
		estado = estados.SALTANDO
		var tween:SceneTreeTween = get_tree().create_tween()
		tween.tween_property(self,"position:y",position.y -max_distancia_salto,0.32).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		yield(tween,"finished")
		
		estado = estados.CARGANDO
		$AnimationPlayer.play("cargando")
		yield($AnimationPlayer,"animation_finished")
		
		estado = estados.ESTALLANDO
		$AnimationPlayer.play("estallando")
		yield($AnimationPlayer,"animation_finished")
		queue_free()
		pass
	pass # Replace with function body.
