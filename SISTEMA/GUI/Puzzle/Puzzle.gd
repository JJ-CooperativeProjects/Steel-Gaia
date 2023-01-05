extends Control
class_name Puzzle

"""
BASE PARA QUE DEFINE AL PUZZLE.
"""
signal juego_ganado()
signal juego_perdido(id)

export (float) var tiempo_partida:float = 60
var contador:float = tiempo_partida		setget set_contador

var matriz:Array = CrearMatriz(4,4)
#Array de Diccionarios que almacena los datos de una partida generada, almacenando informacion de cada cubo.
var game_data:Array = []

var cords_inicio:Dictionary = {}


onready var cubo = preload("res://SISTEMA/GUI/Puzzle/Cubo.tscn")
onready var cubo_recto = preload("res://SISTEMA/GUI/Puzzle/CuboRecto.tscn")
onready var cubo_90g = preload("res://SISTEMA/GUI/Puzzle/Cubo90g.tscn")

var camino_tubos:Array = []

var en_pausa:bool = false

func set_contador(valor:float):
	contador = valor
	if Chequear_si_orbe():
		$ProgressBar.value = contador / tiempo_partida*100

func _ready():
	#GuiJugador.visible = false
	get_tree().paused = true
	
	if Chequear_si_orbe():
		$Orbe.visible = true
	
	GenerarPartidaNueva()
	en_pausa = false

	pass

func _process(delta):
	if not en_pausa:
		set_contador(contador - 1 *delta) 

#func _input(event):
#	if event.is_action_pressed("salto"):
#		GenerarPartidaNueva()
	pass
			
		
		
#Manejo de la matriz:
func CrearMatriz(cant_x:int, cant_y:int)->Array:
	var arreglo:Array = []
	for y in range(cant_y):
		arreglo.push_back([])
		
		for x in range(cant_x):
			arreglo[y].push_back(0)
			
	return arreglo
	
#Pone un valor en la coordanada especifica. el valor tiene que estar dentro del rango de la matriz.
#Los posibles valores seran:
# 0 =  vacio
# 1 = debe ir un cubo
# -1 = bloque
func PonerValor(x:int,y:int, valor):
	matriz[x][y] = valor
	pass
	
#Retorna el valor de una coordenada de la matriz. Retorna null si el valor está fuera de la matriz.
func ObtenerValorMatriz(x:int,y:int):
	if (x < 0 or x > matriz.size()-1) or (y < 0 or y > matriz.size() -1):
		return null
	
	return matriz[x][y] 
	pass

#Pone el valor de una coordenada a 0 y devuelve el actual valor.
func LimpiarValor(x:int, y:int):
	matriz[x][y] = 0
	pass
	
#Algoritmo que genera un puzzle nuevo:
#El máximo de cubos, indica la cantidad de cubos con los que se completa el puzzle.
#Retorna un Arreglo con el recorrido en Vector2 o un arreglo vacio si el camino no es valido.
func GenerarPuzzle(maximo_cubos:int)->Array:
	#Encontrar una entrada:
	var punto_inicio:Vector2 = ObtenerCoordenadaPuntoInicio()[randi()%ObtenerCantidadCubosInicio()]
	var punto_final:Vector2
	var punto_actual:Vector2 = punto_inicio
	
	var lista_puntos_visitados:Array = []
	lista_puntos_visitados.append(punto_inicio)
	lista_puntos_visitados.append(punto_final)
	var recorrido:Array = []
	recorrido.append(punto_actual)
	
	var conteo_cilos:int = 0	#No supera el maximo_cubos.
	
	
	for i in maximo_cubos-1:
		var caminos:Array = DeterminarCaminos(punto_actual,lista_puntos_visitados)

		#Tomar un punto y seguir:
		if !caminos.empty():
			punto_actual = caminos[randi()%caminos.size()]
			recorrido.append(punto_actual)
			lista_puntos_visitados.append(punto_actual)
			conteo_cilos += 1
		else:
			GenerarPuzzle(maximo_cubos)
			continue

	return recorrido
	pass

func PosiblesCaminos(coord:Vector2)->Array:
	var izquierda:Vector2 = Vector2(coord.x-1,coord.y)
	var arriba:Vector2 = Vector2(coord.x,coord.y-1)
	var derecha:Vector2 = Vector2(coord.x+1,coord.y)
	var abajo:Vector2 = Vector2(coord.x,coord.y+1)
	return [izquierda,arriba,derecha,abajo]
	
func DeterminarCaminos(punto_actual:Vector2,lista_puntos_visitados:Array)->Array:

	var posibles_caminos:Array = PosiblesCaminos(punto_actual)
	var caminos:Array = []
	
	#Verificar si son válidos los posibles caminos:
	for c in posibles_caminos:
		var vec:Vector2 = c as Vector2
		if ObtenerValorMatriz(vec.x,vec.y) != null and not lista_puntos_visitados.has(c):
			caminos.push_back(c)
	
	if caminos.empty():
		lista_puntos_visitados.erase(punto_actual)
		punto_actual = lista_puntos_visitados[lista_puntos_visitados.size()-1]
		DeterminarCaminos(punto_actual,lista_puntos_visitados)
	
	return caminos
	pass

func ObtenerCantidadCubosInicio()->int:
	var conteo:int = 0
	for i in range(matriz.size()):
		if i > 0 and i < matriz.size()-1:
			conteo += 2
		elif i == 0 or i == matriz.size()-1:
			conteo += matriz.size()
	return conteo
			
	pass
	
#Devuelve un arreglo con todos los posibles puntos de inicio en Vectores.
func ObtenerCoordenadaPuntoInicio()->Array:
	var posibles_puntos:Array = []

	for i in range(matriz.size()):
		var y:int = i
		
		for t in range(matriz[i].size()):
			var x:int = t
			
			if x == 0 or y == 0 or x == matriz.size()-1 or y == matriz[i].size() -1:
				posibles_puntos.push_back(Vector2(x,y))
	
	return posibles_puntos
	pass

#Algoritmo que pone los cubos correctamente:
func PonerCubos(conteo:int,cantidad_max:int,caminos:Array):
	var new_cubo:CuboPuzzle
	match conteo:
		0:
			#Analiza el primer punto y el siguiente:
			var punto_a:Vector2 = caminos[0]
			var punto_b:Vector2 = caminos[1]
			#Determinar la posicion entre ellos:
			var relacion:String = DeterminarRelacionEntreDosPuntos(Vector2(-1,-1),punto_a,punto_b)
			match relacion:
				"inicio_derecha":
					new_cubo = cubo_recto.instance() as CuboPuzzle
					
					pass
				"inicio_arriba":
					pass
				"inicio_izquierda":
					pass
				"inicio_abajo":
					pass
			pass
		cantidad_max:
			pass
		
		_:
			pass

#Devuelve la relacion en un String:
#Poner Vector2(-1,-1)  para no testear el vector.
func DeterminarRelacionEntreDosPuntos(punto_a:Vector2,punto_actual:Vector2,punto_b:Vector2)->String:
	#Si es el punto de inicio:
	if punto_a == Vector2(-1,-1):
		#a la derecha.
		if (punto_actual.x +1 == punto_b.x) and (punto_actual.y == punto_b.y):
			return ("inicio_derecha")
		#arriba:
		elif (punto_actual.x == punto_b.x) and (punto_actual.y -1 == punto_b.y):
			return("inicio_arriba")
		elif (punto_actual.x -1 == punto_b.x) and (punto_actual.y == punto_b.y):
			return("inicio_izquierda")
		else:
			return("inicio_abajo")
		pass
	#Si es el punto final:
	elif punto_b == Vector2(-1,-1):
		pass
	#Si es otro punto:
	else:
		pass
	
	return ""

#Metodo que analiza las posiciones anterior,actual y suguiente de una conexion para saber que cubo crear.
func DeterminarCubo(pos_antes:Vector2, pos_actual:Vector2, pos_despues:Vector2,size_matriz:Vector2)->Dictionary:
	var data:Dictionary = {}
	var new_cubo = null
	var pos_izquierda:Vector2 = Vector2(pos_actual.x-1,pos_actual.y)
	var pos_derecha:Vector2 = Vector2(pos_actual.x+1,pos_actual.y)
	var pos_arriba:Vector2 = Vector2(pos_actual.x,pos_actual.y-1)
	var pos_abajo:Vector2 = Vector2(pos_actual.x,pos_actual.y+1)
	
	#Si el cubo está en la esquina superior izquierda:
	match pos_antes:
		pos_izquierda:
			match pos_despues:
				pos_derecha:
					new_cubo = cubo_recto.instance() 
					new_cubo.get_node("Sprite2").rotation_degrees = 90
					pass
				pos_arriba:
					new_cubo = cubo_90g.instance() 
					new_cubo.get_node("Sprite2").rotation_degrees = 180
					pass
				pos_abajo:
					new_cubo = cubo_90g.instance() 
					new_cubo.get_node("Sprite2").rotation_degrees = 90
					pass

		pos_derecha:
			match pos_despues:
				pos_izquierda:
					new_cubo = cubo_recto.instance() 
					new_cubo.get_node("Sprite2").rotation_degrees = 90
					pass
				pos_arriba:
					new_cubo = cubo_90g.instance() 
					new_cubo.get_node("Sprite2").rotation_degrees = 270
					pass
				pos_abajo:
					new_cubo = cubo_90g.instance() 
					new_cubo.get_node("Sprite2").rotation_degrees = 0
					pass
			pass
		pos_arriba:
			match pos_despues:
				pos_derecha:
					new_cubo = cubo_90g.instance() 
					new_cubo.get_node("Sprite2").rotation_degrees = 270
					pass
				pos_izquierda:
					new_cubo = cubo_90g.instance() 
					new_cubo.get_node("Sprite2").rotation_degrees = 180
					pass
				pos_abajo:
					new_cubo = cubo_recto.instance() 
					new_cubo.get_node("Sprite2").rotation_degrees = 0
					
					pass
			pass
		pos_abajo:
			match pos_despues:
				pos_derecha:
					new_cubo = cubo_90g.instance() 
					new_cubo.get_node("Sprite2").rotation_degrees = 0
					pass
				pos_izquierda:
					new_cubo = cubo_90g.instance() 
					new_cubo.get_node("Sprite2").rotation_degrees = 90
					pass
				pos_arriba:
					new_cubo = cubo_recto.instance() 
					new_cubo.get_node("Sprite2").rotation_degrees = 0
					
					pass
			pass
	
	new_cubo.get_node("Sprite2").visible = false
	new_cubo.estado = new_cubo.estados.GUIA
	new_cubo.posicion_correcta_puzzle = pos_actual
	new_cubo.rotacion_correcta = new_cubo.get_node("Sprite2").rotation_degrees
	
	data.cubo = new_cubo
	data.tipo_cubo = new_cubo.tipo
	data.rotacion_correcta = new_cubo.get_node("Sprite2").rotation_degrees
	
	data.posicion_antes = pos_antes
	data.posicion_actual = pos_actual
	data.posicion_despues = pos_despues
	
	return data
	pass

#Crea los cubos disponibles en la lista basado en la cantidad de cubos que el jugador tenga:
func LlenarListaCubos():
	var cubos:Array = []
	for i in range(Memoria.cubos):
		var new_cubo:CuboPuzzle
		var dic:Dictionary = game_data[i]
		if dic.tipo_cubo == "curvo":
			new_cubo = cubo_90g.instance()
			
		elif dic.tipo_cubo == "recto":
			new_cubo = cubo_recto.instance()
			
		new_cubo.posicion_correcta_puzzle = dic.posicion_actual
		new_cubo.rotacion_correcta = dic.rotacion_correcta
		
		new_cubo.get_node("Sprite2").rotation_degrees = [0,90,180,270][randi()%4]
		new_cubo.estado = CuboPuzzle.estados.EN_LISTA
		
		cubos.append(new_cubo)
			
		pass
	
	#Desordena la lista:
	randomize()
	cubos.shuffle()
	
	#Crea los cubos en la lista:
	for i in cubos:
		$ScrollContainer/VBoxContainer.add_child(i)


#Comprobar si todos los cubos estan correctos para terminar el juego:
func TodosCorrectos()->bool:
	for i in game_data:
		if not i.cubo.esta_correcto:
			return false
	return true

func GenerarPartidaNueva():
	game_data.clear()
	set_contador(tiempo_partida)
	
	camino_tubos = GenerarPuzzle(10)
	while camino_tubos.size() != 10 or !ObtenerCoordenadaPuntoInicio().has(camino_tubos.back()):
		camino_tubos = GenerarPuzzle(10)
	#print(camino_tubos)
	
	matriz = CrearMatriz(4,4)
	
	for i in camino_tubos:
		var vec:Vector2 = i as Vector2
		PonerValor(i.x,i.y,1)
	
	for i in $GridContainer.get_children():
		i.queue_free()
	
	var count:int = 0
	var caminos_temp:Array
	caminos_temp.append_array(camino_tubos)
	
	for c in range(matriz.size()):
		for i in range(matriz[c].size()):
			var cord:int = ObtenerValorMatriz(i,c)
			var pos_inicio:Vector2 = camino_tubos.front()
			var pos_final:Vector2 = camino_tubos.back()
			
			var pos_anterior:Vector2
			var pos_despues:Vector2
			
			var new_cubo:CuboPuzzle
			if  cord == 1:
				var cord_actual:Vector2 = Vector2(i,c)
				#SI ES INICIO
				if  cord_actual == pos_inicio:
					#DETERMINAR POSICION ANTERIOR:
					#Posicion antes a la izquierda:
					if cord_actual.x-1 < 0:
						pos_anterior = Vector2(cord_actual.x-1,c)
						cords_inicio.cord_antes_inicio = Vector2(cord_actual.x-1,c)
						 
						pass
					#Posicion antes a la derecha:
					elif cord_actual.x+1 == matriz[0].size():
						pos_anterior = Vector2(cord_actual.x+1,c)
						cords_inicio.cord_antes_inicio = Vector2(cord_actual.x+1,c)
						pass
					#Posicion antes arriba:
					elif cord_actual.y-1 < 0:
						pos_anterior = Vector2(i,cord_actual.y-1)
						cords_inicio.cord_antes_inicio = Vector2(i,cord_actual.y-1)
						pass
					#Posicion antes abajo:
					elif cord_actual.y+1 == matriz.size():
						pos_anterior = Vector2(i,cord_actual.y+1)
						cords_inicio.cord_antes_inicio = Vector2(i,cord_actual.y+1)
						pass
					
					cords_inicio.cord_inicio = cord_actual
					#POSICION DESPUES:
					var pos:int = camino_tubos.find(cord_actual)
					pos_despues = camino_tubos[pos+1]
					
				#SI ES FINAL
				elif cord_actual == pos_final:
					
					#DETERMINAR POSICION ANTERIOR:
					#Posicion antes a la izquierda:
					if cord_actual.x-1 < 0:
						pos_despues = Vector2(cord_actual.x-1,c)
						cords_inicio.cord_despues_final = Vector2(cord_actual.x-1,c)
						pass
					#Posicion antes a la derecha:
					elif cord_actual.x+1 == matriz[0].size():
						pos_despues = Vector2(cord_actual.x+1,c)
						cords_inicio.cord_despues_final =  Vector2(cord_actual.x+1,c)
						pass
					#Posicion antes arriba:
					elif cord_actual.y-1 < 0:
						pos_despues = Vector2(i,cord_actual.y-1)
						cords_inicio.cord_despues_final = Vector2(i,cord_actual.y-1)
						pass
					#Posicion antes abajo:
					elif cord_actual.y+1 == matriz.size():
						pos_despues = Vector2(i,cord_actual.y+1)
						cords_inicio.cord_despues_final = Vector2(i,cord_actual.y+1)
						pass
					
					cords_inicio.cord_final = cord_actual
					#POSICION DESPUES:
					var pos:int = camino_tubos.find(cord_actual)
					pos_anterior = camino_tubos[pos-1]
					
				#OTRO
				else:
					#print(cord_actual)
					
					#POSICIONES:
					var pos:int = camino_tubos.find(cord_actual)
					pos_anterior = camino_tubos[pos-1]
					pos_despues = camino_tubos[pos+1]
				
				
				
				#CREAR EL CUBO:
				var dato = DeterminarCubo(pos_anterior,cord_actual,pos_despues,Vector2(matriz[0].size(),matriz.size()))
				new_cubo = dato.cubo
				game_data.append(dato)
				
				count += 1
			else:
				new_cubo = cubo.instance()
				
				#PonerCubos(count,9,camino_tubos)
			
				
				
			$GridContainer.add_child(new_cubo)
			new_cubo.get_node("Label").text = new_cubo.name
	pass
	
	#CREAR LOS CUBOS EN LA LISTA DE OPCIONES SEGUN LOS QUE EL JUGADOR TENGA:
	for i in $ScrollContainer/VBoxContainer.get_children():
		i.queue_free()
		
	LlenarListaCubos()
	
	#PONER LOS PUNTOS INICIO Y FINAL
	PonerPuntosInicioFinal()
#####
func PonerPuntosInicioFinal():
	for i in $PuntosInicioFinal.get_children():
		i.queue_free()
		
	var pos_antes:Vector2 = cords_inicio.cord_antes_inicio
	var pos_inicio:Vector2 = cords_inicio.cord_inicio
	var pos_despues:Vector2 = cords_inicio.cord_despues_final
	var pos_final:Vector2 = cords_inicio.cord_final
	
	var ico:Sprite = Sprite.new()
	ico.texture = load("res://RECURSOS/IMAGENES/circulo.png")
	var ico2:Sprite = Sprite.new()
	ico2.texture = load("res://RECURSOS/IMAGENES/equis.png")
	ico2.modulate = Color.red
	
	#POS INICIO:
	ico.global_position = $GridContainer.rect_position
	
	var pos_grid:Vector2 = $GridContainer.rect_position
	
	ico.global_position = Vector2((pos_grid.x + (192 * pos_inicio.x)+96), (pos_grid.y + (192 * pos_inicio.y)) + 96)

	$PuntosInicioFinal.add_child(ico)
	
	
	if pos_antes.x < 0:
		ico.global_position.x -= 128

	if pos_antes.y <0:
		ico.global_position.y -= 128

	if pos_antes.x > matriz[0].size()-1:
		ico.global_position.x += 128

	if pos_antes.y > matriz.size() -1:
		ico.global_position.y += 128
	#POS FINAL:
	ico2.global_position = $GridContainer.rect_position
	
	var pos_grid2:Vector2 = $GridContainer.rect_position
	
	ico2.global_position = Vector2((pos_grid.x + (192 * pos_final.x)+96), (pos_grid.y + (192 * pos_final.y)) + 96)

	$PuntosInicioFinal.add_child(ico2)
	
	if pos_despues.x < 0:
		ico2.global_position.x -= 128

	if pos_despues.y <0:
		ico2.global_position.y -= 128

	if pos_despues.x > matriz[0].size()-1:
		ico2.global_position.x += 128

	if pos_despues.y > matriz.size() -1:
		ico2.global_position.y += 128
	
	pass
	

func Chequear_si_orbe()->bool:
	if Memoria.tiene_orbe:
		return true
	return false
####
func _on_Puzzle_juego_ganado():
	var puert_dino:Intercambiador = get_parent().get_parent().get_node("AREAS_EVENTOS/Intercambiador_hacia_DinoBoss")
	puert_dino.desactivado = false
	get_tree().paused = false
	queue_free()
#	en_pausa = true
#	$Mensaje/Mensaje.text = "felicitaciones, ha ganado!"
#	$Mensaje.visible = true
#
#	for i in $PuntosInicioFinal.get_children():
#		i.queue_free()
	pass # Replace with function body.


func _on_Puzzle_juego_perdido(id:int):
#	var mina:MinaNeutral = load("res://OBJETOS/TRAMPAS/MinaNeutral.tscn").instance()
#	mina.global_position = Memoria.jugador.global_position
#	Memoria.nivel_actual.get_node("TRAMPAS/MINAS").add_child(mina)
#	mina.explotar()
#	get_tree().paused = false
#
#	queue_free()
	
#	en_pausa = true
#	$Mensaje.visible = true
#	$Mensaje/Mensaje.text = "Ha perdido! :("
#
#	for i in $PuntosInicioFinal.get_children():
#		i.queue_free()
	pass # Replace with function body.


func _on_Button_button_up():
	$Mensaje.visible = false
	GenerarPartidaNueva()
	en_pausa = false
	pass # Replace with function body.


func _on_Button2_button_up():
	if Memoria.tiene_orbe and Memoria.cubos == 10:
		emit_signal("juego_perdido",2)
	else:
		emit_signal("juego_perdido",0)
	#get_tree().quit()
	pass # Replace with function body.


func _on_ProgressBar_value_changed(value):
	if value <= 0:
		emit_signal("juego_perdido",1)
	pass # Replace with function body.
