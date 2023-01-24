extends Trampa
class_name TrampaLanzallamas

export (float) var tiempo_reposo:float = 8.0
export (float) var tiempo_llamas:float = 2.0
export (float) var tiempo_de_carga:float = 0.85
##El tiempo de arranque es una variable se usa al iniciar el lanzallamas, para que todos no comiencen al mismo tiempo.
export (float) var tiempo_arranque:float = 4.0

enum estados {STAND,ENCENDER,FLAMEAR,APAGAR,CARGANDO}
var estado:int = estados.STAND

var timer:SceneTreeTimer = null
func _ready():
	EnReady()


func EnReady():
	timer = get_tree().create_timer(tiempo_arranque)
	timer.connect("timeout",self,"Pasar_A_Cargar")
	#$AnimatedSprite.play("stand")
	$AnimationPlayer.play("stand")
	$AreaDamage.objetivo = self

func Pasar_A_Cargar():
	estado = estados.CARGANDO
	#$AnimatedSprite.play("cargando")
	$AnimationPlayer.play("cargando")
	timer = get_tree().create_timer(tiempo_de_carga)
	timer.connect("timeout",self,"Pasar_A_Encender")

func Pasar_A_Encender():
	estado = estados.ENCENDER
	#$AnimatedSprite.play("encender")
	$AnimationPlayer.play("encender")

func Pasar_A_Apagar():
	estado = estados.APAGAR
	#$AnimatedSprite.play("apagar")
	$AnimationPlayer.play("apagar")
	
func _on_AnimatedSprite_animation_finished():
	match $AnimatedSprite.animation:
		"encender":
			estado = estados.FLAMEAR
			timer = get_tree().create_timer(tiempo_llamas)
			timer.connect("timeout",self,"Pasar_A_Apagar")
			$AnimatedSprite.play("flamear")
			pass
		
		"apagar":
			estado = estados.STAND
			timer = get_tree().create_timer(tiempo_reposo)
			timer.connect("timeout",self,"Pasar_A_Cargar")
			#$AnimatedSprite.play("stand")
			$AnimationPlayer.play("stand")
	pass # Replace with function body.



func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"encender":
			estado = estados.FLAMEAR
			timer = get_tree().create_timer(tiempo_llamas)
			timer.connect("timeout",self,"Pasar_A_Apagar")
			#$AnimatedSprite.play("flamear")
			$AnimationPlayer.play("flamear")
			pass
		
		"apagar":
			estado = estados.STAND
			timer = get_tree().create_timer(tiempo_reposo)
			timer.connect("timeout",self,"Pasar_A_Cargar")
			#$AnimatedSprite.play("stand")
			$AnimationPlayer.play("stand")
	pass # Replace with function body.
