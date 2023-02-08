extends Ente
class_name Jugador
"""
CLASE QUE DEFINE A UN JUGADOR. ENTIDAD CONTROLADA POR EL USUARIO.
"""

#El jugador cuenta con una energía que la utiliza para relaizar los movimientos más complejos
export (float) var max_energia:float = 100
export (float) onready var energia:float = 100	      setget set_energia, get_energia
export var count_recuperar_energia:float = 12.25

onready var efecto_dash:PackedScene = preload("res://SISTEMA/EFECTOS/DashEffect.tscn")
onready var camara:PackedScene = preload("res://SISTEMA/GLOBAL/CamaraControl.tscn")
onready var rayo_pared_derecho:RayCast2D = $RayPared1
onready var rayo_pared_izqueierdo:RayCast2D = $RayPared2

var mi_control_camara = null
#Segun la dirección que el usuario pulse:
var direcciones:Vector2 = Vector2.ZERO
var tween_salto:SceneTreeTween

onready var pos_pugnos:Position2D = $Cuerpo/pos_golpes_pugnos 

func _ready():
	Memoria.jugador = self
	prints("mi_energia",energia)
	#Crea la cámara:
	var camara_i = camara.instance()
	camara_i.global_position = global_position
	camara_i.mi_jugador = self
	Memoria.nivel_actual.call_deferred("add_child",camara_i)
	mi_control_camara = camara_i
	
	set_vitalidad(vitalidad)
	set_energia(energia)
#	if not Memoria.cambiando and not Memoria.es_nuevo:
#		
	
	
#METODOS========================================================================
func _input(event):
#	if event.is_action_pressed("ui_page_up"):
#		GirarManualmente()
#	if Input.is_action_just_pressed("escopeta"):
#		Memoria.camara_actual.sacudir(0.62)
	pass
#METODOS AUXILIARES=============================================================
#Retorna un vector normalizado sengun la direccion que el usuairo pulse en el teclado.
func DireccionesTeclado()->Vector2:
	return Vector2(Input.get_axis("ui_left","ui_right"), Input.get_axis("ui_up","ui_down"))
	pass



func Caminar(delta):
	velocidad_actual_x = 0
	if velocidad_actual_x in range(-velocidad_movimiento,velocidad_movimiento):
		if direcciones.x > 0:
			velocidad_actual_x += 1 #if !Input.is_action_pressed("correr") else 2.5

		if direcciones.x < 0:
			velocidad_actual_x -= 1 #if !Input.is_action_pressed("correr") else 2.5

	velocidad_actual_x *= velocidad_movimiento
	movimiento.x = lerp(movimiento.x,velocidad_actual_x,0.18)

func CaminarPared(delta):
	velocidad_actual_y = 0
	if velocidad_actual_y in range(-velocidad_movimiento,velocidad_movimiento):
		if direcciones.y > 0:
			velocidad_actual_y += 0.52 #if !Input.is_action_pressed("correr") else 2.5

		if direcciones.y < 0:
			velocidad_actual_y -= 0.52 #if !Input.is_action_pressed("correr") else 2.5

	velocidad_actual_y *= velocidad_movimiento
	movimiento.y = lerp(movimiento.y,velocidad_actual_y,0.52)
	movimiento.x = 0
	
	pass

func CaminarEscalera(delta):
	movimiento = Vector2(0,direcciones.y) * (velocidad_movimiento/2.53)
	
func CaminarMalla(delta):
	movimiento = direcciones * (velocidad_movimiento/2.53)
#Devuelve true cuando esté fuera de una pared. Usar para salir de una pared.
func FueraDePared()->bool:
	if !rayo_pared_derecho.is_colliding() and !rayo_pared_izqueierdo.is_colliding() and !$RayPared3.is_colliding() and !$RayPared4.is_colliding():
		return false
	return true

#Dash:
func Dash():
	movimiento = Vector2.ZERO
	vector_impulsos = Vector2.ZERO
	$AnimEfectos.play("CurvaDash")
	pass

func Saltar():
	emit_signal("IniciaSalto")
	vector_snap = Vector2.ZERO
	vector_impulsos = Vector2.ZERO
	movimiento = Vector2.ZERO
	tween_salto = get_tree().create_tween()
	tween_salto.tween_property(self,"movimiento:y",-440.0,0.22).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	pass
	
#SegundoSalto:
func SegundoSalto():
	vector_snap = Vector2.ZERO
	movimiento = Vector2.ZERO
	vector_impulsos = Vector2.ZERO
	movimiento.y -= velocidad_salto * 1.23
	#$AnimEfectos.play("SaltoSegundo")

#
func EfectoSombra(ciclo:float,nodo_controlador:MEF_base):
	var efecto:DashEffect = efecto_dash.instance()
	efecto.texture = $Cuerpo/Sprite.texture
	efecto.region_enabled = true
	efecto.region_rect = $Cuerpo/Sprite.region_rect
	efecto.global_position = Vector2(global_position.x,global_position.y-29)
	
	get_parent().add_child(efecto)
	if $Cuerpo.scale.x < 0:
		efecto.scale.x *= -1
	var timer:SceneTreeTimer = get_tree().create_timer(ciclo)
	if ["salto_doble"].has(nodo_controlador.estado):
		timer.connect("timeout",self,"EfectoSombra",[ciclo,nodo_controlador])
	if ["dash"].has(nodo_controlador.estado):
		timer.connect("timeout",self,"EfectoSombra",[ciclo,nodo_controlador])
	pass

func GirarManualmente():
	cuerpo.scale.x *= -1
	direccion_mira = cuerpo.scale.x

func Flash():
	$Cuerpo/Sprite.material.set_shader_param("balance_flash", 1)
	var timer:SceneTreeTimer = get_tree().create_timer(0.5)
	timer.connect("timeout",self,"ResetFlash")
	
func ResetFlash():
	$Cuerpo/Sprite.material.set_shader_param("balance_flash", 0)
	pass

func JugadorMuere():
	Memoria.CargarUltimaPartidaGuardada()

####
func Salvar(data_vacio:Dictionary= {})->Dictionary:
	data_vacio = .Salvar({})
	data_vacio.merge({
		"vitalidad": vitalidad,
		"energia": energia,
		"habilidades": SalvarHabilidades()
	})
	
	return data_vacio
	pass

####
func Cargar(data:Dictionary):
	.Cargar(data)
	print(data.energia)
	energia = data.energia
	set_vitalidad(data.vitalidad)
	
	#Cargar las habilidades:
	for h in get_node("HABILIDADES").get_children():
		h.queue_free()
	
	for d in data["habilidades"]:
		var hab:Habilidad = load(d["ruta_file"]).instance()
		get_node("HABILIDADES").add_child(hab)
	
####
func SalvarHabilidades()->Array:
	var data:Array = []
	
	for h in get_node("HABILIDADES").get_children():
		data.append({
			"ruta_file": h.filename,
			"nombre":h.name
		})
	return data
#SEÑALES========================================================================

#SET-GET========================================================================
func set_vitalidad(valor:int):
	vitalidad = valor
	if is_inside_tree():
		GuiJugador.set_vida(valor,max_vitalidad)

func get_vitalidad()->int:
	return vitalidad

func set_energia(valor:float):
	energia = valor
	#GuiJugador.get_node("GUI/barra_energia").value = energia
	if is_inside_tree():
		var object = GuiJugador
		GuiJugador.set_energia(valor,max_energia)
		$MEF/anim_energia.play("count_energia")

func get_energia()->float:
	return energia

func ProcessEnergia(delta):
	if energia < max_energia:
		set_energia(clamp(energia,get_energia() + count_recuperar_energia * delta, max_energia))

func set_damage(valor:float):
	damage = valor
	if is_inside_tree():
		$Cuerpo/AreaDamageNormal.damage = damage
		$Cuerpo/AreaDamageEscopeta.damage = damage

func SalvarDatosJugador(data:BaseSaveData):
	data.vida_actual = vitalidad
	data.vida_max = max_vitalidad
	data.damage = damage
	data.direccion_mira = direccion_mira
	data.energia_actual = energia
	data.max_energia = max_energia
	data.posicion_actual = global_position

func CargarDatosJugador(data:BaseSaveData,posicion_incluida:bool,direccion_incluida:bool):
	vitalidad = data.vida_actual
	max_vitalidad = data.vida_max
	max_energia = data.max_energia
	damage = data.damage
	energia = data.energia_actual
	
	if posicion_incluida:
		global_position = data.posicion_actual
	
	if direccion_incluida:
		direccion_mira = data.direccion_mira
		cuerpo.scale.x = data.direccion_mira


func _on_Jugador_tree_exiting():
	mi_control_camara.queue_free()
	pass # Replace with function body.

func AfterCargar():
	$Cuerpo/AreaDamageEscopeta.objetivo = self
	$Cuerpo/AreaDamageNormal.objetivo = self
	pass
