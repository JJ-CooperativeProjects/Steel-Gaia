extends EfectoEspecial


export (Vector2) var scale_coeficiente:Vector2 = Vector2.ZERO
export (float) var scale_coeficiente_f:float = 0.0
var coeficiente_shader:float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.get_material().set_shader_param("radius",$Sprite.get_material().get_shader_param("radius")+(coeficiente_shader*2))
	print($Sprite.get_material().get_shader_param("radius"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#scale_coeficiente = scale_coeficiente.normalized()
	$Sprite.scale *= scale_coeficiente_f
	pass
