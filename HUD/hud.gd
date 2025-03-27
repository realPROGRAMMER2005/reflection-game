extends CanvasLayer


var hp := 100
var curr_hp := 100
@onready var hp_bar = $Border/HP
@onready var red_hp_bar = $Border/RED_HP
var MAX_SIZE: int = 200
var MAX_HP: int = 100
@export var decrease_delay := 1
@export var changing_speed := 60


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if curr_hp < hp:
		var change: int = changing_speed * MAX_SIZE * delta / MAX_HP
		var x = hp_bar.size.x
		var y = hp_bar.size.y
		hp_bar.set_size(Vector2(round(x + change), y))
		red_hp_bar.set_size(Vector2(round(x + change), y))
		curr_hp = hp_bar.size.x * MAX_HP / MAX_SIZE
	elif curr_hp > hp:
		var change: int = changing_speed * MAX_SIZE * delta / MAX_HP
		var x = red_hp_bar.size.x
		var y = hp_bar.size.y
		red_hp_bar.set_size(Vector2(round(x - change), y))
		curr_hp = red_hp_bar.size.x * MAX_HP / MAX_SIZE


func _on_decrease_button_pressed() -> void:
	hp -= 50
	hp_bar.set_size(Vector2(round(hp * MAX_SIZE / MAX_HP), hp_bar.size.y))
	

func _on_increase_button_pressed() -> void:
	hp += 50
