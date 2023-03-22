class_name persistent_data extends Node
var file_reader = load("res://file_loader.gd")
var DANCE_PATTERNS:Dictionary = {}
var deltaTime
func _ready():
	var info = (file_reader.load_file("res://dances/salsa_default_dance_nodes.txt"))
	var new = info.split("\n")
	print("Lines")
	deltaTime=0
	populate_dict(new)

	#print_pattern()	
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
		#print(val)
		##print(key)
		self.DANCE_PATTERNS[key] = val
		
func print_pattern():
	print(self.DANCE_PATTERNS.get("salsa_basic"))
	print(self.DANCE_PATTERNS.get("salsa_sidestep"))

func get_dance_pattern(pattern:String):
	return self.DANCE_PATTERNS.get(pattern)

func get_dance_steps():
	var steplist = DANCE_PATTERNS.get("salsa_basic")
	print("SINGLETON: ", steplist)
