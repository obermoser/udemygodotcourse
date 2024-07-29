extends CharacterBody3D

const ANIM_BLEND := 0.2

@onready var flee_timer: Timer = $"Timers/Flee Timer"
@onready var idle_timer: Timer = %"Idle Timer"
@onready var wander_timer: Timer = %"Wander Timer"
@onready var disappear_after_death_timer: Timer = %"Disappear After Death Timer"
@onready var main_collision_shape: CollisionShape3D = $CollisionShape3D
@onready var meat_spawn_marker: Marker3D = $"Meat Spawn Marker"
@onready var animation_player:AnimationPlayer = %"AnimationPlayer"
@onready var health = max_health
@onready var player:CharacterBody3D = get_tree().get_first_node_in_group("Player")

@export var normal_speed := 0.6
@export var alarmed_speed := 3.0
@export var max_health := 80.0
@export var idle_animations : Array[String] = []
@export var hurt_animations : Array[String] = []
@export var turn_speed_weight := 0.07
@export var min_idle_time := 2.0
@export var max_idle_time := 7.0
@export var min_wander_time := 2.0
@export var max_wander_time := 4.0
@export var isAggressive := false
@export var flee_time := 3.0

@export var attacking_distance := 2.0
@export var damage := 20.0

@onready var eyes_marker: Marker3D = $"Eyes Marker"
@onready var attack_hit_area: Area3D = $"Attack Hit Area"
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D


enum States {
	Idle,
	Wander,
	Dead,
	Flee,
	Hurt,
	Chase,
	Attack
}
var state := States.Idle

func _ready() -> void:
	animation_player.animation_finished.connect(animation_finished)

func _physics_process(_delta: float) -> void:
	if state == States.Wander:
		wander_loop()
	elif state == States.Flee:
		flee_loop()
	elif state == States.Chase:
		chase_loop()
	elif state == States.Attack:
		attack_loop()

#region Animations
func animation_finished(anim_name:String) -> void:
	if state == States.Idle:
		animation_player.play(idle_animations.pick_random(), ANIM_BLEND)
	
	elif  state == States.Hurt:
		if not isAggressive:
			set_state(States.Flee)
		
		else:
			set_state(States.Chase)
	if state == States.Attack:
		set_state(States.Chase)
#endregion

#region Loops
func wander_loop() -> void:
	look_forward()
	move_and_slide()
	
func flee_loop() -> void:
	look_forward()
	move_and_slide()
	
func chase_loop()->void:
	print("Now Chasing")
	look_forward()
	if global_position.distance_to(player.global_position) < attacking_distance:
		set_state(States.Attack)
		return
	nav_agent.target_position = player.global_position
	var dir := global_position.direction_to(nav_agent.get_next_path_position())
	dir.y = 0
	velocity = dir.normalized() * alarmed_speed
	move_and_slide()

func attack_loop()->void:
	print("Now Attacking")
	look_forward()
	var dir = global_position.direction_to(player.global_position)
	rotation.y = lerp_angle(rotation.y, atan2(dir.x,dir.z)*PI, turn_speed_weight)
	move_and_slide()
	
#endregion

#region Funcs
func look_forward() -> void:
	rotation.y = lerp_angle(rotation.y,atan2(velocity.x, velocity.z) + PI, turn_speed_weight)

func pick_wander_velocity()->void:
	var dir = Vector2(0,-1).rotated(randf()*PI*2)
	velocity = Vector3(dir.x, 0, dir.y) * normal_speed

func pick_away_from_player_velocity():
	if not player:
		set_state(States.Idle)
		return
	var dir := player.global_position.direction_to(global_position)
	dir.y = 0
	velocity = dir.normalized() * alarmed_speed
	
func take_hit(weapon_item_resource:WeaponItemResource) -> void:
	health -= weapon_item_resource.damage
	if state != States.Dead and health <= 0:
		set_state(States.Dead)
		
	elif not state in [States.Flee, States.Dead]:
		set_state(States.Hurt)

func attack()->void:
	if player in attack_hit_area.get_overlapping_bodies():
		EventSystem.PLA_change_health.emit(-damage)
		print("ATTACK")

#endregion	

#region State Management
func set_state(new_state:States) -> void:
	state = new_state
	match state:
		States.Idle:
			idle_timer.start(randf_range(min_idle_time, max_idle_time))
			animation_player.play(idle_animations.pick_random(), ANIM_BLEND)
		
		States.Wander:
			pick_wander_velocity()
			wander_timer.start(randf_range(min_wander_time, max_wander_time))
			animation_player.play("Walk", ANIM_BLEND)

		
		States.Dead:
			animation_player.play("Death", ANIM_BLEND)
			main_collision_shape.disabled = true
			var meat_scene = ItemConfig.get_pickupable_item(ItemConfig.Keys.RawMeat)
			EventSystem.SPA_spawn_scene.emit(meat_scene, meat_spawn_marker.global_transform)
			idle_timer.stop()
			wander_timer.stop()
			flee_timer.stop()
			set_physics_process(false)
			disappear_after_death_timer.start(15)
			
		States.Hurt:
			idle_timer.stop()
			wander_timer.stop()
			flee_timer.stop()
			animation_player.play(hurt_animations.pick_random(), ANIM_BLEND)
		
		States.Flee:
			pick_away_from_player_velocity()
			animation_player.play("Gallop", ANIM_BLEND)
			flee_timer.start(flee_time)
			
		States.Chase:
			idle_timer.stop()
			wander_timer.stop()
			flee_timer.stop()
			animation_player.play("Gallop", ANIM_BLEND)
		
		States.Attack:
			animation_player.play("Attack", ANIM_BLEND)
#endregion

#region Timers
func _on_idle_timer_timeout() -> void:
	set_state(States.Wander)

func _on_wander_timer_timeout() -> void:
		set_state(States.Idle)

func _on_disappear_after_death_timer_timeout() -> void:
	queue_free()

func _on_flee_timer_timeout() -> void:
	set_state(States.Idle)
#endregion
