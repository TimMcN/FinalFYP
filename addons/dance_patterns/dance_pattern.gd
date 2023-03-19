extends Node

var collision_obj
var overlapbody
var nodes:Array
var index=0
var deltaTime=0.001
var state_c = true
#Seconds Per Beat
var spb = 3
#Threshold multiplier for acceptance
var threshold = 0.8
# Called when the node enters the scene tree for the first time.
func _ready():
	nodes.append(create_node())
	"""areaL = Area.new()
	areaL.name = "Area Trigger Left"
	areaL.connect("body_entered", self, "check_controller")
	
	dance_l_mesh = MeshInstance.new()
	areaL.add_child(dance_l_mesh)
	dance_l_mesh.owner = areaL
	dance_l_mesh.name = "Dance_L_Mesh"
	
	var mesh = CubeMesh.new()
	mesh.size = Vector3(0.25, 0.025, 0.25)
	dance_l_mesh.mesh = mesh
	
	var dance_l_mesh_collision = CollisionShape.new()
	areaL.add_child(dance_l_mesh_collision)
	dance_l_mesh_collision.owner = areaL
	dance_l_mesh_collision.name = "dance_l_mesh_collision"
	
	var dance_l_mesh_collision_shape = BoxShape.new()
	dance_l_mesh_collision_shape.extents = Vector3(0.25, 0.025, 0.2)
	dance_l_mesh_collision.shape = dance_l_mesh_collision_shape
	
	areaL.transform.origin = Vector3(0.25, 1, 0.25)
	add_child(areaL)
	"""
func _process(delta):
	deltaTime+=delta
	index += 1
	if deltaTime > spb:
		deltaTime=0.001
	setColour()

func _input(ev):
	if ev is InputEventKey and ev.scancode == KEY_SPACE and not ev.echo:
		for node in nodes:
			moveMesh(Vector3(0.05, 0, 0.05), node)
	if ev is InputEventKey and ev.scancode == KEY_0 and not ev.echo:
		setColourAll("goal")
	if ev is InputEventKey and ev.scancode == KEY_1 and not ev.echo:
		setColourAll("fail")
	if ev is InputEventKey and ev.scancode == KEY_2 and not ev.echo:
		setColourAll("success")
	if ev is InputEventKey and ev.scancode == KEY_3 and not ev.echo:
		setColourAll("reset")
func setColourAll(state=null):
	for node in nodes:
		setColour("", node)
		
func setColour(state=null, area:Area=null):
	var material = SpatialMaterial.new()
	if state == "reset":
		state_c = true
	if state_c == true:
		var max_hue:float = 8.0/36.0
		var hue = (deltaTime / spb) * max_hue
		#print("DeltaTime = " + str(deltaTime) + " SPB = " + str(spb) + " MaxHue: " + str(max_hue) + " Current Hue: " + str(hue))
		material.albedo_color = Color.from_hsv(hue, 1, 1, 1)
		area.get_child(0).set_surface_material(0, material)

	if state == "goal":
		material.albedo_color = Color(1, .5, .2)
		state_c = false
		area.get_child(0).set_surface_material(0, material)
	elif state == "fail":
		material.albedo_color = Color(1, 0, 0)
		state_c = false
		area.get_child(0).set_surface_material(0, material)
	elif state == "success": # && deltaTime > spb * threshold:
		print ("deltaTime: " + str(deltaTime) + " spb: " + str(spb) + " spb*threshold: " + str(spb*threshold))
		material.albedo_color = Color(0,0,1)
		state_c = false
		area.get_child(0).set_surface_material(0, material)
		
func create_node(location:Vector3 = Vector3(0, 1, 0)):
	var areaL = Area.new()
	areaL.name = "Area Trigger Left"
	areaL.connect("body_entered", self, "check_controller")
	
	var dance_l_mesh = MeshInstance.new()
	areaL.add_child(dance_l_mesh)
	dance_l_mesh.owner = areaL
	dance_l_mesh.name = "Dance_L_Mesh"
	
	var mesh = CubeMesh.new()
	mesh.size = Vector3(0.25, 0.025, 0.25)
	dance_l_mesh.mesh = mesh
	
	var dance_l_mesh_collision = CollisionShape.new()
	areaL.add_child(dance_l_mesh_collision)
	dance_l_mesh_collision.owner = areaL
	dance_l_mesh_collision.name = "dance_l_mesh_collision"
	
	var dance_l_mesh_collision_shape = BoxShape.new()
	dance_l_mesh_collision_shape.extents = Vector3(0.25, 0.025, 0.2)
	dance_l_mesh_collision.shape = dance_l_mesh_collision_shape
	
	areaL.transform.origin = location
	add_child(areaL)
	return areaL
	
func check_controller(body):
	print(body.name)
	
func moveMesh(change_in_location:Vector3 = Vector3(0,0,0), node:Area =null):	
	node.global_transform.origin = node.global_transform.origin + change_in_location
	node.global_transform.origin = node.global_transform.origin + change_in_location

