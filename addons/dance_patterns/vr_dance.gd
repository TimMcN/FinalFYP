tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("Dance Pattern", "Spatial", preload("dance_pattern.gd"), preload("mu_icon.png"))
	
func _exit_tree():
	pass
