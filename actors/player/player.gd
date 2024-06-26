extends CharacterBody3D

@export var normal_speed := 3.0
@export var sprint_speed := 5.0
@export var mouse_sensitivity := 0.005
@export var jump_velocity := 4.0
@export var gravity := 0.2

@onready var head:Node3D = $Head

func _physics_process(delta: float) -> void:
	move()
	
	
func move() -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
