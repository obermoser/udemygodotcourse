extends CharacterBody3D

@export var normal_speed := 3.0
@export var sprint_speed := 5.0
@export var mouse_sensitivity := 0.005
@export var jump_velocity := 5.0
@export var gravity := 0.2

@onready var head:Node3D = $Head
@onready var interaction_raycast: RayCast3D = $"Head/Interaction Raycast"

func _enter_tree() -> void:
	EventSystem.PLA_freeze_player.connect(set_freeze.bind(true))
	EventSystem.PLA_unfreeze_player.connect(set_freeze.bind(false))
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	move()
	
func _process(delta: float) -> void:
	interaction_raycast.check_interaction()
	
func move() -> void:
	var is_sprinting : bool
	if is_on_floor():
		is_sprinting = Input.is_action_pressed("sprint")
		if Input.is_action_just_pressed("jump"):
			velocity.y += jump_velocity
	else:
		velocity.y -= gravity
		is_sprinting = false
	
	var speed = normal_speed if not is_sprinting else sprint_speed
	
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := transform.basis * Vector3(input_dir.x, 0, input_dir.y)
	
	velocity.z = direction.z * speed
	velocity.x = direction.x * speed
	
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		look_around(event.relative)
		
		
func look_around(relative: Vector2) -> void:
	rotate_y(-relative.x * mouse_sensitivity)
	head.rotate_x(-relative.y * mouse_sensitivity)
	head.rotation_degrees.x = clampf(head.rotation_degrees.x, -90, 90)

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
	elif event.is_action_pressed("crafting_menu"):
		EventSystem.BUL_create_bulletin.emit(BulletinConfig.Keys.CraftingMenu)

func set_freeze(freeze:bool) -> void:
	set_process(!freeze)
	set_physics_process(!freeze)
	set_process_input(!freeze)
	set_process_unhandled_input(!freeze)
