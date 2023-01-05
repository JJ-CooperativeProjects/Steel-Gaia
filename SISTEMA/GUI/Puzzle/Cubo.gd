extends TextureRect
class_name CuboPuzzle
"""
BASE QUE DEFINE A UN CUBO
"""

#Almacena la coordenada de la conexion antes de este cubo. Si el vector es negativo, será posicion de INICIO.
var posicion_anterior:Vector2 
var posicion_mia:Vector2 
#Si posicion_despues es negativa, se entiend que es un bloque FINAL.
var posicion_despues:Vector2 
#Tipo de cubo:
export (String, "recto", "curvo", "bloque", "vacio") var tipo:String 

enum estados {NADA, EN_PUZZLE, EN_LISTA, GUIA}
var estado:int = estados.NADA

var esta_correcto:bool = false
var puede_girar:bool = false

#Datos que recibe:
var tipo_correcto:String = ""
var posicion_correcta_puzzle:Vector2 = Vector2.ZERO
var rotacion_correcta:int = 0



var prueba:Dictionary = {"rotacion": 180}

###
func get_drag_data(position):
	if ![estados.NADA, estados.GUIA].has(estado): 
		var textura:TextureRect = TextureRect.new()
		textura.texture = $Sprite2.texture
		textura.expand = true
		textura.rect_size = Vector2(96, 96)
		
		textura.rect_rotation = $Sprite2.rotation_degrees
		set_drag_preview(textura)
		return self
###
func can_drop_data(position, data):
	if data.estado == estados.EN_LISTA  and estado == estados.GUIA:
		return true
###
func drop_data(position, data):
	
	var pos:int = get_index()
	#prints(pos,name)
	
	var new = CrearNuevoCubo(data.tipo, estados.EN_PUZZLE, posicion_correcta_puzzle, rotacion_correcta, data.get_node("Sprite2").rotation_degrees,tipo)
	get_parent().add_child_below_node(self,new)
	
	var count = 0
	for i in get_parent().mi_puzzle.game_data:
		if i.cubo == self: 
			break
		count+= 1
		
	get_parent().mi_puzzle.game_data[count].cubo = new
	
	#Hacer una comprobacion para ver si está correcto:
	if new.ComprobarCorrecto():
		new.esta_correcto = true
		new.emit_signal("mouse_exited")
		
	data.queue_free()
	
	#Comprobar si todos los cubos están bien, terminar el juego:
	if get_parent().mi_puzzle.TodosCorrectos():
		get_parent().mi_puzzle.emit_signal("juego_ganado")
		#print("todo OK, terminar partida")
	
	queue_free()
	pass

##
func CrearNuevoCubo(n_tipo:String, n_estado:int, n_posicion_correcta:Vector2, n_rotacion_correcta:int,rotacion:int,n_tipo_correcto:String)->CuboPuzzle:
	var new_cubo
	
	match n_tipo:
		"recto":
			new_cubo = load("res://SISTEMA/GUI/Puzzle/CuboRecto.tscn").instance()
			pass
		"curvo":
			new_cubo = load("res://SISTEMA/GUI/Puzzle/Cubo90g.tscn").instance()
			pass
			
	new_cubo.tipo = n_tipo
	new_cubo.estado = n_estado
	new_cubo.posicion_correcta_puzzle = n_posicion_correcta
	new_cubo.rotacion_correcta = n_rotacion_correcta
	new_cubo.get_node("Sprite2").rotation_degrees = rotacion
	new_cubo.tipo_correcto = n_tipo_correcto
	
	return new_cubo
	pass

##------

func _on_Cubo_mouse_entered():
	if estado == estados.EN_PUZZLE:
		puede_girar = true
		#modulate = Color.aqua
	pass # Replace with function body.

func _on_Cubo_mouse_exited():
	if estado == estados.EN_PUZZLE:
		puede_girar = false
		if esta_correcto:
			modulate = Color.green
		else:
			modulate = Color.red
	pass # Replace with function body.

func _on_Cubo90g_gui_input(event):
	if estado == estados.EN_PUZZLE:
		if event is InputEventMouseButton:
			if event.pressed and event.button_index == 2:
				var res = int($Sprite2.rotation_degrees +90)
				
				if res < 360:
					$Sprite2.rotation_degrees += 90
					
				else:
					$Sprite2.rotation_degrees = 0
					#yield(get_tree(),"idle_frame")
				$Sprite2.rotation_degrees = int($Sprite2.rotation_degrees)
				#print($Sprite2.rotation_degrees)
				
				if ComprobarCorrecto():
					esta_correcto = true
					emit_signal("mouse_exited")
				else:
					esta_correcto = false
					emit_signal("mouse_exited")
					
				#Comprobar si todos los cubos están bien, terminar el juego:
				if get_parent().mi_puzzle.TodosCorrectos():
					get_parent().mi_puzzle.emit_signal("juego_ganado")
					#print("todo OK, terminar partida")
			
			#DEVOLVER EL CUBO A LA LISTA SI ESTA MAL PUESTO:
			if event.pressed and event.button_index == 1:
				if estado == estados.EN_PUZZLE:
					var new = CrearNuevoCubo(tipo, estados.EN_LISTA, posicion_correcta_puzzle, rotacion_correcta, get_node("Sprite2").rotation_degrees,"")
					
					get_parent().mi_puzzle.get_node("ScrollContainer/VBoxContainer").add_child(new)
					
					var count = 0
					for i in get_parent().mi_puzzle.game_data:
						if i.cubo == self: 
							break
						count+= 1
					
					var rotacion_original = get_parent().mi_puzzle.game_data[count].rotacion_correcta
					var posicion_original = get_parent().mi_puzzle.game_data[count].posicion_actual
					var tipo_original = get_parent().mi_puzzle.game_data[count].tipo_cubo
					
					var cubo_original = CrearNuevoCubo(tipo_original,estados.GUIA,posicion_original,rotacion_original,rotacion_original,"")
					cubo_original.get_node("Sprite2").visible = false
					get_parent().add_child_below_node(self,cubo_original)
					
					
					get_parent().mi_puzzle.game_data[count].cubo = cubo_original
					
					queue_free()
					
func ComprobarCorrecto()->bool:
	if tipo == tipo_correcto and get_node("Sprite2").rotation_degrees == rotacion_correcta:
		return true
	return false
#	match event:
#		pass
#	if puede_girar
	pass # Replace with function body.
