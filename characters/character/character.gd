extends CharacterBody2D
class_name Character

@export var controlled_by_player: bool = false
@export var speed: float = 45



func _physics_process(delta: float) -> void:
	if controlled_by_player:
		var mouse_pos = get_global_mouse_position()
		look_at(mouse_pos)
		
		var move_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		
		velocity = move_direction * speed
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()
