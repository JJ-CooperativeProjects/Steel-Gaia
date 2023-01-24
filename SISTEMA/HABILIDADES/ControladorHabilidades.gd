extends Node
class_name ControladorHabilidades
"""
ESTA CLASE TIENE METODOS PARA CONTROLAR LAS HABLIDADES:
	Se entiende que es el padre de las habilidades.
"""
#Este método deshabilita todas las habilidades que son posibles desactivar. Se pueden poner excepciones en el Arreglo no_tocar.
func DesactivarHabilidadesDesactivables(no_tocar:Array):
	if get_child_count() > 0:
		for i in get_children():
			var hab:Habilidad = i as Habilidad
			if hab.se_puede_deshabilitar:
				if not no_tocar.has(hab):
					hab.call_deferred("DeshabilitarSelf")
	pass
