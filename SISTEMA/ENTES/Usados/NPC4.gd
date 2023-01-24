tool
extends Enemigo

onready var anims:AnimatedSprite = $Cuerpo/AnimatedSprite

export (float) var tiempo_ronda_patrulla:float = 2
export (int,-1,1) var posicion_inicial_mira:int = 1 
var posicion_inicio:Vector2 = Vector2.ZERO

func _ready():
	posicion_inicio = global_position
	if posicion_inicial_mira == -1:
		Girar()

func Levitar():
#	var tween:SceneTreeTween = get_tree().create_tween()
#	tween.set_loops(0)
#	tween.tween_property(self, "movimiento:y",float(100),1).set_trans(Tween.TRANS_CUBIC)
#	tween.tween_property(self, "movimiento:y",float(-100),1).set_trans(Tween.TRANS_CUBIC)
	$movimientos.play("Levitar",-1,1.5)
	
func Patrullar():
	$movimientos.play("caminar")
	match direccion_mira:
		1:
			movimiento = move_and_slide(Vector2(vector_impulsos.x,velocidad_actual_y))
		-1:
			movimiento = move_and_slide(Vector2(-vector_impulsos.x,velocidad_actual_y))
		


func DispararSierras():
	var sierras = load("res://SISTEMA/GLOBAL/Trayectorias_disparo_sierras.tscn").instance()
	sierras.global_position = global_position
	Memoria.nivel_actual.add_child(sierras)
