extends AreaDisparadorEvento
class_name AreaDisparadorEventoPorTecla

signal teclas_pulsadas()	#Emitido cuando se consiguen pulsar la(s) tecla(s)

export (Array, String) var inputs:Array = []

var zona_activa:bool = false
var count_pulsadas:int = 0 #Cuenta las teclas pulsadas. Cuando coincida con el size de inputs, se considera que todas han sido pulsadas.

"""
DEFINE UN AREA ESPECIAL PARA ACTIVAR EVENTOS CUANDO EL USUARIO ENTRA EN
LA ZONA Y A LA VEZ PULSA CIERTA(s) TECLA(s).
"""
func _ready():
	EsDesactivada()
	pass
	
func _input(event):
	if activo:
		
		for i in inputs:
			if event.is_action_pressed(i):
				count_pulsadas += 1
			
			if event.is_action_released(i):
				if count_pulsadas > 0:
					count_pulsadas -= 1
		
		if count_pulsadas == inputs.size():
			emit_signal("teclas_pulsadas")
			count_pulsadas = 0
			print("g")
			activo = false

func EsActivada():
	set_physics_process(true)
	set_process(true)
	set_process_input(true)
	

func EsDesactivada():
	set_physics_process(false)
	set_process(false)
	set_process_input(false)

func _on_AreaDisparadorEvento_body_entered(body):
	EsActivada()
	pass



func _on_AreaDisparadorEvento_por_tecla_body_exited(body):
	EsDesactivada()
	pass # Replace with function body.
