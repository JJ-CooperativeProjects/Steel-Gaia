extends Particles2D


func _ready():
	
	pass

func _inicio(cantidad_particulas:int,largo:int,ancho:int):
	var part_material:ParticlesMaterial = process_material
	part_material.emission_box_extents = Vector3(largo, ancho, 1)
	amount = cantidad_particulas
	pass
