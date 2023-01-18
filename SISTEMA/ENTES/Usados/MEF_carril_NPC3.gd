extends MEF_base

onready var disparo_laser:PackedScene = preload("res://SISTEMA/EFECTOS/ESPECIALES/disparo_laser1.tscn")

onready var ente:Enemigo
onready var path:Path2D = owner
onready var pathf:PathFollow2D = owner.get_node("PathFollow2D")
onready var anim:AnimationPlayer


var objetivo:Jugador = null
var puede_atacar:bool = true
var timer_espera:SceneTreeTimer = null

func _ready():
	_agregar_estado("quieto")
	_agregar_estado("reubicacion")
	_agregar_estado("atacando_vertical")
	_agregar_estado("atacando_horizontal")
	_agregar_estado("camina")
	
	
	
	yield(get_tree(),"idle_frame")
	ente = owner.npc
	anim = ente.anim_alt
	#set_deferred("anim",ente.anim_alt)
	anim.connect("animation_finished",self,"_on_animacion_termina")
	
	poner_estado_deferred("quieto")
	
#Logica para cambiar de estados:
func _transiciones(delta):
	match estado:
		estados.camina, estados.reubicacion:
			pathf.offset += ente.Caminar(delta).normalized().x * 70 * delta
			
			if pathf.unit_offset < 0.05:
				ente.CambiarSentido(1)
			elif pathf.unit_offset > 0.95:
				ente.CambiarSentido(-1)
			
			if estado == estados.reubicacion and _si_pathf_no_en_esquina():
				return estados.quieto
			pass
			
	#Si detecta al jugador:
	if puede_atacar and _si_pathf_no_en_esquina() and ente.dentro_del_area:
		var dic = ente.DetectarObjetivo()
		if dic.col_vertical:
			objetivo = dic.objetivo
			return estados.atacando_vertical
		
		if dic.col_horizontal:
			objetivo = dic.objetivo
			return estados.atacando_horizontal
	
	#Despues de reubicar:
	
		
	return null
#Se ejecuta dentro de un estado constantemente.
func _process_estado(delta):
	ente.get_node("Label_debug").text = str(ente.vitalidad)
	
	pass
#Solo se ejecuta una vez cuando entra en un nuevo estado
func _entrar_estado(nuevo, viejo):
	match nuevo:
		estados.quieto:
			anim.play("quieto")
			var timer_espera  = get_tree().create_timer(rand_range(0.5,3.25))
			timer_espera.connect("timeout",self,"pasar_camina")
			
		estados.camina:
			anim.play("camina",-1,1.4)
			#Si el path está dentro de los valores tolerantes, puede caminar en una direccion aleatoria.
			if pathf.unit_offset > 0.10 and pathf.unit_offset < 0.9:
				ente.CambiarSentido([-1,1][randi()%2])
				pass
			#de lo contrario, tomará el camino más largo.
			elif pathf.unit_offset < 0.10:
				ente.CambiarSentido(1)
			else:
				ente.CambiarSentido(-1)
			
			#Crea un tiempo aleatorio para caminar:
			var timer_espera = get_tree().create_timer(rand_range(path.tiempo_min_caminar,path.tiempo_max_caminar))
			timer_espera.connect("timeout",self,"pasar_quieto")
			pass
		
		estados.atacando_horizontal:
			puede_atacar = false
			anim.play("atacar_horizontal")
			
			
		estados.atacando_vertical:
			puede_atacar = false
			anim.play("atacar_vertical")
		
		estados.reubicacion:
			anim.play("camina",-1,1.4)
			
		estados.muerte:
			var explosion:Particles2D = ente.explosion_morir.instance()
			explosion.global_position = ente.global_position
			Memoria.nivel_actual.add_child(explosion)
			explosion._inicio(2,20,20)
			get_parent().queue_free()
	pass

#Solo se ejecuta una vez cuando sale de un estado.
func _salir_estado(viejo, nuevo):
	pass

func LogicaMorir(cantida_dagno,quien):
	ente.vitalidad -= cantida_dagno
	
	if ente.vitalidad <= 0:
		#print("muerte!!")
		
		#Crea las almas:
		var rand:int =randi()%4+1
		var objetos_drops:Array = ente.posibles_objetos_soltar
		for i in objetos_drops:
			for a in rand:
				var objeto:ObjetoColectable = load(i).instance()
				objeto.global_position = Vector2(rand_range(ente.global_position.x-10,ente.global_position.x+10),rand_range(ente.global_position.y-10,ente.global_position.y+10))
				Memoria.nivel_actual.get_node("OBJETOS").call_deferred("add_child",objeto)
		
		poner_estado_deferred(estados.muerte)


#AUXILIARES:
func pasar_camina():
	if estado.find("atacando") == -1:
		poner_estado_deferred("camina")

func pasar_quieto():
	if estado.find("atacando") == -1:
		if _si_pathf_no_en_esquina():
			poner_estado_deferred("quieto")
		else:
			poner_estado_deferred("reubicacion")
			
func reactivar_ataque():
	puede_atacar = true
	
func _si_pathf_no_en_esquina()->bool:
	if [0,90,180,-90,-180].has(int(pathf.rotation_degrees)):
		return true
	return false


func _on_animacion_termina(animacion:String):
	if animacion == "atacar_horizontal" or animacion == "atacar_vertical":
		var new_laser = disparo_laser.instance()
		new_laser.global_position = ente.get_node("Cuerpo/Sprite/Position2D").global_position
		Memoria.nivel_actual.add_child(new_laser)
		
		if animacion == "atacar_vertical":
			new_laser.look_at(ente.get_node("Cuerpo/Sprite/Position2D2").global_position)
			new_laser.movimiento = new_laser.global_position.direction_to(ente.get_node("Cuerpo/Sprite/Position2D2").global_position) * 1
		if animacion == "atacar_horizontal":
			new_laser.look_at(ente.get_node("Cuerpo/Sprite/Position2D3").global_position)
			new_laser.movimiento = new_laser.global_position.direction_to(ente.get_node("Cuerpo/Sprite/Position2D3").global_position) * 1
			#new_laser.rotation_degrees = pathf.rotation_degrees
		
		var timer:SceneTreeTimer = get_tree().create_timer(3)
		timer.connect("timeout",self,"reactivar_ataque")
		poner_estado_deferred("quieto")
		pass
	pass
