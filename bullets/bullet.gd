extends CharacterBody2D
class_name Bullet

var damage: int = 25
var movement_speed: int = 700
var penetration: int = 0
var ricochets: int = 0
var sender_hitbox_area: HitboxArea

@export var damage_multiple_characters: bool = false

@export var disappear_on_hit_world: bool = true
@export var damage_once: bool = true
@export var lifetime: float = 5
@export var dissaper_on_lifetime_out: bool = true
@export var disappear_on_damage: bool = true
@export var max_distance: int = 200
@export var enable_gravity: bool = false

@export var damage_target_once: bool = true
@export var damage_interval: float = 0.2
@export var can_penetrate: bool = true


var damage_inteval_timer_out: bool = true
var damage_interval_timer: float = damage_interval
var damage_groups: Array[String] = []
var direction: Vector2 = Vector2.RIGHT
var lifetimer: float = 0

var damage_area: DamageArea

func _ready() -> void:
	damage_area = Utilities.find_node_by_class_name(self, DamageArea)
	damage_area.damage_groups = damage_groups

func on_lifetime_out():
	if dissaper_on_lifetime_out:
		queue_free()

func handle_lifetime(delta: float):
	lifetimer += delta
	if lifetimer >= lifetime:
		on_lifetime_out()

func handle_velocity(delta: float) -> void:
	velocity = direction * movement_speed

func on_hit_target():
	if disappear_on_damage:
		queue_free()

func handle_damage_area():
	for hitbox_area: HitboxArea in damage_area.hitbox_areas_to_damage:
		hitbox_area.emit_signal("get_damage", damage)
		
		if sender_hitbox_area != hitbox_area:
			if ((not hitbox_area in damage_area.damaged_hitboxes and damage_once) or (not damage_once)) and can_damage():
				damage_area.damaged_hitboxes.append(hitbox_area)
			on_hit_target()
		
		
		if not damage_multiple_characters:
			break
			

func _physics_process(delta: float) -> void:
	
	handle_lifetime(delta)
	handle_velocity(delta)
	handle_damage_area()
	handle_damage_interval(delta)
	move_and_slide()

func handle_damage_interval(delta: float):
	damage_interval_timer += delta

func can_damage():
	return damage_interval_timer >= damage_interval
