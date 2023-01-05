extends Habilidad


var objetos_debajo:Array = [] #Toma referencia a todos los objetos que puede recoger en un momento dado

func _ready():
	mi_ente = get_parent().get_parent() as Jugador
	mef_ente = mi_ente.get_node("MEF") 
	

func _physics_process(delta):
	$AreaDetectorObjetos.global_position = mi_ente.global_position

#Un objeto al alcance:
func _on_AreaDetectorObjetos_body_entered(body):
	
	pass # Replace with function body.


func _on_AreaDetectorObjetos_area_entered(area):
	var colectable:ObjetoColectable = area.get_parent() as ObjetoColectable
	
	if colectable:
		colectable.emit_signal("es_recogido")
	pass # Replace with function body.
