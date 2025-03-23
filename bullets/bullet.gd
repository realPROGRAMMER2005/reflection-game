extends CharacterBody2D
class_name Bullet

@export var damage: int = 25
@export var movement_speed: int = 700
@export var penetration: int = 0
@export var ricochets: int = 0
@export var damage_multiple_characters: bool = false
@onready var damage_area: DamageArea = get_node("DamageArea")
@export var disappear_on_hit_world: bool = true
@export var damage_once: bool = true
@export var lifetime: float = 5
@export var dissaper_on_lifetime_out: bool = true
@export var disappear_on_damage: bool = true


var damage_groups: Array[String] = []
var direction: Vector2 = Vector2.RIGHT
var lifetimer: float = 0


func _ready() -> void:
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
		
		damage_area.damaged_hitboxes.append(hitbox_area)
		on_hit_target()
		
		
		if not damage_multiple_characters:
			break
			




func _physics_process(delta: float) -> void:
	handle_lifetime(delta)
	handle_velocity(delta)
	handle_damage_area()
	move_and_slide()
