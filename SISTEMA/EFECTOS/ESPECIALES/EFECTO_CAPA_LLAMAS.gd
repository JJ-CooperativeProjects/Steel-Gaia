extends CanvasLayer

func _ready():
	var tween:SceneTreeTween = create_tween()
	tween.tween_property($Efecto,"modulate",Color.white,2.0)
