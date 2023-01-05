extends Node
"""
SCRIPTS UTILIES PARA TODO:
"""
#Mueve el ente de A a B, relentizando la velociad al aproximarse a B. distancia_minima de A a B. velocidad máxima de movimiento. Tolerancia es el valor que cuando la distancia_minima es menor que él, se considera completado el movimiento(por defecto es 5.0).
#Retorna un Diccionario con key: 
# vector = el vector de dezplazamiento (0 + distancia_minima es la posicion de fin)
# llego_al_objetivo = true o false. Es true cuando llegó al destino, mientras es false.

static func _movimiento_suavisado_de_A_a_B(posicionA:Vector2, posicionB:Vector2, velocidad:float, distancia_minima:float, tolerancia:float = 5.0)->Dictionary:
	var dicc:Dictionary = {}
	var distancia_actual:float = posicionA.distance_to(posicionB)

	var vector:Vector2 = posicionA.direction_to(posicionB) * clamp(distancia_actual-distancia_minima,0,velocidad)
	
	if distancia_actual < tolerancia:
		dicc.llego_al_objetivo = true
	else:
		dicc.llego_al_objetivo = false

	dicc.vector = vector
	return dicc

#Huir:
#distancia_minima_aceptable = la distancia minima a la que se considera que A esta cerca de B.
static func _movimiento_suavisado_de_huida(posicionA:Vector2, posicionB:Vector2, velocidad:float, distancia_minima:float = 200.0)->Dictionary:
	var dicc:Dictionary = {}
	var distancia_actual:float = posicionA.distance_to(posicionB)
	var vector:Vector2 = -(posicionA.direction_to(posicionB)) * (distancia_minima-distancia_actual)
	
	if distancia_actual < distancia_minima:
		dicc.llego_al_objetivo = false
	else:
		dicc.llego_al_objetivo = true
	
	dicc.vector = vector
	return dicc
#Huida con un factor extra para volar hacia arriba. lo que hace es intentar alcanzar cierta altura. Util para los enemigos voladores.
static func _movimiento_suavisado_de_huida_volar(posicionA:Vector2, posicionB:Vector2, velocidad:float, distancia_minima:float = 200.0,factor_de_vuelo:float= 400)->Dictionary:
	var dicc:Dictionary = {}
	var distancia_actual:float = posicionA.distance_to(posicionB)
	var posicionC:Vector2 = ((posicionA-posicionB) + Vector2(0,factor_de_vuelo)).normalized() 
	var vector:Vector2 = -(posicionC) * (distancia_minima-distancia_actual)
	
	if distancia_actual < distancia_minima:
		dicc.llego_al_objetivo = false
	else:
		dicc.llego_al_objetivo = true
	
	dicc.vector = vector
	return dicc

#Esta metodo mueve un ente de A a B usando un factor multiplicativo (float) para el movimiento. Normalmente se consigue animando un float en una animacion con AnimationPlayer
static func _movimiento_de_A_a_B_con_factor(posicionA:Vector2, posicionB:Vector2, factor:float,velocidad_movimiento:float, tolerancia:float = 5.0)->Dictionary:
	var dicc:Dictionary = {}
	var distancia_actual:float = posicionA.distance_to(posicionB)
	var vector:Vector2 = posicionA.direction_to(posicionB) * (factor * velocidad_movimiento) 
	
	if distancia_actual < tolerancia:
		vector = Vector2.ZERO
		dicc.llego_al_objetivo = true
	else:
		dicc.llego_al_objetivo = false
		
	dicc.vector = vector
	return dicc
	pass
#Empuja al enteA en sentido contrario de la direccion en la que mira por el eje X. Retorna un diccionario con el vector de movimiento y true/false cuando el movimiento se terminó.
static func _push_rect_back(enteA:Ente,direccion_mira:int, factor_empujon:float,factor_tiempo:float)->Dictionary:
	var dicc:Dictionary = {}
	var interpolacion:float = 0.0
	var vector:Vector2 = Vector2.ZERO
	interpolacion = lerp(factor_empujon,0,factor_tiempo)
	match direccion_mira:
		1:
			vector = Vector2(-factor_empujon,0)
			pass
		
		-1:
			vector = Vector2(factor_empujon,0)
			pass
			
	dicc.vector = vector
	if abs(round(interpolacion)) == 0:
		dicc.terminado = true
	else:
		dicc.terminado = false
	
	return dicc
	pass

#Este metodo empuja al enteA hacia el lado contrario del enteB:
static func _push_back(posicionA:Vector2, posicionB:Vector2,factor_empujon:float,factor_tiempo:float)->Dictionary:
	var dicc:Dictionary = {}
	var vector:Vector2 = Vector2(0,0)
	var direccion:Vector2 = posicionA.direction_to(posicionB)
	var interpolacion:float = 0.0
	
	interpolacion = lerp(factor_empujon,0,factor_tiempo)
	vector = -direccion * interpolacion
#	if posicionA.x > posicionB.x:
#		vector = direccion * interpolacion#Vector2(interpolacion,posicionA.y)
#	else:
#		vector = direccion * interpolacion#Vector2(-interpolacion,posicionA.y)
	
	if abs(round(interpolacion)) == 0:
		dicc.terminado = true
	else:
		dicc.terminado = false
	
	dicc.vector = vector
	
	
	return dicc

#Metodo que mueve al Ente hacia adelante con lerp para la aceleracion:
#velocidad_maxima => la máxima velocidad a la que se moverá.
#sentido => 1 derecha; -1 izquierda. Normalmente se obtiene de scale.x
#intervalo => el peso aplicado al lerp.
#retorna el vector de movimiento.
static func _mover_alante(velocidad_maxima:float,vector_base:Vector2,sentido:float,intervalo:float = 0.018)->Vector2:
	var coeficiente:float = 0.0
	var vector:Vector2
	if sentido > 0:
		coeficiente = lerp(0,velocidad_maxima,intervalo)
		
	elif sentido < 0:
		coeficiente = lerp(0,-velocidad_maxima,intervalo)
	
	vector = Vector2(clamp(vector_base.x+coeficiente,-velocidad_maxima,velocidad_maxima),vector_base.y)
	#print(coeficiente)
	
	return vector
	pass
