extends VisibilityNotifier2D
class_name AreaVisibilidad
"""
AREA DE VISIBILIDAD MODIFICADA PARA ADAPTARSE A LAS NECESIDADES DEL PROYECTO.
"""
export (bool) var desactivar_phisics:bool = false
export (bool) var desactivar_animaciones:bool = false
export (bool) var desactivar_process:bool = false
export (bool) var desactivar_particulas:bool = false
export (bool) var desactivar_inputs:bool = false
export (bool) var desactivar_colisiones:bool = false

export (Array,NodePath) var nodos_a_procesar:Array 
 
 
func _ready():
	pass # Replace with function body.

#Si aplicar: desactiva todo ; si aplicar = false, lo activa todo.
func ProcesarNodos(aplciar:bool = true):
	match aplciar:
		true:
			for i in nodos_a_procesar:
				var nodo:Node = get_node(i) as Node
				if is_instance_valid(nodo):
					#Si es un AnimationPalyer:
					if desactivar_animaciones:
						if nodo is AnimationPlayer:
	#						if nodo.find_animation(nodo.get_animation("quieto")) != "":
	#							nodo.play("quieto")
							nodo.stop(true)
					
					if desactivar_particulas:
						if nodo is Particles2D:
							nodo.emitting = false
					
					if desactivar_phisics:
						nodo.set_physics_process(false)
					
					if desactivar_process:
						nodo.set_process(false)
						
					if desactivar_inputs:
						nodo.set_process_input(false)
						nodo.set_process_unhandled_input(false)
					
					if desactivar_colisiones:
						if nodo is RayCast2D:
							nodo.set_deferred("enabled",false)
						
						elif nodo is CollisionShape2D:
							nodo.set_deferred("disabled",true)
			
			prints(name, "Deshabilitado!")
		false:
			for i in nodos_a_procesar:
				var nodo:Node = get_node(i) as Node
				if is_instance_valid(nodo):
					#Si es un AnimationPalyer:
					if nodo is AnimationPlayer:
						nodo.play(nodo.current_animation)
					
					elif nodo is Particles2D:
						nodo.emitting = true
					
					elif nodo is RayCast2D:
						nodo.set_deferred("enabled",true)
					
					elif nodo is CollisionShape2D:
						nodo.set_deferred("disabled",false)
					
					nodo.set_physics_process(true)
					
					nodo.set_process(true)
						
					nodo.set_process_input(true)
					nodo.set_process_unhandled_input(true)
			
			prints(name, "Habilitado!")
