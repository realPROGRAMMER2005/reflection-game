@tool
extends Node2D
class_name CometVisuals

@export var comet_color: Color = Color.BLUE:
	set(value):
		comet_color = value
		apply_color()

func _ready():
	apply_color()

func apply_color():
	
	if !is_inside_tree():
		return
		
	var tails = get_node("Tails").get_children() if has_node("Tails") else []
	var body_parts = get_node("BobyParts").get_children() if has_node("BobyParts") else []
	var eyes = get_node("Eyes").get_children() if has_node("Eyes") else []
	
	for part in tails + body_parts:
		if part.has_method("set_self_modulate"):
			part.self_modulate = comet_color
		elif part.has_property("self_modulate"):
			part.self_modulate = comet_color
		elif part.has_property("color"):
			part.color = comet_color
	
	for eye in eyes:
		if eye.has_method("set_self_modulate"):
			eye.self_modulate = Color.WHITE
		elif eye.has_property("self_modulate"):
			eye.self_modulate = Color.WHITE
		elif eye.has_property("color"):
			eye.color = Color.WHITE
