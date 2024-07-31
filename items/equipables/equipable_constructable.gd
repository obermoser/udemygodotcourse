extends EquipableItem
class_name EquippableConstructable

const VALID_MAT : StandardMaterial3D = preload("res://resources/materials/constructable_valid_material.tres")
const INVALID_MAT:StandardMaterial3D=preload("res://resources/materials/constructable_invalid_material.tres")

@onready var item_place_ray: RayCast3D = $ItemPlaceRay
@onready var constructable_area: Area3D = $ConstructableArea
@onready var constructable_area_col_shape: CollisionShape3D = $ConstructableArea/CollisionShape3D
@onready var constructable_preview_mesh: MeshInstance3D = $ConstructableArea/ConstructablePreviewMesh

var constructable_item_key: ItemConfig.Keys
var obstacles: Array[Node3D] = []
var placeValid := false

func _ready() -> void:
	constructable_area.rotation = Vector3.ZERO
	constructable_preview_mesh.mesh = $MeshHolder.get_child(0).mesh_duplicate()
	constructable_area_col_shape.shape = constructable_preview_mesh.mesh.create_convex_shape()
	
func set_preview_material(mat: StandardMaterial3D)->void:
	for i in constructable_preview_mesh.mesh.get_surface_count():
		constructable_preview_mesh.set_surface_override_material(i, mat)
	
func _process(_delta: float) -> void:
	constructable_area.global_rotation.y = global_rotation.y + PI
	set_valid(check_build_validity())
	

func set_valid(valid:bool)->bool:
	if placeValid == valid:
		return true
	return false

func check_build_validity(valid:bool)->bool:
	return true
