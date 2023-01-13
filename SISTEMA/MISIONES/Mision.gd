extends Node
class_name Mision

signal mision_terminada() #Emitida cuando la mision termine.
"""
CLASE QUE DEFINE EL CONCEPTO DE MISION.

Las misiones se guardan como hijas de un nodo GESTOR_MISIONES.

Una misión tiene como hijos uno o varios objetivos. Se consifera una 
misión terminada cuando todos los objetivos estén terminados.
"""
export (String) var titulo:String
export (String,MULTILINE) var descripcion:String


##Los estados que definen la situación actual de una mision.
enum estados {NINGUNO,EN_CURSO,TERMINADA,FALLADA}
export (estados) var estado:int = estados.NINGUNO

##Metodo que se analiza al cargar una partida para ajustar cambios si la mision se concluyó.
func AfterTerminada():
	pass

##
func VerificarObjetivosCumplidos():
	for i in get_children():
		var obj:Objetivo = i as Objetivo
		
		if !obj.terminado:
			return 
	
	estado = estados.TERMINADA
	emit_signal("mision_terminada")


func _on_Mision_mision_terminada():
	prints("Mision terminada:",name)
	pass # Replace with function body.
