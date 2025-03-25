extends Node2D
class_name LevelSegment


var next_segment_point: NextSegmentPoint

func _ready() -> void:
	next_segment_point = Utilities.find_node_by_class_name(self, NextSegmentPoint)
