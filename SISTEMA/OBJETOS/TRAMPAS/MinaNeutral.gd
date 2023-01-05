extends Trampa
class_name MinaNeutral

export (float) var tiempo:float = 2.2

#onready var wave =  $CanvasLayer/Rect

var temporizador:SceneTreeTimer = null

enum estados {ENCENDIDA, APAGADA, ANTES_DE_EXPLOTAR, EXPLOSION}
var estado:int  = estados.ENCENDIDA



var coeficiente:float = 0.05
func _ready():
	_arranque()

func _arranque():
	$AnimationPlayer.play("encendida")

func _input(event):
	if event.is_action_pressed("ui_accept"):
		#print(get_viewport_transform().origin)
		pass
func explotar():
	estado = estados.EXPLOSION
	#wave.material.set_shader_param("global_position", get_viewport_transform().origin)
	$AnimationPlayer.play("explosion")
	$AnimationPlayer.connect("animation_finished",self,"_on_terminar_explosion")

func Activar():
	lista_para_reactivar = false
	pass
	
func _process(delta):
	
	if estado == estados.ANTES_DE_EXPLOTAR:
		$AnimationPlayer.play("descuento",-1,coeficiente)


func set_monitoring(val:bool):
	$AreaDamage.set_deferred("monitoring",val)

func _on_terminar_explosion(animacion:String):
	if estado == estados.EXPLOSION:
		queue_free()


func _on_ZonaActivacion_body_entered(body):
	#print("dasd")
	if estado == estados.ENCENDIDA:
		var tween:SceneTreeTween = get_tree().create_tween()
		tween.tween_property(self,"coeficiente",2.52,tiempo).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
		#Activa la mina:
		temporizador = get_tree().create_timer(tiempo)
		temporizador.connect("timeout",self,"explotar")
		
		estado = estados.ANTES_DE_EXPLOTAR
	pass # Replace with function body.
