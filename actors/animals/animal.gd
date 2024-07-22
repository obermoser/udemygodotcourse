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

#region State Management
func set_state(new_state:States) -> void:
	state = new_state
	
	match state:
		States.Idle:
			idle_timer.start(randf_range(min_idle_time, max_idle_time))
			animation_player.play(idle_animations.pick_random())
		
		States.Wander:
			animation_player.play("Walk")
			pick_wander_velocity()
			wander_timer.start(randf_range(min_wander_time, max_wander_time))
		
		States.Dead:
			animation_player.play("Walk")
			animation_player.play("Death")
			main_collision_shape.disabled = true
			var meat_scene = ItemConfig.get_pickupable_item(ItemConfig.Keys.RawMeat)
			EventSystem.SPA_spawn_scene.emit(meat_scene, meat_spawn_marker.global_transform)
			idle_timer.stop()
			wander_timer.stop()
			set_physics_process(false)
			disappear_after_death_timer.start(15)
#endregion

func _on_idle_timer_timeout() -> void:
	set_state(States.Wander)

func _on_wander_timer_timeout() -> void:
		set_state(States.Idle)


func _on_disappear_after_death_timer_timeout() -> void:
	queue_free()


func take_hit(weapon_item_resource:WeaponItemResource) -> void:
	health -= weapon_item_resource.damage
	if state != States.Dead and health <= 0:
		set_state(States.Dead)
