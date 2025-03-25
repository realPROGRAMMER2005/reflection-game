extends Node2D

var level: Level

func _ready() -> void:
	init_level()

func init_level():
	find_node_by_class_name(self, Level)

func get_level():
	return level


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
