extends Camera2D
class_name Camera

@export var target: Node2D
@export var smooth_speed: float = 24
@export var max_shake_distance: float = 600.0
@export var shake_decay: float = 3.0
@export var max_offset: Vector2 = Vector2(30, 30)
@export var mouse_influence: float = 0.3

var shake_power: float = 0.0
var noise = FastNoiseLite.new()

func _ready():
	noise.seed = randi()
	noise.frequency = 0.5
	EventBus.camera_shake.connect(_on_shake_requested)

func _process(delta):
	if target:
		var mouse_pos = get_global_mouse_position()
		# Вычисляем точку между целью и курсором
		var target_pos = target.global_position.lerp(mouse_pos, mouse_influence)
		# Плавно двигаем камеру к этой точке
		global_position = global_position.lerp(target_pos, smooth_speed * delta)
	
	if shake_power > 0:
		shake_power = max(shake_power - shake_decay * delta, 0)
		_apply_shake(delta)
	elif offset != Vector2.ZERO:
		offset = Vector2.ZERO

func _on_shake_requested(intensity: float, source_pos: Vector2):
	if source_pos == Vector2.ZERO:
		shake_power = intensity
		return
	
	var distance = global_position.distance_to(source_pos)
	var distance_factor = clamp(1.0 - distance/max_shake_distance, 0.0, 1.0)
	shake_power = min(shake_power + intensity * distance_factor, 1.0)

func _apply_shake(delta):
	var strength = shake_power * shake_power
	var time = Time.get_ticks_msec() * 0.001
	
	offset = Vector2(
		noise.get_noise_2d(time * 30.0, 0.0) * max_offset.x * strength,
		noise.get_noise_2d(0.0, time * 30.0) * max_offset.y * strength
	)
