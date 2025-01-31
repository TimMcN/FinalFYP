class_name persistent_data extends Node
var file_reader = load("res://file_loader.gd")
var DANCE_PATTERNS:Dictionary = {}
var deltaTime
func _ready():
	var info = (file_reader.load_file("res://addons/dance_patterns/dances/default_dance_nodes.txt"))
	var new = info.split("\n")
	print("Lines")
	deltaTime=0
	populate_dict(new)
func _process(delta):
	deltaTime += delta
func populate_dict(file):
	for line in file:
		var t = line.split(':')
		var n = []
		for val in t:
			n.append(val)
		var key = n.pop_front()
		var val = n.pop_front()
		self.DANCE_PATTERNS[key] = val
		
func print_pattern(pattern_name:String):
	print(self.DANCE_PATTERNS.get(pattern_name))

func get_dance_pattern(pattern_name:String):
	return self.DANCE_PATTERNS.get(pattern_name)

