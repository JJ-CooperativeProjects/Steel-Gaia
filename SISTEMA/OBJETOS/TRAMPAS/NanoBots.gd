extends Trampa
class_name TrampaNanoBots

export (int, 1, 20) var numero_bolas:int = 4

onready var bola:PackedScene = preload("res://SISTEMA/OBJETOS/NANO-BOLA/NanoBola.tscn")

enum estados{ESPERANDO,APAGADA,ACTIVA,MUERTE}
var estado = estados.ESPERANDO

var nanos:Array = []

func _ready():
	estado = estados.ESPERANDO if activa else estados.APAGADA
	
	CrearNanos()

func Activar():
	pass

func Desactivar():
	pass


			
func CrearNanos():
	for i in numero_bolas:
		var new_nano:NanoBola = bola.instance()
		new_nano.global_position = $Position2D.global_position
		Memoria.nivel_actual.call_deferred("add_child",new_nano)#add_child(new_nano)
		nanos.append(new_nano)

func ActivarNanos():
	for i in nanos:
		i.set_process(true)
		i.set_physics_process(true)
		i.set_deferred("mode",0)
		i.set_deferred("linear_velocity", Vector2(rand_range(-30,30),rand_range(-30,30)))
	
	nanos.clear()

func _on_ZonaActivacion_body_entered(body):
	if estado == estados.ESPERANDO:
		lista_para_reactivar = false
		estado = estados.ACTIVA
		ActivarNanos()
		$AnimationPlayer.play("romper")
		yield($AnimationPlayer,"animation_finished")
		queue_free()
		pass
	pass # Replace with function body.
