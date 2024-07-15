extends Node3D
class_name EquipableItem


@onready var animation_player: AnimationPlayer = $AnimationPlayer

func try_to_use() -> void:
	if animation_player.is_playing():
		return
	animation_player.play("use_item")
