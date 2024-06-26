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
	var direction := transform.basis * Vector3(input_dir.x, 0, input_dir.y)
	
	velocity.z = direction.z * normal_speed
	velocity.x = direction.x * normal_speed
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		look_around(event.relative)
		
func look_around(relative: Vector2) -> void:
	rotate_y(-relative.x * mouse_sensitivity)
	head.rotate_x(-relative.y * mouse_sensitivity)
