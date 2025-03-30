extends Node2D
class_name Level

@export var wall_scene: = preload("res://wall/Wall.tscn")
@export var irregularity_strength: float = 0.3 # Сила неровностей (0-1)
@export var irregularity_detail: int = 1  # Детализация неровностей

# Размер ячейки (должен соответствовать размеру стены)
const CELL_SIZE = 32

# Функция генерации уровня с внутренними стенами
func generate_level(width: int, height: int, border_width: int, wall_density: float) -> Array:
	var level = []
	for y in range(height):
		var row = []
		for x in range(width):
			# Если позиция в рамке (внешние стены)
			if y < border_width or y >= height - border_width or x < border_width or x >= width - border_width:
				row.append(1)  # Стена
			else:
				# Внутренняя зона: с вероятностью wall_density ставим стену
				if randf() < wall_density:
					row.append(1)  # Внутренняя стена
				else:
					row.append(0)  # Пустота
		level.append(row)
	return level

# Функция для создания стен на основе массива уровня
func create_walls_from_level(level: Array):
	for y in range(level.size()):
		var row = level[y]
		for x in range(row.size()):
			if row[x] == 1:  # Если здесь должна быть стена
				create_wall_at_position(x, y)


func create_wall_at_position(x: int, y: int):
	var wall = wall_scene.instantiate() as Wall
	add_child(wall)
	wall.position = Vector2(x * CELL_SIZE, y * CELL_SIZE)
	
	# Создаем неровный полигон
	var polygon = generate_irregular_polygon(x, y)
	
	if wall.has_node("Polygon2D"):
		wall.get_node("Polygon2D").polygon = polygon
	if wall.has_node("CollisionPolygon2D"):
		wall.get_node("CollisionPolygon2D").polygon = polygon

func generate_irregular_polygon(x: int, y: int) -> PackedVector2Array:
	var half_size = CELL_SIZE / 2
	var base_polygon = [
		Vector2(-half_size, -half_size),
		Vector2(half_size, -half_size),
		Vector2(half_size, half_size),
		Vector2(-half_size, half_size)
	]
	
	# Добавляем неровности на каждую сторону
	var irregular_polygon = PackedVector2Array()
	
	for i in range(base_polygon.size()):
		var start_point = base_polygon[i]
		var end_point = base_polygon[(i + 1) % base_polygon.size()]
		
		# Добавляем начальную точку
		irregular_polygon.append(start_point)
		
		# Добавляем промежуточные неровные точки
		for j in range(1, irregularity_detail + 1):
			var t = j / float(irregularity_detail + 1)
			var point = start_point.lerp(end_point, t)
			
			# Создаем случайное смещение
			var normal = (end_point - start_point).orthogonal().normalized()
			var irregularity = randf_range(-irregularity_strength, irregularity_strength) * half_size
			
			# Уменьшаем неровности на углах
			var corner_factor = min(t, 1 - t) * 2
			irregularity *= corner_factor
			
			point += normal * irregularity
			
			irregular_polygon.append(point)
	
	return irregular_polygon

# Функция для вывода уровня в консоль
func print_level(level: Array):
	for row in level:
		var row_str = ""
		for cell in row:
			if cell == 1:
				row_str += "# "  # Стена
			else:
				row_str += ". "  # Пустота
		print(row_str)

# Вызывается при старте сцены
func _ready():
	randomize()  # Инициализация генератора случайных чисел
	var width = 100         # Ширина уровня
	var height = 100      # Высота уровня
	var border_width = 1    # Толщина рамки
	var wall_density = 0.4  # Плотность внутренних стен (20%)
	
	# Генерируем уровень
	var level = generate_level(width, height, border_width, wall_density)
	print_level(level)
	
	# Создаем стены на основе сгенерированного уровня
	create_walls_from_level(level)
