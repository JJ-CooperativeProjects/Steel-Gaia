extends Camera2D

export (float, 0, 1) var decaimiento = 0.75
export var max_offset: Vector2 = Vector2(80,80)
export var max_rotation: float = 0.5

var trauma: float = 0
var max_trauma = 4
var coeficiente_trauma:float = 0

var noise_y:float
var velocidad:float = 1
var seed_x:int = 2
var seed_y:int = 2

onready var noise: OpenSimplexNoise = OpenSimplexNoise.new()


func _ready():
	noise.seed = randi()
	noise.period = 4
	Memoria.camara_actual = self

func _input(event):
#	if event.is_action_pressed("escopeta"):
#		sacudir(20,0,1,500,Vector2(60,200))
	pass

	
func comenzar()->Vector2:
	var cantidad = pow(trauma, max_trauma - coeficiente_trauma)
	noise_y += velocidad
	rotation = max_rotation * cantidad * noise.get_noise_2d(noise.seed, noise_y)
	var offset_x = max_offset.x * cantidad * noise.get_noise_2d(noise.seed * seed_x, noise_y)
	var offset_y = max_offset.y * cantidad * noise.get_noise_2d(noise.seed * seed_y, noise_y)
	return Vector2(offset_x,offset_y)
	pass

func sacudir(cantidad:float = 5,trauma_pluss:int = 0,max_trauma_control:int= 4,velocidad_pluss:float = 1,offset_pluss:Vector2= Vector2(80,80),decaimiento:float= 0.75,seed_x_pluss:int = 3,seed_y_pluss:int = 3):
	coeficiente_trauma = trauma_pluss
	max_trauma = max_trauma_control
	trauma = min(trauma + cantidad, 1.0)
	velocidad = velocidad_pluss
	seed_x = seed_x_pluss
	seed_y = seed_y_pluss
	max_offset = offset_pluss


