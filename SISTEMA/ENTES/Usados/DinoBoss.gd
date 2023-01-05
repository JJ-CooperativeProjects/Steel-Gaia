extends Enemigo
class_name DinoBoss


onready var anim_dino:AnimationPlayer = $Cuerpo/Control.get_node("Base/AnimationPlayer") #$Viewport/Control.get_node("Base/AnimationPlayer")
onready var control = $Cuerpo/Control

export (int) var numero_llamas_superataque:int = 10

var pos_misiles:Sprite
onready var piezas_cuerpo:Array = []

func _ready():
	pos_misiles = control.get_node("Base/pelvis_control/cuerpo/Pecho/cohetes")
	
	piezas_cuerpo = [
		get_node("Cuerpo/Control/Base/pelvis_control/cuerpo"),
		get_node("Cuerpo/Control/Base/pelvis_control/cuerpo/Pecho"),
		get_node("Cuerpo/Control/Base/pelvis_control/cuerpo/Pecho/brazo_der/brazo_1_der/pala_1_der"),
		get_node("Cuerpo/Control/Base/pelvis_control/cuerpo/Pecho/brazo_izq/brazo_1_izq/pala_1_izq"),
		get_node("Cuerpo/Control/Base/pelvis_control/cuerpo/Pecho/cuello_Control/cuello"),
		get_node("Cuerpo/Control/Base/pelvis_control/cuerpo/Pecho/cuello_Control/cuello/cabeza"),
		get_node("Cuerpo/Control/Base/pelvis_control/cuerpo/Pecho/cuello_Control/cuello/cabeza/mandibula"),
		get_node("Cuerpo/Control/Base/pelvis_control/pierna_izq"),
		get_node("Cuerpo/Control/Base/pelvis_control/pierna_izq/pierna_2_izq"),
		get_node("Cuerpo/Control/Base/pelvis_control/pierna_izq/pierna_2_izq/tobillo_izq/pata_izq"),
		get_node("Cuerpo/Control/Base/pelvis_control/pierna_der"),
		get_node("Cuerpo/Control/Base/pelvis_control/pierna_der/pierna_2_der"),
		get_node("Cuerpo/Control/Base/pelvis_control/pierna_der/pierna_2_der/pierna_3_der/pata_der"),
	]
	
	control.connect("grito",self,"mostrar_barra_vida")
	control.connect("ataque_rocas",self,"AtaqueRocas")
	
	for i in piezas_cuerpo:
		i.connect("RecibeDamage",get_node("MEF"),"LogicaMorir")
	
	$CanvasLayer_BarraVida/GUI_miniboss/barra_vida.max_value = max_vitalidad
	$CanvasLayer_BarraVida/GUI_miniboss/barra_vida.value = get_vitalidad()
	
func _physics_process(delta):
	pass
	

func AtaqueRocas(numero_rocas:int = 5):
	for i in numero_rocas:
		var p_roca := load("res://SISTEMA/ENTES/Usados/DinoBoss/Roca.tscn").instance() as Node2D
		
		p_roca.global_position = control.get_node("Base/pelvis_control/cuerpo/Pecho/brazo_der").global_position
		Memoria.nivel_actual.add_child(p_roca)

func DispararMisiles(cual:int):
	var misil_1:DisparoBase = load("res://SISTEMA/ENTES/Usados/DinoBoss/MisilDino.tscn").instance()
	misil_1.global_position = pos_misiles.global_position
	Memoria.nivel_actual.add_child(misil_1)
	
	match cual:
		1:
			misil_1.rotation = $pos_misil1.global_position.angle_to_point(misil_1.global_position)
			
			pass
		2:
			misil_1.rotation = $pos_misil2.global_position.angle_to_point(misil_1.global_position)
			
			pass
		3:
			misil_1.rotation = $pos_misil3.global_position.angle_to_point(misil_1.global_position)
			pass
		
	misil_1.movimiento = Vector2(1,0).rotated(misil_1.rotation)
	#misil_1.look_at($pos_misil1.global_position)
	
func DispararMisilDirigido():
	var misil_1:DisparoBase = load("res://SISTEMA/ENTES/Usados/DinoBoss/MisilDino_Dirigible.tscn").instance()
	misil_1.global_position = pos_misiles.global_position
	Memoria.nivel_actual.add_child(misil_1)
	#misil_1.look_at(Memoria.jugador.global_position)
	#misil_1.look_at($pos_misil1.global_position)
	
func set_vitalidad(valor:int):
	vitalidad = valor
	if is_inside_tree():
		$CanvasLayer_BarraVida/GUI_miniboss/barra_vida.value = valor


func mostrar_barra_vida():
	$CanvasLayer_BarraVida.visible = true

func _on_Ente_RecibeDamage(cantidad:float):
	#prints("El dino boss ha recibido",cantidad, "daño!")
	pass
