tool
extends Enemigo

"""
NPC2
"""
onready var misil:PackedScene = preload("res://SISTEMA/OBJETOS/DISPAROS/MisilDirigidoBase.tscn")
onready var super_laser:PackedScene = preload("res://SISTEMA/EFECTOS/ESPECIALES/Usados/EfectoEspecial_carga_laser_NPC2.tscn")
onready var punto_cohetes:Node2D = $Cuerpo/punto_cohetes
onready var punto_laser:Node2D = $Cuerpo/punto_laser
#Cuando alguno de los rayos de control detecta que el NPC debe girar:
func Girar_por_rayo():
	#No hay suelo debajo:
	if not $Cuerpo/rayo_suelo_der.is_colliding() and not $Cuerpo/rayo_frente.is_colliding():
		$Cuerpo.scale.x = 1 if direccion_mira == -1 else -1
		direccion_mira = 1 if direccion_mira == -1 else -1
		
	elif $Cuerpo/rayo_frente.is_colliding():
		$Cuerpo.scale.x = 1 if direccion_mira == -1 else -1
		direccion_mira = 1 if direccion_mira == -1 else -1

func DispararMisiles():
	
	var i_misil:DisparoBase = misil.instance()
	i_misil.global_position = punto_cohetes.global_position
	i_misil.objetivo = objetivo if is_instance_valid(objetivo) else null
	i_misil.amplitud_zona_impacto = Vector2(100,100)
	i_misil.altura_zona_imacto = Vector2(100,100)
	Memoria.nivel_actual.add_child(i_misil)
	pass

func DispararSuperLaser():
	var i_laser:EfectoEspecial = super_laser.instance()
	i_laser.global_position = punto_laser.global_position
	i_laser.connect("disparo",$MEF,"AnimDisparar")
	connect("Muere",i_laser,"queue_free")
	match direccion_mira:
		1:
			i_laser.scale.x = -1
			pass
		-1:
			i_laser.scale.x = 1
			pass
	
	Memoria.nivel_actual.add_child(i_laser)


func AfterCargar():
	objetivo = Memoria.jugador
	
	$Viewport/control_base2.connect("emitir_laser",self,"DispararSuperLaser")
	$Viewport/control_base2.connect("dispara_cohetes",self,"DispararMisiles")
	$Viewport/control_base2.connect("muerto",$MEF,"Desaparecer")
	
	$VisibilityNotifier_version_modificada.nodos_a_procesar.append($Viewport/control_base2.get_node("AnimationPlayer").get_path())
