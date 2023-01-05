extends Trampa
class_name TrampaNanoBots

export (int, 1, 20) var numero_bolas:int = 4

onready var bola:PackedScene = preload("res://SISTEMA/OBJETOS/NANO-BOLA/NanoBola.tscn")

enum estados{ESPERANDO,APAGADA,ACTIVA,MUERTE}
var estado = estados.ESPERANDO

func _ready():
	estado = estados.ESPERANDO if activa else estados.APAGADA

func Activar():
	pass

func Desactivar():
	pass


func CrearNanos():
	for i in numero_bolas:
		var new_nano:NanoBola = bola.instance()
		new_nano.global_position = $Position2D.global_position
		Memoria.nivel_actual.add_child(new_nano)

func _on_ZonaActivacion_body_entered(body):
	if estado == estados.ESPERANDO:
		lista_para_reactivar = false
		estado = estados.ACTIVA
		$AnimationPlayer.play("romper")
		yield($AnimationPlayer,"animation_finished")
		queue_free()
		pass
	pass # Replace with function body.
