extends Node2D
class_name Level

@export var wall_scene = preload("res://wall/Wall.tscn")
@export var player_scene = preload("res://characters/player/Player.tscn")
@export var camera_scene: PackedScene = preload("res://camera/Camera.tscn")
@export var irregularity_strength: float = 0.2
@export var width = 30
@export var height = 30
var border_width = 1
@export var irregularity_detail: int = 1
@export var min_room_size: int = 4
@export var max_room_size: int = 6
@export var room_count: int = 20
@export var corridor_width: int = 2
@export var residents: Array[PackedScene] = [preload("res://characters/bad_comets/BadCometA.tscn")]

var level_change_time: float = 5
var level_change_timer: float = 0
var change_level: bool = false
var character: Array
var room_wall_density: float = 0.5
var corridor_wall_density: float = 0.1
var camera: Camera
var player: Character
@export var level_difficulty: int = 1

const CELL_SIZE = 24
var player_spawn_room: Rect2i
var level_cleared_emitted: bool = false

func setup_camera():
	camera = camera_scene.instantiate()
	camera.target = player
	add_child(camera)
	camera.position = player.position

func _ready():
	EventBus.restart.connect(restart_game)
	EventBus.level_change.connect(next_level)
	start_level()

func start_level():
	level_cleared_emitted = false
	clear_level()
	adjust_level_size()
	generate_level_content()

func clear_level():
	for child in get_children():
		child.queue_free()
	player = null
	Settings.enemies_count = 0
	Settings.kills = 0

func adjust_level_size():
	width = 30 + level_difficulty * 5
	height = 30 + level_difficulty * 5
	room_count = 5 + level_difficulty * 2

func generate_level_content():
	var level = generate_level(width, height, border_width)
	create_walls_from_level(level)
	create_navigation_regions(level)
	await get_tree().process_frame
	spawn_player()
	setup_camera()
	spawn_residents(level)

func generate_level(width: int, height: int, border_width: int) -> Array:
	var level = []
	for y in range(height):
		var row = []
		for x in range(width):
			row.append(1)
		level.append(row)
	var rooms = []
	for i in range(room_count):
		var room_width = randi_range(min_room_size, max_room_size)
		var room_height = randi_range(min_room_size, max_room_size)
		var room_x = randi_range(border_width, width - border_width - room_width - 1)
		var room_y = randi_range(border_width, height - border_width - room_height - 1)
		var new_room = Rect2i(room_x, room_y, room_width, room_height)
		var overlaps = false
		for room in rooms:
			if new_room.intersects(room):
				overlaps = true
				break
		if not overlaps:
			rooms.append(new_room)
			if rooms.size() == 1:
				create_empty_room(level, new_room)
			else:
				create_room(level, new_room)
	if rooms.size() > 0:
		player_spawn_room = rooms[0]
		clear_spawn_area(level)
	for i in range(1, rooms.size()):
		var prev_room = rooms[i - 1]
		var current_room = rooms[i]
		var prev_center = prev_room.position + prev_room.size / 2
		var current_center = current_room.position + current_room.size / 2
		if randf() > 0.5:
			create_corridor(level, Vector2i(prev_center.x, prev_center.y), Vector2i(prev_center.x, current_center.y))
			create_corridor(level, Vector2i(prev_center.x, current_center.y), Vector2i(current_center.x, current_center.y))
		else:
			create_corridor(level, Vector2i(prev_center.x, prev_center.y), Vector2i(current_center.x, prev_center.y))
			create_corridor(level, Vector2i(current_center.x, prev_center.y), Vector2i(current_center.x, current_center.y))
	clear_spawn_area(level)
	return level

func clear_spawn_area(level: Array):
	if not player_spawn_room:
		return
	var center_x = player_spawn_room.position.x + player_spawn_room.size.x / 2
	var center_y = player_spawn_room.position.y + player_spawn_room.size.y / 2
	var radius = 2
	for y in range(center_y - radius, center_y + radius + 1):
		for x in range(center_x - radius, center_x + radius + 1):
			if x >= 0 and x < width and y >= 0 and y < height:
				level[y][x] = 0

func create_empty_room(level: Array, room: Rect2i):
	for y in range(room.position.y, room.end.y):
		for x in range(room.position.x, room.end.x):
			level[y][x] = 0

func create_room(level: Array, room: Rect2i):
	for y in range(room.position.y + 1, room.end.y - 1):
		for x in range(room.position.x + 1, room.end.x - 1):
			if randf() < room_wall_density:
				level[y][x] = 1
			else:
				level[y][x] = 0
	for y in range(room.position.y, room.end.y):
		level[y][room.position.x] = 1
		level[y][room.end.x - 1] = 1
	for x in range(room.position.x, room.end.x):
		level[room.position.y][x] = 1
		level[room.end.y - 1][x] = 1

func create_corridor(level: Array, from: Vector2i, to: Vector2i):
	var x_start = min(from.x, to.x)
	var x_end = max(from.x, to.x)
	for x in range(x_start, x_end + 1):
		for dy in range(-corridor_width / 2, corridor_width / 2 + 1):
			var y = from.y + dy
			if y >= 0 and y < level.size() and x >= 0 and x < level[0].size():
				if randf() < corridor_wall_density:
					level[y][x] = 1
				else:
					level[y][x] = 0
	var y_start = min(from.y, to.y)
	var y_end = max(from.y, to.y)
	for y in range(y_start, y_end + 1):
		for dx in range(-corridor_width / 2, corridor_width / 2 + 1):
			var x = to.x + dx
			if y >= 0 and y < level.size() and x >= 0 and x < level[0].size():
				if randf() < corridor_wall_density:
					level[y][x] = 1
				else:
					level[y][x] = 0

func create_walls_from_level(level: Array):
	for y in range(level.size()):
		for x in range(level[y].size()):
			if level[y][x] == 1:
				create_wall_at_position(x, y)

func create_wall_at_position(x: int, y: int):
	var wall = wall_scene.instantiate() as Wall
	add_child(wall)
	wall.position = Vector2(x * CELL_SIZE, y * CELL_SIZE)
	var polygon = generate_irregular_polygon(x, y)
	if wall.has_node("Polygon2D"):
		wall.get_node("Polygon2D").polygon = polygon
	if wall.has_node("CollisionPolygon2D"):
		wall.get_node("CollisionPolygon2D").polygon = polygon

func create_navigation_regions(level: Array):
	for y in range(level.size()):
		for x in range(level[y].size()):
			if level[y][x] == 0:
				var nav_region = NavigationRegion2D.new()
				var nav_poly = NavigationPolygon.new()
				var half_size = CELL_SIZE / 2
				var vertices = PackedVector2Array([Vector2(-half_size, -half_size), Vector2(half_size, -half_size), Vector2(half_size, half_size), Vector2(-half_size, half_size)])
				nav_poly.add_outline(vertices)
				nav_poly.make_polygons_from_outlines()
				nav_region.navigation_polygon = nav_poly
				add_child(nav_region)
				nav_region.position = Vector2(x * CELL_SIZE, y * CELL_SIZE)

func spawn_player():
	if player_spawn_room:
		var center_x = player_spawn_room.position.x + player_spawn_room.size.x / 2
		var center_y = player_spawn_room.position.y + player_spawn_room.size.y / 2
		player = player_scene.instantiate()
		add_child(player)
		player.position = Vector2(center_x * CELL_SIZE, center_y * CELL_SIZE)

func spawn_residents(level: Array):
	var spawn_rooms = []
	for y in range(level.size()):
		for x in range(level[y].size()):
			if level[y][x] == 0:
				var pos = Vector2i(x, y)
				var in_spawn_room = false
				if player_spawn_room:
					in_spawn_room = player_spawn_room.has_point(pos)
				if not in_spawn_room:
					spawn_rooms.append(pos)
	var min_distance = 5
	var player_pos = Vector2i(player.position.x / CELL_SIZE, player.position.y / CELL_SIZE)
	spawn_rooms = spawn_rooms.filter(func(pos): return pos.distance_to(player_pos) > min_distance)
	var resident_count = min(level_difficulty * 2, spawn_rooms.size())
	spawn_rooms.shuffle()
	Settings.enemies_count = resident_count
	for i in range(resident_count):
		if i >= spawn_rooms.size():
			Settings.enemies_count = i
			break
		var pos = spawn_rooms[i]
		var resident = residents[randi() % residents.size()].instantiate()
		add_child(resident)
		resident.position = Vector2(pos.x * CELL_SIZE, pos.y * CELL_SIZE)

func generate_irregular_polygon(x: int, y: int) -> PackedVector2Array:
	var half_size = CELL_SIZE / 2
	var base_polygon = [Vector2(-half_size, -half_size), Vector2(half_size, -half_size), Vector2(half_size, half_size), Vector2(-half_size, half_size)]
	var irregular_polygon = PackedVector2Array()
	for i in range(base_polygon.size()):
		var start_point = base_polygon[i]
		var end_point = base_polygon[(i + 1) % base_polygon.size()]
		irregular_polygon.append(start_point)
		for j in range(1, irregularity_detail + 1):
			var t = j / float(irregularity_detail + 1)
			var point = start_point.lerp(end_point, t)
			var normal = (end_point - start_point).orthogonal().normalized()
			var irregularity = randf_range(-irregularity_strength, irregularity_strength) * half_size
			var corner_factor = min(t, 1 - t) * 2
			irregularity *= corner_factor
			point += normal * irregularity
			irregular_polygon.append(point)
	return irregular_polygon

func restart_game():
	level_difficulty = 1
	Settings.level_difficulty = level_difficulty
	start_level()

func next_level():
	level_difficulty += 1
	Settings.level_difficulty = level_difficulty
	start_level()

func _process(delta: float) -> void:
	if Settings.kills >= Settings.enemies_count and not level_cleared_emitted:
		level_cleared_emitted = true
		EventBus.on_level_cleared()
