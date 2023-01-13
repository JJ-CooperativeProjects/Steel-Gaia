extends AreaDisparadorEvento

var offset_inicial_camara:Vector2
var boss:DinoBoss
func EsActivada():
	evento_terminado = true
	boss = Memoria.nivel_actual.get_node("ENEMIGOS").get_node("DinoBoss") as DinoBoss
	boss.get_node("MEF").connect("entra_en_combate",self,"EsDesactivada")
	boss.connect("Muere",self,"ActivarPuertas")
	Memoria.modo_cinematica_activo = true
	
	
	
	#Mover sutilmente la camara:
	offset_inicial_camara = Memoria.camara_actual.offset
	
	var tween:SceneTreeTween = create_tween()
	var pos_x:float = 200#offset_inicial_camara.x + (boss.global_position.x - Memoria.camara_actual.global_position.x)
	var pos_y:float = offset_inicial_camara.y + (boss.global_position.y - Memoria.camara_actual.global_position.y)
	var nueva_pos:Vector2 = Vector2(pos_x,pos_y-60)
	tween.tween_property(Memoria.camara_actual,"offset",nueva_pos,2.0)
	yield(tween,"finished")
	var timer:SceneTreeTimer = get_tree().create_timer(1.5)
	yield(timer,"timeout")
	bajar_dino()
	
	set_deferred("monitoring",false)
	pass

func EsDesactivada():
	.EsDesactivada()
	var tween:SceneTreeTween = create_tween()
	tween.tween_property(Memoria.camara_actual,"offset",offset_inicial_camara,1.5)
	#tween.connect("finished",self,"queue_free")
	pass

func bajar_dino():
	boss.get_node("MEF").poner_estado_deferred("bajando")
	var tween:SceneTreeTween = create_tween()
	tween.tween_property(Memoria.camara_actual,"offset",Vector2(Memoria.camara_actual.offset.x,offset_inicial_camara.y),6.2)
	
	#Cerrar las puertas
	for i in nodos_del_evento:
		get_node(i).Activar()

func ActivarPuertas():
	#no abrir la primera puerta:
	nodos_del_evento.pop_front()
	
	for i in nodos_del_evento:
		get_node(i).Activar()
	
	queue_free()

func AfterEvento():
	var dino:DinoBoss = Memoria.nivel_actual.get_node_or_null("ENEMIGOS/DinoBoss")
	
	if dino:
		dino.queue_free()
	pass
