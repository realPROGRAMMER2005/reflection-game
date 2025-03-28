extends RigidBody2D
class_name Projectile

@export var ricochet_enabled: bool = false
@export var ricochets: int = 1

@export var speed: int = 250

@export var damage: int = 25

@export var lifetime: float =  5
var lifetimer: float = 0

var group: String

func handle_lifetime(delta):
	lifetimer += delta
	if lifetimer >= lifetime:
		on_lifetimer_out()


func on_lifetimer_out():
	queue_free()

	
func _physics_process(delta: float) -> void:
	pass
