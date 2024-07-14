extends Node3D

@export var attributes: HittableObjectAttributes

var current_health:float

func _ready() -> void:
	current_health = attributes.max_health
	
func register_hit(weapon_item_resource : WeaponItemResource):
	if not attributes.weapon_filter.is_empty() and not weapon_item_resource.item_key in attributes.weapon_filter:
		return
	
	current_health -= weapon_item_resource.damage

	if current_health <= 0:
		die()
		
func die():
	queue_free()
