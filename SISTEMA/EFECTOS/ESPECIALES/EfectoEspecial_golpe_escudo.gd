extends EfectoEspecial

onready var pistas:Array = [
	"res://RECURSOS/SONIDOS/EFECTOS/Metal_hit/001.wav",
	"res://RECURSOS/SONIDOS/EFECTOS/Metal_hit/01.wav",
	"res://RECURSOS/SONIDOS/EFECTOS/Metal_hit/02.wav"
]

func _ready():
	$AnimationPlayer.play("efecto")
	var stream1:AudioStreamSample = load(pistas[randi()%pistas.size()])
	$AudioStreamPlayer2D.stream = stream1
	$AudioStreamPlayer2D.play(0.0)

func _on_AnimationPlayer_animation_finished(anim_name):
	pass # Replace with function body.



func _on_AudioStreamPlayer2D_finished():
	queue_free()
	pass # Replace with function body.
