extends Node
class_name Objetivo

signal objetivo_terminado() #emitir cuando se termina el objetivo.

"""
CLASE BASE PARA CONSTRUIR OBJETIVOS
"""
export (String) var titulo:String

#Si el objetivo está activo:
export (bool) var activo:bool = false

export (bool) var terminado:bool = false

func _ready():
	connect("objetivo_terminado",get_parent(),"VerificarObjetivosCumplidos")
	if !is_connected("objetivo_terminado",self,"_on_Objetivo_objetivo_terminado"):
		connect("objetivo_terminado",self,"_on_Objetivo_objetivo_terminado")

func AfterCargar():
	pass

func _on_Objetivo_objetivo_terminado():
	terminado = true
	activo = false
	
	pass # Replace with function body.
