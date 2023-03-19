extends Area

var material = SpatialMaterial.new()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var index =0
# Called when the node enters the scene tree for the first time.
func _ready():
	material.albedo_color = Color(0, 1, 0)
	pass # Replace with function body.
var deltasum = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	deltasum += delta	
	if deltasum>0.005:
		index +=1
		for body in self.get_overlapping_bodies():
			print(str(index), " ", body.name)
			for child in body.get_children():
				for grandchild in child.get_children():
					if grandchild.name == "CubeMeshL":
						grandchild.set_surface_material(0, material)		
			#print(body)
			deltasum=0
	
