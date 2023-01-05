extends Node2D

onready var anim:AnimationPlayer = $AnimationPlayer

func _ready():
	$AnimationPlayer.play("quieto")
