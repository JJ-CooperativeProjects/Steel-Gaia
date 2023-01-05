extends Node2D
class_name Nivel
"""
BASE PARA CONSTRUIR NIVELES
"""

func _init():
	Memoria.nivel_actual = self

func _unhandled_input(event):
	if event.is_action_pressed("F1"):
		#print(2423423)
		$CanvasLayer/Control/ColorRect.visible = true if $CanvasLayer/Control/ColorRect.visible == false else false
		
		Memoria.debug = true if $CanvasLayer/Control/ColorRect.visible else false
		$CanvasLayer/Control/Label.visible = !Memoria.debug
		pass

func _ready():
	#Activa los efectos especiales:
	$BACK/ParallaxBackground.visible = true
	$BACK/Canvas.visible = true
	GuiJugador.visible = true
	
	#Gestionar la forma en que carga el nivel:
	if Memoria.cambiando:
		var data:BaseSaveData = load("res://SISTEMA/GLOBAL/RESOURCES/SAVE_DATA/Saves/SAVE_auto.tres")
		
		
		
		if !Memoria.spawn_point_id == "":
			yield(get_tree(),"idle_frame")
			Memoria.camara_actual.get_parent().queue_free()
			Memoria.jugador.queue_free()
			var nuevo_jugador:Jugador = load("res://UTILIZABLES/Entes/Jugador/Jugador.tscn").instance()
			Memoria.jugador = nuevo_jugador
			
			
			var spawn:Intercambiador = $AREAS_EVENTOS.get_node(Memoria.spawn_point_id)
			Memoria.jugador.direccion_mira = spawn.direccion_del_jugador
			Memoria.jugador.global_position = spawn.global_position
			get_node("JUGADORES").add_child(nuevo_jugador)
			
		Memoria.jugador.CargarDatosJugador(data,false,false)
		Memoria.jugador.set_vitalidad(Memoria.jugador.vitalidad)
		Memoria.jugador.set_energia(Memoria.jugador.energia)
		
		#Cargar persistentes:
		var persistentes:Array = []
		
		var id = data.ObtenerNivelEnSalva(name)
		
		if not id == null:
			persistentes = data.niveles_visitados[id].persistentes
		
		for i in persistentes:
			var dato_persistente:Dictionary = i
			#Verificar si hay un nodo de este en escena:
			var nodo:= Memoria.nivel_actual.get_node_or_null(dato_persistente.ruta_nodo) as Node2D
			if nodo:
				nodo.Cargar(dato_persistente,null)
			else:
				var nuevo_nodo:= load(dato_persistente.ruta_file).instance() as Node2D
				nuevo_nodo.Cargar(dato_persistente,nuevo_nodo)
					
	
		Memoria.cambiando = false


func _input(event):
	if event.is_action_pressed("salvar"):
		Memoria.SalvarRapido()
		#Memoria.SalvarNuevo("Prueba1.tres")
