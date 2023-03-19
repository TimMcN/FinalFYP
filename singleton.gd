class_name cm extends Node

var file_reader = load("res://file_loader.gd")
var node_steps = load("node_parser.gd")

func _ready():
	print(file_reader.load_file("res://dances.txt"))
	
	
