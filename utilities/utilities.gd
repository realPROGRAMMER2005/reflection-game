extends Node2D



func load_scenes_from_folder(folder_path: String) -> Array:
	var scenes: Array = []
	
	var dir = DirAccess.open(folder_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and (file_name.ends_with(".tscn") or file_name.ends_with(".scn")):
				var scene = load(folder_path + file_name)
				scenes.append(scene)
			file_name = dir.get_next()
	else:
		print("Ошибка: не удалось открыть папку ", folder_path)
	
	return scenes
