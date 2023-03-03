extends Node2D
class_name ControladorLluvia

"""
CLASE ESPECIAL PARA EL MANEJO DE LA TORMENTA.
"""

onready var truenos_lejanos:Array = [
	"res://RECURSOS/SONIDOS/AMBIENT/Truenos/Lejanos/1.wav",
	"res://RECURSOS/SONIDOS/AMBIENT/Truenos/Lejanos/2.wav",
	"res://RECURSOS/SONIDOS/AMBIENT/Truenos/Lejanos/3.wav",
	"res://RECURSOS/SONIDOS/AMBIENT/Truenos/Lejanos/4.wav",
	"res://RECURSOS/SONIDOS/AMBIENT/Truenos/Lejanos/5.wav"

]

onready var truenos_fuertes:Array = [
	"res://RECURSOS/SONIDOS/AMBIENT/Truenos/trueno_fuerte1.wav",
	"res://RECURSOS/SONIDOS/AMBIENT/Truenos/trueno_fuerte2.wav"
]

onready var lluvias:Array = [
	"res://RECURSOS/SONIDOS/AMBIENT/Lluvia/lluvia_poca1.ogg",
	"res://RECURSOS/SONIDOS/AMBIENT/Lluvia/lluvia_ligera.ogg",
	"res://RECURSOS/SONIDOS/AMBIENT/Lluvia/lluvia_ligera2.ogg",
	"res://RECURSOS/SONIDOS/AMBIENT/Lluvia/lluvia_media.ogg"
]

onready var vientos:Array = [
	"res://RECURSOS/SONIDOS/AMBIENT/Vientos/viento_corto1.ogg",
	"res://RECURSOS/SONIDOS/AMBIENT/Vientos/viento_corto2.ogg",
	"res://RECURSOS/SONIDOS/AMBIENT/Vientos/viento_corto3.ogg",
	"res://RECURSOS/SONIDOS/AMBIENT/Vientos/viento_largo1.ogg",
	"res://RECURSOS/SONIDOS/AMBIENT/Vientos/viento_largo2.ogg",
	"res://RECURSOS/SONIDOS/AMBIENT/Vientos/viento_largo3.ogg"
]

enum intensidades_de_lluvia {poca, ligera, moderada, fuerte, ninguna}

export (intensidades_de_lluvia) var intensidad_tormenta:int = 0
export (bool) var hay_truenos:bool = true


var timer_truenos:SceneTreeTimer
var timer_truenos2:SceneTreeTimer
var timer_vientos:SceneTreeTimer

func _ready():
	Configurar_Tormenta(intensidad_tormenta)
	
	pass

func Configurar_Tormenta(valor:int):
	$CanvasLayer3/particulas_1.emitting = true
	$CanvasLayer/particulas_2.emitting = true
	$CanvasLayer2/particulas_3.emitting = true
	
	
	match valor:
		#poca
		0:
			
			$Lluvia.stream = load(lluvias[0])
			$Lluvia.play()
			$CanvasLayer3/particulas_1.emitting = true
			$CanvasLayer/particulas_2.emitting = true
			$CanvasLayer2/particulas_3.emitting = true
			
			$CanvasLayer3/particulas_1.amount = 1
			$CanvasLayer/particulas_2.amount = 10
			$CanvasLayer2/particulas_3.amount = 20
			
			var p_material2:ParticlesMaterial = $CanvasLayer/particulas_2.process_material as ParticlesMaterial
			p_material2.angle = 0
			p_material2.direction = Vector3(0,1,0)
			
			var p_material1:ParticlesMaterial = $CanvasLayer3/particulas_1.process_material
			p_material1.angle = 0
			p_material1.direction = Vector3(0,1,0)
			
			var p_material3:ParticlesMaterial = $CanvasLayer2/particulas_3.process_material
			p_material3.angle = 0
			p_material3.direction = Vector3(0,1,0)
			
			AudioManagerGlobal.PonerVolumenBuss("Lluvia",-10.0)
			AudioManagerGlobal.PonerVolumenBuss("Truenos",-20.0)
			
			AudioManagerGlobal.SetEfectoEnBuss("Truenos",0,true)
			AudioManagerGlobal.SetEfectoEnBuss("Lluvia",0,true)
			pass
		#ligera
		1:
			
			$Lluvia.stream = load(lluvias[0])
			$Lluvia.play()
			$CanvasLayer3/particulas_1.amount = 5
			$CanvasLayer/particulas_2.amount = 40
			$CanvasLayer2/particulas_3.amount = 80
			
			var p_material2:ParticlesMaterial = $CanvasLayer/particulas_2.process_material as ParticlesMaterial
			p_material2.angle = 0
			p_material2.direction = Vector3(0,1,0)
			
			var p_material1:ParticlesMaterial = $CanvasLayer3/particulas_1.process_material
			p_material1.angle = 0
			p_material1.direction = Vector3(0,1,0)
			
			var p_material3:ParticlesMaterial = $CanvasLayer2/particulas_3.process_material
			p_material3.angle = 0
			p_material3.direction = Vector3(0,1,0)
			
			AudioManagerGlobal.PonerVolumenBuss("Lluvia",-5.0)
			AudioManagerGlobal.PonerVolumenBuss("Truenos",-12.0)
			
			AudioManagerGlobal.SetEfectoEnBuss("Truenos",0,false)
			AudioManagerGlobal.SetEfectoEnBuss("Lluvia",1,true)
			pass
		#moderada
		2:
			
			$Lluvia.stream = load(lluvias[2])
			$Lluvia.play()
			$CanvasLayer3/particulas_1.amount = 20
			$CanvasLayer/particulas_2.amount = 150
			$CanvasLayer2/particulas_3.amount = 200
			
			var p_material2:ParticlesMaterial = $CanvasLayer/particulas_2.process_material as ParticlesMaterial
			p_material2.angle = -30
			p_material2.direction = Vector3(-0.25,1,0)
			
			var p_material1:ParticlesMaterial = $CanvasLayer3/particulas_1.process_material
			p_material1.angle = -30
			p_material1.direction = Vector3(-0.25,1,0)
			
			var p_material3:ParticlesMaterial = $CanvasLayer2/particulas_3.process_material
			p_material3.angle = -30
			p_material3.direction = Vector3(-0.25,1,0)
			
			AudioManagerGlobal.PonerVolumenBuss("Lluvia",-2.0)
			AudioManagerGlobal.PonerVolumenBuss("Truenos",-12.0)
			
			pass
		#fuerte
		3:
			
			$Lluvia.stream = load(lluvias[3])
			$Lluvia.play()
			$CanvasLayer3/particulas_1.amount = 80
			$CanvasLayer/particulas_2.amount = 260
			$CanvasLayer2/particulas_3.amount = 400
			
			$CanvasLayer3/particulas_1.speed_scale = 30
			$CanvasLayer/particulas_2.speed_scale = 16
			$CanvasLayer2/particulas_3.speed_scale = 10
			
			var p_material2:ParticlesMaterial = $CanvasLayer/particulas_2.process_material as ParticlesMaterial
			p_material2.angle = -30
			p_material2.direction = Vector3(-0.25,1,0)
			
			var p_material1:ParticlesMaterial = $CanvasLayer3/particulas_1.process_material
			p_material1.angle = -30
			p_material1.direction = Vector3(-0.25,1,0)
			
			var p_material3:ParticlesMaterial = $CanvasLayer2/particulas_3.process_material
			p_material3.angle = -30
			p_material3.direction = Vector3(-0.25,1,0)
			
			
			AudioManagerGlobal.PonerVolumenBuss("Lluvia",-12.0)
			AudioManagerGlobal.PonerVolumenBuss("Truenos",-12.0)
			pass
		#ninguna:
		4:
			$Lluvia.stop()
			hay_truenos = false
			
			$CanvasLayer3/particulas_1.emitting = false
			$CanvasLayer/particulas_2.emitting = false
			$CanvasLayer2/particulas_3.emitting = false
	
	
	##Truenos:
	if hay_truenos:
		IniciarTruenos(intensidad_tormenta)
	else:
		$Truenos.stop()
		$Truenos2.stop()
		$Truenos3.stop()

func IniciarTruenos(intensidad:int):
	match intensidad:
		0:
			$Truenos.stream = load(truenos_lejanos[randi()%truenos_lejanos.size()])
			
			timer_truenos = get_tree().create_timer(rand_range(1.0,6.0))
			timer_truenos.connect("timeout",$Truenos,"play")
		
		1:
			$Truenos.stream = load(truenos_lejanos[randi()%truenos_lejanos.size()])
			$Truenos2.stream = load(truenos_lejanos[randi()%truenos_lejanos.size()])
			timer_truenos = get_tree().create_timer(rand_range(1.0,10.0))
			timer_truenos2 = get_tree().create_timer(rand_range(5.0,20.0))
			timer_truenos.connect("timeout",$Truenos,"play")
			timer_truenos2.connect("timeout",$Truenos2,"play")
		
		2:
			$Truenos.stream = load(truenos_lejanos[randi()%truenos_lejanos.size()])
			$Truenos2.stream = load(truenos_lejanos[randi()%truenos_lejanos.size()])
			timer_truenos = get_tree().create_timer(rand_range(0.5,6.0))
			timer_truenos2 = get_tree().create_timer(rand_range(2.0,15.0))
			timer_truenos.connect("timeout",$Truenos,"play")
			timer_truenos2.connect("timeout",$Truenos2,"play")
		
		3:
			$Truenos.stream = load(truenos_lejanos[randi()%truenos_lejanos.size()])
			$Truenos2.stream = load(truenos_lejanos[randi()%truenos_lejanos.size()])
			timer_truenos = get_tree().create_timer(rand_range(0.5,6.0))
			timer_truenos2 = get_tree().create_timer(rand_range(1.0,8.0))
			timer_truenos.connect("timeout",$Truenos,"play")
			timer_truenos2.connect("timeout",$Truenos2,"play")
			
			$Viento.stream = load(vientos[randi()%vientos.size()])
			timer_vientos= get_tree().create_timer(rand_range(1.5,5.0))
			timer_vientos.connect("timeout",$Viento,"play")
			
			pass
	pass



func _on_Truenos_finished():
	if hay_truenos:
		match intensidad_tormenta:
			0:
				$Truenos.stream = load(truenos_lejanos[randi()%truenos_lejanos.size()])
				timer_truenos = get_tree().create_timer(rand_range(2.0,20.0))
				timer_truenos.connect("timeout",$Truenos,"play")
			
			1:
				$Truenos.stream = load(truenos_lejanos[randi()%truenos_lejanos.size()])
				timer_truenos = get_tree().create_timer(rand_range(2.0,10.0))
				timer_truenos.connect("timeout",$Truenos,"play")
				
			2:
				$Truenos.stream = load(truenos_lejanos[randi()%truenos_lejanos.size()])
				
				timer_truenos = get_tree().create_timer(rand_range(5.0,10.0))
				timer_truenos.connect("timeout",$Truenos,"play")
			
			3:
				$Truenos.stream = load(truenos_lejanos[randi()%truenos_lejanos.size()])
				
				timer_truenos = get_tree().create_timer(rand_range(3.0,8.0))
				timer_truenos.connect("timeout",$Truenos,"play")
		pass

	
	pass # Replace with function body.


func _on_Truenos2_finished():
	match intensidad_tormenta:
		1:
			$Truenos2.stream = load(truenos_lejanos[randi()%truenos_lejanos.size()])
			timer_truenos2 = get_tree().create_timer(rand_range(5.0,20.0))
			timer_truenos2.connect("timeout",$Truenos2,"play")
		
		2,3:
			if randi()%10 > 7:
				$Truenos2.stream = load(truenos_lejanos[randi()%truenos_lejanos.size()])
			else:
				$Truenos2.stream = load(truenos_fuertes[randi()%truenos_fuertes.size()])
				
			timer_truenos2 = get_tree().create_timer(rand_range(1.0,20.0))
			timer_truenos2.connect("timeout",$Truenos2,"play")
	pass # Replace with function body.


func _on_Truenos3_finished():
	pass # Replace with function body.


func _on_Viento_finished():
	$Viento.stream = load(vientos[randi()%vientos.size()])
	timer_vientos= get_tree().create_timer(rand_range(1.5,5.0))
	timer_vientos.connect("timeout",$Viento,"play")
	$AnimationPlayer.play("lluvia1")
	pass # Replace with function body.
