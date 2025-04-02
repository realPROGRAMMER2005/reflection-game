extends CharacterBody2D
class_name Projectile

@export var ricochet_enabled: bool = false
@export var ricochets: int = 1


signal hitbox_area_collided

var ricocheted: bool = false
var sender: Node2D

@export var speed: int = 250
@export var damage: int = 1
@export var lifetime: float = 5

var total_lifetime: float = 0

@onready var visuals: ProjectileVisuals = get_node("ProjectileVisuals")
var lifetimer: float = 0

var group: String
var direction = Vector2.RIGHT
var ricochet_count: int = 0

func _ready() -> void:
	ricochet_count = ricochets
	connect('hitbox_area_collided', on_hitbox_area_collided)

func handle_lifetime(delta):
	lifetimer += delta
	total_lifetime += delta
	
	if lifetimer >= lifetime:
		on_lifetimer_out()
	

func on_lifetimer_out():
	die()

func _physics_process(delta: float) -> void:
	handle_lifetime(delta)
	velocity = speed * direction
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		var collider = collision.get_collider()
		if collider is Wall:
			collider.emit_signal('projectile_collided', global_position, damage)
		if ricochet_enabled:
			if ricochet_enabled and ricochet_count > 0:
				direction = direction.bounce(collision.get_normal())
				visuals.spawn_impact_particles({'amount': 8, 'initial_velocity_max': 50})
				ricochet_count -= 1
				ricocheted = true
				
				visuals.global_rotation = direction.angle()
			else:
				die()
		else:
			die()

func on_hitbox_area_collided():
	direction = -direction
	visuals.global_rotation = direction.angle()
	visuals.spawn_impact_particles({'amount': 8, 'initial_velocity_max': 50})
	

func die():
	visuals.spawn_impact_particles()
	EventBus.shake(0.4, global_position)
	queue_free()
