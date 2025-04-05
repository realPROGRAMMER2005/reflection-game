extends Node2D






func load_scene_tree(path: String) -> Variant:
	var dir: DirAccess = DirAccess.open(path)
	if dir == null:
		push_error("Невозможно открыть директорию: " + path)
		return {}
	
	var subdirs: Dictionary = {}  # Для подпапок
	var scenes: Array = []        # Для файлов сцен
	
	# Начинаем обход содержимого директории
	dir.list_dir_begin()
	var file_name: String = dir.get_next()
	while file_name != "":
		# Пропускаем скрытые файлы и директории (начинающиеся с точки)
		if file_name.begins_with("."):
			file_name = dir.get_next()
			continue
		
		var full_path = path + "/" + file_name
		if dir.current_is_dir():
			# Рекурсивно обходим подпапку
			var subtree = load_scene_tree(full_path)
			subdirs[file_name] = subtree
		else:
			# Проверяем расширение файла. Поддерживаем .tsn и .tscn.
			var ext = file_name.get_extension().to_lower()
			if ext in ["tsn", "tscn"]:
				var scene = load(full_path)
				if scene:
					scenes.append(scene)
				else:
					push_error("Не удалось загрузить сцену: " + full_path)
		file_name = dir.get_next()
	
	dir.list_dir_end()
	
	# Если в папке одновременно есть и подпапки, и файлы сцен – считаем это ошибкой
	if subdirs.size() > 0 and scenes.size() > 0:
		push_error("Директория '" + path + "' содержит и подпапки, и файлы сцен. Это недопустимо!")
		return {}
	
	# Если есть подпапки – возвращаем словарь, иначе – массив сцен
	if subdirs.size() > 0:
		return subdirs
	else:
		return scenes


func find_nodes_by_class_name(root_node: Node, desired_class: Script) -> Array:
	var result: Array = []
	
	if root_node.get_script() == desired_class:
		result.append(root_node)
	
	for child in root_node.get_children():
		result.append_array(find_nodes_by_class_name(child, desired_class))
	
	return result

func find_node_by_class_name(root_node: Node, desired_class: Script) -> Node:
	if root_node.get_script() == desired_class:
		return root_node
	
	for child in root_node.get_children():
		var found_node = find_node_by_class_name(child, desired_class)
		if found_node:
			return found_node
	
	return null

func play_sound_2d(sound, parent_node):
	var audio_player = AudioStreamPlayer2D.new()
	audio_player.stream = sound
	audio_player.bus = "SFX"
	parent_node.add_child(audio_player)
	audio_player.play()
	audio_player.finished.connect(audio_player.queue_free)

func play_sound(sound, parent_node):
	var audio_player = AudioStreamPlayer.new()
	audio_player.stream = sound
	audio_player.bus = "SFX"
	parent_node.add_child(audio_player)
	audio_player.play()
	audio_player.finished.connect(audio_player.queue_free)
