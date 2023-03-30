extends Node

var step_array:Array
var dance_pattern
var index=0
var t_i=0
var current_step
var step_completed=0
var score = 0
var step_count = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	load_dance_pattern()
func load_dance_pattern():
	var pattern_manager = get_node("/root/Singleton")
	print("Pattern Manager OBJ loaded: ", pattern_manager)
	self.dance_pattern = pattern_manager.get_dance_pattern(self.name)
	var step_pool = self.dance_pattern.split(";")
	for step in step_pool:
		self.step_array.append(step)
		step_count+=1
	print("Step Array Loaded: ", step_array)
	current_step = DanceStep.new(step_array.pop_front(), self.translation)
	current_step.connect("step_callback", self, "step_complete", [current_step])
	self.add_child(current_step)
func step_complete(step:DanceStep):
	print ("=============================")
	print("Step Complete: ", step.StepString, " step_completed: ", step_completed)
	self.score+= step.score
	self.step_completed +=1
	step.queue_free()
	next_step()
func next_step():
	print("Next Step")
	var next_step_def= step_array.pop_front()
	if next_step_def != null:
		t_i += 1
		print(next_step_def, t_i)
		current_step = DanceStep.new(next_step_def, self.translation)
		current_step.connect("step_callback", self, "step_complete", [current_step])
		self.add_child(current_step)
	else:
		print("=============== FINAL SCORE ================")
		print(self.score/self.step_completed+1)
		print("============================================")
		load_dance_pattern()

class DanceStep extends Node:
	var nodes:Array
	signal step_callback
	var node_count
	var node_returned=0
	var StepString:String
	var DanceStep:Array
	var score_accum=0
	var score
	func parse_node(DanceNodeDef:String):
		var a = DanceNodeDef.split(" ")
		var dance_definition:Array = []
		for node in a:
			dance_definition.push_back(node)
		return dance_definition
	func _init(DanceStep:String, parent_location:Vector3):
		self.node_count = 0
		print("Dance Step Instantiated", self)
		var DanceNodeArray = DanceStep.split(',')
		for node_def in DanceNodeArray:
			var node_def_arr = parse_node(node_def)
			var node_obj
			match node_def_arr[0]:	
				"LearnDance": 
					node_obj = LearnDance.new(node_def_arr, parent_location)
				"TimedDance": 
					node_obj = TimedDance.new(node_def_arr, parent_location)
			node_count +=1
			node_obj.connect("node_callback", self, "score", [node_obj])
			self.nodes.append(node_obj)
			self.add_child(node_obj)
			print("Dance Node Added to Node Array in Step ", node_obj)
	func score(node:DanceNode):
		self.score_accum += node.score
		self.node_returned +=1
		print("NODE COUNT: ", self.node_count, " NODES RETURNED: ", self.node_returned)
		if (self.node_returned == self.node_count):
			self.score = self.score_accum/self.node_count
			print("NODE LEVEL SCORE: ", self.score)
			print("EMITTING STEP CALLBACK")
			emit_signal("step_callback")
		print("NODE CALLBACK")
	func _ready():
		pass
		
		
class DanceNode extends Spatial:
	var node
	var type:String
	var score
	signal node_callback
	var dance_definition:Array
	var parenet_location
	
	func _init(DanceNodeDef:Array, parent_location:Vector3):
		type = "Virtual Dance Node"
		self.dance_definition = DanceNodeDef
		self.parent_location = parent_location
		pass
	func setColour(state=null):
		pass
	func setScore():
		pass
	func test_signal():
		self.score = 3.14
		emit_signal("node_callback")
		print ("Signal from class type,  ", type)


class TimedDance extends DanceNode:
	enum {NODE_TYPE, NODE_TRACKER, NODE_X, NODE_Y, NODE_Z, TARGET_TIME}
	var area:Area
	var relative_transform
	var index=1
	var state_c = true
	var elapsedTime = 0.0001

	func _init (DanceNodeDef:Array, parent_location:Vector3).(DanceNodeDef, parent_location):
		self.type = "TimedDance"
		print("Dance Node Instantiated, TimedDance, No Timing in score, waits for user: ", self)
		assert (dance_definition[NODE_TYPE] == self.type)
		assert (len(dance_definition) == 6)
		self.dance_definition = DanceNodeDef

	func _ready():
		self.area = create_node()
		self.get_po
		self.add_child(self.area)
	
	func create_node(area_name:String = "default_name", location:Vector3 = Vector3(0, 1, 0)):
		print("Generating Node: ", dance_definition)
		location = self.parent_location + Vector3(self.dance_definition[NODE_X],self.dance_definition[NODE_Y],self.dance_definition[NODE_Z])
		var area = Area.new()
		area.name = area_name
		area.connect("body_entered", self, "check_controller", [area])
		
		var dance_mesh = MeshInstance.new()
		area.add_child(dance_mesh)
		dance_mesh.owner = area
		dance_mesh.name = "Dance_Mesh"
		
		var mesh = CubeMesh.new()
		mesh.size = Vector3(0.25, 0.025, 0.25)
		dance_mesh.mesh = mesh
		
		var dance_mesh_collision = CollisionShape.new()
		area.add_child(dance_mesh_collision)
		dance_mesh_collision.owner = area
		
		var dance_mesh_collision_shape = BoxShape.new()
		dance_mesh_collision_shape.extents = Vector3(0.125, 0.025, 0.125)
		dance_mesh_collision.shape = dance_mesh_collision_shape
		
		area.transform.origin += location
		return area
		
	func check_controller(body, area):
		print ("===============================")
		print ("")
		print(body.name)
		print(area.name)
		if body.name == self.dance_definition[NODE_TRACKER]:
			if float(dance_definition[TARGET_TIME]) > elapsedTime:
				self.score = ((elapsedTime/float(dance_definition[TARGET_TIME])) *100)
			else:
				self.score = 1-((elapsedTime-float(dance_definition[TARGET_TIME]) / float(dance_definition[TARGET_TIME])) * 100)
			emit_signal("node_callback")
		print ("")
		print("================================")
		area.get_parent().remove_child(self)
		
	func _process(delta):
		index += 1
		self.elapsedTime+=delta
		if self.elapsedTime > float(self.dance_definition[TARGET_TIME])*1.75:
			self.score = 0
			emit_signal("node_callback")
		setColour()
	
	func setColour(state=null):
		area = self.area
		var material = SpatialMaterial.new()
		if state == "reset":
			state_c = true
		if state_c == true:
			var max_hue:float = 8.0/36.0
			var hue = (self.elapsedTime  / float(self.dance_definition[TARGET_TIME])) * max_hue
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
		elif state == "success": 
			material.albedo_color = Color(0,0,1)
			state_c = false
			area.get_child(0).set_surface_material(0, material)
	func moveMesh(change_in_location: Vector3 = Vector3(0,0,0)):	
		var node = self.area
		node.global_transform.origin = node.global_transform.origin + change_in_location
		node.global_transform.origin = node.global_transform.origin + change_in_location
	func _input(ev):
		if ev is InputEventKey and ev.scancode == KEY_SPACE and not ev.echo:
				self.moveMesh(Vector3(0.05, 0, 0.05))
		if ev is InputEventKey and ev.scancode == KEY_0 and not ev.echo:
			setColour("goal")
		if ev is InputEventKey and ev.scancode == KEY_1 and not ev.echo:
			setColour("fail")
		if ev is InputEventKey and ev.scancode == KEY_2 and not ev.echo:
			setColour("success")
		if ev is InputEventKey and ev.scancode == KEY_3 and not ev.echo:
			setColour("reset")
			self.score = 100
			self.area.get_parent().queue_free()
			emit_signal("node_callback")


class LearnDance extends DanceNode:
	enum {NODE_TYPE, NODE_TRACKER, NODE_X, NODE_Y, NODE_Z}
	var area:Area
	var index=1
	var state_c
	var parent_location
	func _init (DanceNodeDef:Array, parent_location:Vector3).(DanceNodeDef, parent_location):
		self.type = "LearnDance"
		print("Dance Node Instantiated, LearnDance, No Timing in score, waits for user: ", self)
		self.dance_definition=DanceNodeDef
		assert (dance_definition[NODE_TYPE] == type)
		
	
	func _ready():
		self.area = create_node()
		self.add_child(self.area)
	
	func create_node(area_name:String = "area", location:Vector3 = Vector3(0, 1, 0)):
		print("Generating Node: ", dance_definition)
		location = Vector3(self.dance_definition[NODE_X],self.dance_definition[NODE_Y],self.dance_definition[NODE_Z])
		var area = Area.new()
		area.name = area_name
		area.connect("body_entered", self, "check_controller", [area])
		
		var dance_mesh = MeshInstance.new()
		area.add_child(dance_mesh)
		dance_mesh.owner = area
		dance_mesh.name = "Dance_Mesh"
		
		var mesh = CubeMesh.new()
		mesh.size = Vector3(0.25, 0.025, 0.25)
		dance_mesh.mesh = mesh
		
		var dance_mesh_collision = CollisionShape.new()
		area.add_child(dance_mesh_collision)
		dance_mesh_collision.owner = area
		
		var dance_mesh_collision_shape = BoxShape.new()
		dance_mesh_collision_shape.extents = Vector3(0.125, 0.025, 0.125)
		dance_mesh_collision.shape = dance_mesh_collision_shape
		area.transform.origin = (self.parent_location + location)
		return area
		
	func check_controller(body, area):
		print ("===============================")
		print ("")
		print(body.name)
		print(area.name)
		if body.name == self.dance_definition[NODE_TRACKER]:
			self.score = 100
			emit_signal("node_callback")
		print ("")
		print("================================")
		area.get_parent().remove_child(self)
		
	
	func setColour(state=null):
		area = self.area
		var material = SpatialMaterial.new()
		if state == "goal":
			material.albedo_color = Color(1, .5, .2)
			state_c = false
			area.get_child(0).set_surface_material(0, material)
		elif state == "fail":
			material.albedo_color = Color(1, 0, 0)
			state_c = false
			area.get_child(0).set_surface_material(0, material)
		elif state == "success":
			material.albedo_color = Color(0,0,1)
			state_c = false
			area.get_child(0).set_surface_material(0, material)
	func moveMesh(change_in_location: Vector3 = Vector3(0,0,0)):	
		var node = self.area
		node.global_transform.origin = node.global_transform.origin + change_in_location
		node.global_transform.origin = node.global_transform.origin + change_in_location
	func _input(ev):
		if ev is InputEventKey and ev.scancode == KEY_SPACE and not ev.echo:
				self.moveMesh(Vector3(0.05, 0, 0.05))
		if ev is InputEventKey and ev.scancode == KEY_0 and not ev.echo:
			setColour("goal")
		if ev is InputEventKey and ev.scancode == KEY_1 and not ev.echo:
			setColour("fail")
		if ev is InputEventKey and ev.scancode == KEY_2 and not ev.echo:
			setColour("success")
		if ev is InputEventKey and ev.scancode == KEY_3 and not ev.echo:
			setColour("reset")
			self.score = 100
			self.area.get_parent().queue_free()
			emit_signal("node_callback")
			
class DanceRecorder extends Node:
	var location:Vector3
	var new_location
	var difference
	var differences:Array
	var tracked_nodes:Array
	func _ready():
		var tracked_node1 = tracked_node.new("FPController/LeftHandController/Left_Kinematic")
		self.add_child(tracked_node1)
	func _process(delta):
		pass
	func _input(event):
		if event is InputEventKey and event.scancode == KEY_Q and not event.echo:
			pass
	func store_movement():
		pass
class tracked_node extends Node:
	var start_location:Vector3
	var accumulated_location:Vector3
	var last_location:Vector3
	var difference_in_location:Vector3
	var controller_r
	var controller_npath:String
	func _init(c:String):
		self.controller_npath = c
	func _ready():
		controller_r = get_parent().get_parent().get_parent().get_node(self.controller_npath)
		print(controller_r)
		start_location = controller_r.global_transform.origin
	
