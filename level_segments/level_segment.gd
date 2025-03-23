extends Node
class_name LevelSegment

enum LevelSegmentTypes {FIRST, REGULAR, LAST}

@export var type: LevelSegmentTypes = LevelSegmentTypes.REGULAR
@onready var next_segment_point: NextSegmentPoint = get_node("NextSegmentPoint")
