extends Character
class_name SpaceMarine

@onready var body_sprite = get_node("BodySprite")
@onready var legs_sprite = get_node("LegsSprite")


func _process(delta: float) -> void:
	super(delta)
	set_body_frame_by_angle(aiming_angle)
	
	if velocity.y == 0:
		if velocity.x != 0:
			legs_sprite.play("run")
		else:
			legs_sprite.play("stand")
	
	if velocity.x > 0:
		legs_sprite.scale.x = 1
	if velocity.x < 0:
		legs_sprite.scale.x = -1
	
	if not is_on_floor() and velocity.y < 0:
		legs_sprite.play("jump")
	elif not is_on_floor() and velocity.y >= 0:
		legs_sprite.play("fall")

func set_body_frame_by_angle(aiming_angle: float) -> void:
	aiming_angle = fmod(aiming_angle + 360, 360)  
	var frame_index = int(round((aiming_angle / 360.0) * 48)) % 48 
	body_sprite.frame = frame_index


	
