extends CharacterBody2D
class_name Character

@export var max_health: int = 100
var current_health: int = max_health
@export var group: String = "aliens"
@export var enemy_groups: Array[String] = ["people"]
@export var can_dash: bool = false
@export var avoid_damage_on_dash: bool = false



@export var movement_speed: int = 300

@export var fire_rate: float = 0.2
var fire_rate_timer: float = 0
var aiming_angle: float = 0

@export var damage: int = 25

enum CharacterMovementTypes {FLYING, WALKING}
@export var movement_type: CharacterMovementTypes = CharacterMovementTypes.FLYING
@export var bullets_spread: int = 1
@export var bullet_penetration: int = 0
@export var bullet_ricochets: int = 0
@export var can_jump: bool = false
@export var can_move: bool = false
@export var bullet_scene: PackedScene
@export var controlled_by_player: bool = false
@export var max_jumps_count: int = 1
@export var can_aim: bool = false


var muzzle: Muzzle
var hitbox_area: HitboxArea


@export var jump_force: float = 400.0
@export var gravity: float = 900
var jumps_remaining: int = max_jumps_count

signal get_damage

func _ready() -> void:
	muzzle = Utilities.find_node_by_class_name(self, Muzzle)
	hitbox_area = Utilities.find_node_by_class_name(self, HitboxArea)
	
	hitbox_area.connect("get_damage", on_get_damage)


func _process(delta: float) -> void:
	fire_rate_timer += delta

func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO
	
	if controlled_by_player and can_move:
		if Input.is_action_pressed("move_right"):
			direction.x += 1
		if Input.is_action_pressed("move_left"):
			direction.x -= 1
		
		if movement_type == CharacterMovementTypes.FLYING:
			if Input.is_action_pressed("move_down"):
				direction.y += 1
			if Input.is_action_pressed("move_up"):
				direction.y -= 1
		
		if movement_type == CharacterMovementTypes.WALKING:
			
			if not is_on_floor():
				velocity.y += gravity * delta
				
			if can_jump:

				if Input.is_action_just_pressed("move_up") and jumps_remaining > 0:
					velocity.y = -jump_force
					jumps_remaining -= 1
				
				if is_on_floor():
					jumps_remaining = max_jumps_count

		direction = direction.normalized()
		velocity.x = direction.x * movement_speed
	
	move_and_slide()
	
	if controlled_by_player and can_aim:
		aiming_angle = (rad_to_deg(global_position.angle_to_point(get_global_mouse_position())))
	
	if can_aim:
		muzzle.rotation_degrees = aiming_angle
	
	if controlled_by_player and Input.is_action_pressed("attack"):
		attack()

func on_get_damage(damage_amount: int) -> void:
	current_health -= damage_amount
	if current_health <= 0:
		die()


func die():
	queue_free()
	


func attack():
	if fire_rate_timer >= fire_rate:
		for i in range(bullets_spread):
				var bullet_instance: Bullet = bullet_scene.instantiate()
				bullet_instance.ricochets = bullet_ricochets
				bullet_instance.penetration = bullet_penetration
				bullet_instance.damage = damage
				bullet_instance.damage_groups = enemy_groups
				var level = get_parent()
				if level:
					level.add_child(bullet_instance)
				bullet_instance.global_position = muzzle.global_position
				bullet_instance.global_rotation = muzzle.global_rotation
				bullet_instance.sender_hitbox_area = hitbox_area
				bullet_instance.direction = Vector2(cos(muzzle.global_rotation), sin(muzzle.global_rotation)).normalized()
		
		fire_rate_timer = 0
				

	
