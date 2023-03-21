extends Node
class_name file_reader

static func load_file(filepath):
	var file = File.new()
	var error = file.open(filepath, File.READ)
	if error == OK:
		print("loading file")
		var contents = file.get_as_text()
		file.close()
		return contents
	else:
		print("Failed to open file:", error)
