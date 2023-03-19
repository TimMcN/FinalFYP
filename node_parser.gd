extends Node

class node_loader:
	var DEFAULT setget set_default, get_default
	var CUSTOM setget set_custom, get_custom
	var ALL setget set_all, get_all
		
	func get_default():
		return DEFAULT
	func set_default(val):
		print ("Default List Updated")
		DEFAULT = val
	func get_custom():
		return CUSTOM
	func set_custom(val):
		print ("Custom List Updated")
		CUSTOM = val
	func get_all():
		return ALL
	func set_all(val):
		print("All List updated")
		ALL = val
		
	
	class salsa extends node_loader:
		func _ready():
			set_default(file_reader.load_file("res://dances/salsa_default.txt"))
			print("DEFAULT")
			pass
