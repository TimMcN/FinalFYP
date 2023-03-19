class_name persistent_data extends Node

var file_reader = load("res://file_loader.gd")
var dance_patterns = {}

func _ready():
	var info = (file_reader.load_file("res://dances/salsa_default_dance_nodes.txt"))
	var new = info.split("\n")
	print("Lines")
	var dance_patterns = {}
	for line in new:
		var t = line.split(':')
		var n = []
		for val in t:
			n.append(val)
		var val = n.pop_back()
		var key = n.pop_back()
		dance_patterns[key] = val
	print(dance_patterns)
	print ("=================")
	print(dance_patterns.get("salsa_basic"))
