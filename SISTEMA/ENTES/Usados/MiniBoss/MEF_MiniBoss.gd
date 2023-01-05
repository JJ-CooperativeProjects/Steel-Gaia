extends MEF_base

onready var ente:MiniBoss = get_parent() as MiniBoss

var objetivo:Ente = null

var estoy_fuera:bool = false

var pos_quieto:Vector2
var count_golpes:int = 0

var pos_trasladarse:Vector2
var pluss_correr:float = 1 #Se multiplica por la velocidad de movimiento cuadno es atacado.
export (float) var componente:float = 0

#Conteos para pasar a ataque:
var conteo_traslados:int = 0

func _ready():
	_agregar_estado("aparecer_primeravez")
	_agregar_estado("quieto")
	_agregar_estado("trasladarse")
	_agregar_estado("ir_al_centro")
	_agregar_estado("huir")
	_agregar_estado("desaparecer")
	_agregar_estado("aparecer")
	_agregar_estado("invocar")
	
	poner_estado_deferred(estados.aparecer_primeravez)
	objetivo = Memoria.jugador
	yield(get_tree(),"idle_frame")
	ente.MirarObjetivo(objetivo)
	ente.anim.connect("animation_finished",self,"_on_animacion_termina")
	ente.connect("RecibeDamage",self,"SumarGolpe")
	pass

#Se ejecuta dentro de un estado constantemente.
func _process_estado(delta):
	ente.get_node("Label_debug").text = str(ente.vitalidad) + "_" + estado + " " + str(count_golpes) + " \n" + str(conteo_traslados)
	pass
func _physics_process(delta):
	match estado:
		estados.quieto:
			var data_mov:Dictionary
			ente.movimiento = ente.move_and_slide(ente.vector_impulsos,Vector2.UP)
			return
		
		estados.trasladarse, estados.ir_al_centro:
			var data_mov:Dictionary 
			
			if componente < 1:
				data_mov= ScriptsGlobales._movimiento_de_A_a_B_con_factor(ente.global_position, pos_trasladarse, componente, ente.velocidad_movimiento * pluss_correr,30)
			else:
				data_mov = ScriptsGlobales._movimiento_suavisado_de_A_a_B(ente.global_position, pos_trasladarse, ente.velocidad_movimiento * pluss_correr, 2,20)
			
			ente.movimiento = data_mov.vector
			ente.movimiento = ente.move_and_slide(ente.movimiento)
		
			DeterminarAnimacionSegunPosicionAlTrasladarse()
			
			if pluss_correr > 1:
				pluss_correr  = lerp(pluss_correr,1,0.02)
				
			if data_mov.llego_al_objetivo == true:
				pluss_correr = 1
				poner_estado_deferred(estados.quieto)
				return
			
		estados.invocar:
			var data_mov:Dictionary = ScriptsGlobales._movimiento_suavisado_de_A_a_B(ente.global_position, pos_quieto, ente.velocidad_movimiento, 2,10)
			
			ente.movimiento = data_mov.vector
			ente.movimiento = ente.move_and_slide(ente.movimiento)
			
			if data_mov.llego_al_objetivo == true:
				return

	pass
	
#Logica para cambiar de estados:
func _transiciones(delta):
	match estado:
		estados.quieto, estados.trasladarse, estados.ir_al_centro:
			ente.MirarObjetivo(objetivo)
			
			if count_golpes > 5:
				return estados.desaparecer
#				count_golpes = 0
#				pluss_correr = 20
				#return estados.desaparecer
				pass
			
			if estoy_fuera:
				return estados.desaparecer
		
	return null
#Solo se ejecuta una vez cuando entra en un nuevo estado
func _entrar_estado(nuevo, viejo):
	match nuevo:
		estados.aparecer_primeravez:
			ente.MirarObjetivo(objetivo)
			ente.anim.play("aparecer")
		
		estados.quieto:
			objetivo = Memoria.jugador
			ente.anim.play("quieto")
			ente.get_node("mov_pluss").play("movimiento_levitar")
			
			pos_quieto = ente.global_position
			
			#Determinar atacar:
			if ListoAtacar():
				poner_estado_deferred("invocar")
				return
			
			var timer:SceneTreeTimer = get_tree().create_timer(3.0)
			timer.connect("timeout",self,"Trasladarse")
		
		estados.trasladarse:
			ente.anim.play("camina_alante")
			ente.get_node("mov_pluss").play("impulso_traslado")
			pos_trasladarse = ente. determinar_punto_moverse(Memoria.camara_actual)
			
			conteo_traslados += 1
		
		estados.ir_al_centro:
			ente.anim.play("camina_alante")
			pos_trasladarse = Vector2(Memoria.camara_actual.global_position.x,rand_range(Memoria.camara_actual.global_position.y-100,Memoria.camara_actual.global_position.y+100))
			pass
		
		estados.desaparecer:
			ente.anim.play("desaparecer")
			conteo_traslados += 1
		
		estados.invocar:
			ReiniciarConteos()
			ente.anim.play("inicio_invocar")
			
		estados.muerte:
			var explosion:Particles2D = ente.explosion_morir.instance()
			explosion.global_position = ente.global_position
			Memoria.nivel_actual.add_child(explosion)
			explosion._inicio(6,38,50)
			ente.queue_free()
		
	pass
#Solo se ejecuta una vez cuando sale de un estado.
func _salir_estado(viejo, nuevo):
	pass

##AUX:
func Trasladarse():
	if [estados.quieto].has(estado):
		poner_estado_deferred(estados.trasladarse)

func DeterminarAnimacionSegunPosicionAlTrasladarse():
	
	if (ente.movimiento.x > 0 and ente.direccion_mira == -1) or (ente.movimiento.x < 0 and ente.direccion_mira == 1):
		ente.anim.play("camina_atras")
	
		pass

func ListoAtacar()->bool:
	if conteo_traslados >= 3 or count_golpes > 5:
		return true
	return false

func ReiniciarConteos():
	conteo_traslados = 0
	count_golpes = 0

func SumarGolpe(damage):
	count_golpes += 1

func LogicaMorir(cantida_dagno):
	var ente = get_parent() as Ente
	#print(cantida_dagno)
	ente.set_vitalidad(ente.get_vitalidad() - cantida_dagno) 
	
	if ente.vitalidad <= 0:
		#print("muerte!!")
		#Crea las almas:
		var rand:int =randi()%4+1
		var objetos_drops:Array = ente.posibles_objetos_soltar
		for i in objetos_drops:
			var objeto:ObjetoColectable = load(i).instance()
			objeto.global_position = Vector2(rand_range(ente.global_position.x-10,ente.global_position.x+10),rand_range(ente.global_position.y-10,ente.global_position.y+10))
			Memoria.nivel_actual.get_node("OBJETOS").call_deferred("add_child",objeto)
		
		ente.emit_signal("es_destruido")
		poner_estado_deferred(estados.muerte)
##SEÑALES----------------------------------------------------
func _on_animacion_termina(animacion:String):
	match animacion:
		"aparecer","trasladarse":
			poner_estado_deferred(estados.quieto)
		
		"desaparecer":
			ente.global_position = ente.determinar_punto_moverse(Memoria.camara_actual)
			#poner_estado_deferred(estados.aparecer)
			poner_estado_deferred(estados.aparecer_primeravez)
			
		"inicio_invocar":
			ente.anim.play("invocar")
		
		"invocar":
			ente.anim.play("fin_invocar")
		
		"fin_invocar":
			poner_estado_deferred(estados.quieto)
	pass


func _on_VisibilityNotifier2D_screen_exited():
	#print("estoy fuera")
	estoy_fuera = true
	ente.get_node("CanvasLayer").visible = false
#	if [estados.quieto, estados.trasladarse].has(estado):
#		poner_estado_deferred(estados.ir_al_centro)
	
	
	pass # Replace with function body.


func _on_VisibilityNotifier2D_screen_entered():
	estoy_fuera = false
	ente.get_node("CanvasLayer").visible = true
	pass # Replace with function body.
