extends Habilidad

export (float) var maximo_largo_gancho:float = 800
export (float) var velocidad_gancho:float = 8
export (float) var velocidad_recogida:float = 450

var linea:Line2D = null	#La linea para el gancho.

onready var p_punta_garfio:PackedScene = preload("res://SISTEMA/HABILIDADES/PuntaGarfio.tscn")
var garfio:Area2D= null

var enganchado:bool = false

var punto_anclaje:Vector2 = Vector2.ZERO #almacena temporalmente la coordenada del mouse cuando lanza el garfio
var movimiento:Vector2 = Vector2.ZERO

func _ready():
	mi_ente = get_parent().get_parent()
	mef_ente = mi_ente.get_node("MEF")
	
	_agregar_estado("nada")
	_agregar_estado("soltar_gancho")
	_agregar_estado("recoger_gancho")
	_agregar_estado("enganchado_listo")
	_agregar_estado("salir")
	
	poner_estado_deferred("nada")

#Logica para cambiar de estados:
func _transiciones(delta):
	match estado:
		estados.nada:
			if Input.is_action_just_pressed("gancho"):
				return estados.soltar_gancho
				pass
	
		estados.soltar_gancho:
			if not linea == null:
				linea.points[0] = mi_ente.global_position
				MoverGarfio()
				if DetectarFinGancho(linea.points[0],linea.points[1]) or Input.is_action_just_pressed("salto"):
					return estados.salir
				
		estados.recoger_gancho:
			#var mov:Dictionary = Memoria._movimiento_suavisado_de_A_a_B(mi_ente.global_position,linea.points[1], velocidad_recogida, 0, 1)
			mi_ente.movimiento = mi_ente.global_position.direction_to(linea.points[1]) * velocidad_recogida
			linea.points[0] = mi_ente.global_position
			mi_ente.movimiento = mi_ente.move_and_slide(mi_ente.movimiento,Vector2.UP)
			mi_ente.Girar()
			#Salir si hago salto:
			if Input.is_action_just_pressed("salto"):
				mi_ente.Saltar()
				return estados.salir
			
			#Lanzar de nuevo el gancho:
			if Input.is_action_just_pressed("gancho"):
				ReiniciarGancho()
				return estados.soltar_gancho
#			if mi_ente.is_on_ceiling() or mi_ente.is_on_floor() or mi_ente.is_on_wall():
#				return estados.enganchado_listo
		
		
	return null
#Se ejecuta dentro de un estado constantemente.
func _process_estado(delta):
	if ![estados.recoger_gancho,estados.nada].has(estado):
		mi_ente.AplicarGravedad(delta)
		mi_ente.movimiento.y = mi_ente.move_and_slide_with_snap(mi_ente.movimiento + mi_ente.AjustarVectorImpulso(),mi_ente.vector_snap,Vector2.UP,true,4,mi_ente.SNAP_ANGULO).y
	pass
#Solo se ejecuta una vez cuando entra en un nuevo estado
func _entrar_estado(nuevo, viejo):
	match nuevo:
		estados.soltar_gancho:
			DeshabilitarMEF()
			CrearGancho()
		
		estados.salir:
			ReiniciarGancho()
			poner_estado_deferred("nada")
		
		estados.recoger_gancho:
			mi_ente.vector_snap = Vector2.ZERO
			pass
	pass
#Solo se ejecuta una vez cuando sale de un estado.
func _salir_estado(viejo, nuevo):
	pass



func ReiniciarGancho():
	mi_ente.movimiento = Vector2.ZERO
	mi_ente.vector_impulsos = Vector2.ZERO
	HabilitarMEF("")
	linea.queue_free()
	linea = null
	garfio.queue_free()
	garfio = null
	enganchado = false
	mi_ente.ReiniciarVectorSnap()

func CrearGancho():
	var punto_inicio:Vector2 = mi_ente.global_position
	
	
	punto_anclaje = punto_inicio.direction_to(mi_ente.get_global_mouse_position()) * velocidad_gancho#get_parent().get_parent().get_node("TRAMPAS/Lanzallamas4").global_position
	#prints(punto_inicio,punto_anclaje)
	var punto_final:Vector2 = punto_inicio#Vector2(punto_inicio.x,punto_inicio.y - 50).rotated(punto_inicio.angle_to_point(punto_anclaje))
	
	linea = Line2D.new()
	linea.default_color = Color.white
	linea.texture = load("res://SISTEMA/RECURSOS/IMAGENES/ESCALERAS/cadena.png") as Texture
	linea.texture_mode = Line2D.LINE_TEXTURE_TILE
	linea.add_point(punto_inicio)
	linea.add_point(punto_final)
	add_child(linea)
	
	garfio = p_punta_garfio.instance()
	garfio.global_position = punto_inicio
	add_child(garfio)
	garfio.look_at(mi_ente.get_global_mouse_position())
	garfio.connect("body_entered",self,"on_garfio_toca_suelo")
	
func MoverGarfio():
	linea.points[1] = linea.points[1] + punto_anclaje 
	garfio.global_position = linea.points[1]

func DetectarFinGancho(p1:Vector2,p2:Vector2)->bool:
	if p1.distance_to(p2) >= maximo_largo_gancho:
		return true
	return false


func on_garfio_toca_suelo(body):
	#print("garfio_enganchado!!")
	enganchado = true
	poner_estado_deferred("recoger_gancho")
