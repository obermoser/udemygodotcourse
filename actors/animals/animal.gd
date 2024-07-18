extends CharacterBody3D

@onready var idle_timer: Timer = %"Idle Timer"
@onready var wander_timer: Timer = %"Wander Timer"
@onready var disappear_after_death_timer: Timer = %"Disappear After Death Timer"
@onready var main_collision_shape: CollisionShape3D = $CollisionShape3D
@onready var meat_spawn_marker: Marker3D = $"Meat Spawn Marker"
@onready var animation_player:AnimationPlayer = %"AnimationPlayer"
@onready var health = max_health

@export var normal_speed := 0.6
@export var max_health := 80.0
@export var idle_animations : Array[String] = []
@export var turn_speed_weight := 0.07
@export var min_idle_time := 2.0
@export var max_idle_time := 7.0
@export var min_wander_time := 2.0
@export var max_wander_time := 4.0

enum States {
	Idle,
	Wander,
	Dead
}
var state := States.Idle

func _ready() -> void:
	animation_player.animation_finished.connect(animation_finished)

func _physics_process(_delta: float) -> void:
	if state == States.Wander:
		wander_loop()

#region Animations
func animation_finished(anim_name:String) -> void:
	if state == States.Idle:
		animation_player.play(idle_animations.pick_random())
#endregion

func wander_loop() -> void:
	look_forward()
	move_and_slide()
	
	
func look_forward() -> void:
	rotation.y = lerp_angle(rotation.y,atan2(velocity.x, velocity.z) + PI, turn_speed_weight)


func pick_wander_velocity()->void:
	var dir = Vector2(0,-1).rotated(randf()*PI*2)
	velocity = Vector3(dir.x, 0, dir.y) * normal_speed


func set_state(new_state:States) -> void:
	state = new_state

func _on_idle_timer_timeout() -> void:
	set_state(States.Wander)

func _on_wander_timer_timeout() -> void:
		set_state(States.Idle)


func _on_disappear_after_death_timer_timeout() -> void:
	queue_free()
