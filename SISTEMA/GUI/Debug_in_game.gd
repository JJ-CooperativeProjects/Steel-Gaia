extends Panel
class_name DebuggInGame

"""
Una interfaz para mostrar resultados 
de la consola en pantalla en tinempo de 
ejecusión de los proyectos exportados
"""
##Para controlar el máximo tamaño del texto.
export (int) var max_lineas:int = 250

func _ready():
	Memoria.consola_debug = self
	

func _unhandled_input(event):
	if event.is_action_pressed("debugg"):
		visible = true if visible == false else false

func PonerEnConsola(text:Array):
	var cadena:String = $ScrollContainer/Label.text + "\n"
	for i in text:
		cadena = cadena + str(i)
		if cadena.length() > max_lineas:
			cadena = cadena.right(max_lineas - str(i).length())
		$ScrollContainer/Label.text = cadena
