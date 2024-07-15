extends Camera3D
@onready var equipment_cam: Camera3D = $"../SubViewportContainer/SubViewport/EquipmentCam"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	equipment_cam.global_transform = global_transform
