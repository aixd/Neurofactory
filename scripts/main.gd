extends Node2D

var adderNeuron = preload("res://scenes/adderNeuron.tscn")
var inhibitoryNeuron = preload("res://scenes/inhibitoryNeuron.tscn")
var inhibitoryNeuron2 = preload("res://scenes/inhibitoryNeuron2.tscn")
var input = preload("res://scenes/input.tscn")
#var input2 = null
#var input3 = null
var output = preload("res://scenes/output.tscn")
#var output2 = preload("res://scenes/output.tscn")
#var output3 = preload("res://scenes/output.tscn")
var negation = preload("res://scenes/negation.tscn")
var threshold = preload("res://scenes/threshold.tscn")
var delay = preload("res://scenes/delay.tscn")
var constant = preload("res://scenes/constant.tscn")
@onready var stepCounter = $StepCounter
@onready var graph = $GraphEdit
@onready var cost = $Cost
@onready var test = $Test
#@onready var curList = []
#@onready var preList = []
#var Global.steps = 0

#var output_counter = 0
@onready var connection_list = [] #图的关系
@onready var node_list = [] #所有的点集合
#@onready var lines = []
# Called when the node enters the scene tree for the first time.


@onready var file_dialog = $FileDialog
@onready var level_description = $Description
@onready var select_test = $SelectTest

var max_order = 1

@onready var input_lines1 = $Input
@onready var input_lines2 = $Input2
@onready var input_lines3 = $Input3

@onready var actual_output_line1 = $ActualOutput
@onready var actual_output_line2 = $ActualOutput2
@onready var actual_output_line3 = $ActualOutput3

@onready var expected_output_line1 = $ExpectedOutput
@onready var expected_output_line2 = $ExpectedOutput2
@onready var expected_output_line3 = $ExpectedOutput3



#@onready var expected_output_lines



func _ready():
	Global.input_counter = 0
	Global.output_counter = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func createConstant():
	var newConstant = constant.instantiate()
	graph.add_child(newConstant)
	update_cost() 

func createDelay():
	var newDelay = delay.instantiate()
	graph.add_child(newDelay)
	update_cost() 
func createAdderNeuron():
	var newAdderNeuron = adderNeuron.instantiate()
	graph.add_child(newAdderNeuron)
	update_cost() 
	pass # Replace with function body.
	
func createInhibitoryNeuron():
	var newInhibitoryNeuron = inhibitoryNeuron.instantiate()
	graph.add_child(newInhibitoryNeuron)
	update_cost() 
	pass # Replace with function body.
	
func createInhibitoryNeuron2():
	var newInhibitoryNeuron2 = inhibitoryNeuron2.instantiate()
	graph.add_child(newInhibitoryNeuron2)
	update_cost() 
	pass
func createNegation():
	var newNegation = negation.instantiate()
	graph.add_child(newNegation)
	update_cost() 

func createThreshold():
	var newThreshold = threshold.instantiate()
	graph.add_child(newThreshold)
	update_cost() 

func createInput():
	
	#Global.input_counter += 1
	#if Global.input_counter <=3:
		#var newInput = input.instantiate()
		#graph.add_child(newInput)
		#if Global.input_counter > 1:
			#newInput.title = "Input" + str(Global.input_counter
			#)
			#newInput.name = "Input" + str(Global.input_counter
			#)
	#else:
		#Global.input_counter = 3
		
	
	if Global.input_counter < 1:
		Global.input_counter += 1	
		var newInput = input.instantiate()
		graph.add_child(newInput)
		update_cost() 
		
	pass # Replace with function body. 
	
func createOutput():
	#Global.output_counter += 1
	#
	#if Global.output_counter <=3:
		#
		#var newOutput = output.instantiate()
		#graph.add_child(newOutput)
		#if Global.output_counter > 1:
			#newOutput.title = "Output" + str(Global.output_counter
			#)
			#newOutput.name = "Output" + str(Global.output_counter
			#)
	#else:
		#Global.output_counter=3
	if Global.output_counter < 1:
		Global.output_counter += 1	
		var newOutput = output.instantiate()
		graph.add_child(newOutput)
		update_cost() 
	
	pass # Replace with function body.

func _on_graph_edit_connection_request(from_node, from_port, to_node, to_port):
	#print(typeof(from_node))
	var FROM_NODE = graph.get_node(str(from_node))
	var TO_NODE = graph.get_node(str(to_node))
	
	#var from_node_output_port_count = FROM_NODE.get_output_port_count()
	#var to_node_input_port_count = TO_NODE.get_output_port_count()
	##var can_be_connnected = true
	#
	#for i in range(from_node_output_port_count):
		#if graph.is_node_connected(from_node,i,to_node,to_port):
			#return
	#这下每个输入端口只能接一条线，但不影响输出端口拉多条线
	
	var connection_list_ = graph.get_connection_list()
	for connection in connection_list_:
		if connection["to_port"]==to_port and connection["to_node"]==to_node:
			return
	#这下每个输入端口只能接一条线，但不影响输出端口拉多条线
	
	
	
	
	
	if FROM_NODE.type == Global.Type.INPUT:
		if TO_NODE.type == Global.Type.NEGATION or TO_NODE.type == Global.Type.THRESHOLD or TO_NODE.type == Global.Type.DELAY:
			return
	if FROM_NODE.type == Global.Type.INHIBITORY or FROM_NODE.type == Global.Type.INHIBITORY2:
		if TO_NODE.type == Global.Type.NEGATION or TO_NODE.type == Global.Type.THRESHOLD:
			return
	if TO_NODE.type == Global.Type.OUTPUT:
		if FROM_NODE.type == Global.Type.INHIBITORY or FROM_NODE.type == Global.Type.INHIBITORY2:#限定output前面不能是抑制系神经元
			return
	
	
	
	graph.connect_node(from_node, from_port, to_node, to_port)
	pass # Replace with function body.


func update_cost():
	Global.cost += 1
	cost.text = "Cost:" + str(Global.cost)


func _on_graph_edit_disconnection_request(from_node, from_port, to_node, to_port):
	graph.disconnect_node(from_node, from_port, to_node, to_port)
	pass # Replace with function body.

func Debug():
	print(null)
	
func Step():
	#print(null) 即使是null也会被打印出来
	#print() 只有括号里面什么都不加才一点都不显示
	if Global.steps == 0:
		input = graph.get_node("Input")
		#input2 = graph.get_node("Input2") #没找到就会返回null
		#input3 = graph.get_node("Input3")
		#这三个input是位于graphedit的子节点，不是main的子节点
		connection_list = graph.get_connection_list()
		#print(connection_list)
		for child in graph.get_children():
			if child is GraphNode:
				node_list.append(child)
		
				
		for node in node_list:
			if node.type != Global.Type.INPUT:
				for connection in connection_list:
					if connection["to_node"] == node.name:
						#print(typeof(connection["from_port"])) #这个connection["from_port"]返回的确实是int类型 
						node.input_node_lists.append([graph.get_node(str(connection["from_node"])),connection["from_port"],connection["to_port"]])#感觉是最重要的一步
						
						if !node.is_neuron:
							node.pre_node = graph.get_node(str(connection["from_node"]))
							print("Debug is_neuron")
						
						
					#if connection["from_node"] == node.name and !node.is_neuron:
						#node.next_node = graph.get_node(str(connection["to_node"]))
						
		for node in node_list:
			if !node.is_neuron:
				var cur_node = node
				var pre_node = node.pre_node
				while(pre_node and !pre_node.is_neuron):
					node.order += 1
					cur_node = pre_node
					pre_node = cur_node.pre_node
					
				print(node.order)
				if node.order>max_order:
					max_order = node.order
					
					
					
					
				
		# print(node_list)
		
		
		
		
		if input !=null:
			input_lines1 = $Input
			input_lines2 = $Input2
			input_lines3 = $Input3
			var line_count1 = input_lines1.get_line_count()
			var line_count2 = input_lines2.get_line_count()
			var line_count3 = input_lines3.get_line_count()
			
			for i in range(line_count1):  # 遍历所有行
				var line = input_lines1.get_line(i)  # 获取每行文本
				input.input_lines1.append(line)  # 将文本添加到数组中
			for i in range(line_count2):  # 遍历所有行
				var line = input_lines2.get_line(i)  # 获取每行文本
				input.input_lines2.append(line)
			for i in range(line_count3):  # 遍历所有行
				var line = input_lines3.get_line(i)  # 获取每行文本
				input.input_lines3.append(line)	
				
			input.GetInput(Global.steps)
		
		
		
		
		
		
		
		
		
		
			
		#if input2 !=null:
			#var input_lines2 = $Input2
			#var line_count2 = input_lines2.get_line_count()
			#for i in range(line_count2):  # 遍历所有行
				#var line = input_lines2.get_line(i)  # 获取每行文本
				#input2.input_lines.append(line)  # 将文本添加到数组中
			#input2.GetInput(Global.steps)
			#
		#if input3 !=null:
			#var input_lines3 = $Input3
			#var line_count3 = input_lines3.get_line_count()
			#for i in range(line_count3):  # 遍历所有行
				#var line = input_lines3.get_line(i)  # 获取每行文本
				#input3.input_lines.append(line)  # 将文本添加到数组中
			#input3.GetInput(Global.steps)
		for i in range(1,max_order+1):
			for node in node_list:
				if !node.is_neuron and node.order ==i and node.type == Global.Type.DELAY:
					node.Update()
		
		
		for node in node_list:
			if node.type == Global.Type.CONSTANT:
				node.Act()
				#只用执行一次就够了吧
		
		#input.get_node("Data").text = lines[Global.steps]
		$StepCounter.text = "Steps:" + str(Global.steps)
		Global.steps +=1
		
		
	elif Global.steps !=0:
		#input.get_node("Data").text = lines[Global.steps]
		
		#for node in node_list:
			#if node.is_neuron:
				#node.Update()
		#
		#for i in range(1,max_order+1):
			#for node in node_list:
				#if !node.is_neuron and node.order ==i:
					#node.Update()
					
		for node in node_list:
			node.Update()
					
		
		
		
			
		for node in node_list:
			if node.type == Global.Type.INPUT:
				node.GetInput(Global.steps)
			elif node.type == Global.Type.ADDER:
				node.Act()
			elif node.type == Global.Type.INHIBITORY or node.type == Global.Type.INHIBITORY2:
				node.Act()
			#elif node.type == Global.Type.CONSTANT:
				#node.Act()
			elif node.type == Global.Type.OUTPUT:
				node.Act()
				#print(node.cache)
				#if node.cur_states[0] == Global.State.ACTIVATE:
					#
					#if node.name == "Output":
						#$Output.insert_line_at($Output.get_line_count()-1,node.cur_datas[0])
					#if node.name == "Output2":
						#$Output2.insert_line_at($Output2.get_line_count()-1,node.cur_datas[0])
					#if node.name == "Output3":
						#$Output3.insert_line_at($Output3.get_line_count()-1,node.cur_datas[0])	
				#elif node.cur_states[0] == Global.State.INACTIVATE:
					#print(true)
					#if node.name == "Output":
						#$Output.insert_line_at($Output.get_line_count()-1,"v")
					#if node.name == "Output2":
						#$Output2.insert_line_at($Output2.get_line_count()-1,"v")
					#if node.name == "Output3":
						#$Output3.insert_line_at($Output3.get_line_count()-1,"v")	
						##print(node.cur_data)
				#var output_lines1 = $Output
				#var output_lines2 = $Output2
				#var output_lines3 = $Output3
				var output_lines_list = [actual_output_line1,actual_output_line2,actual_output_line3]
				for i in range(3):
					if node.cur_states[i] == Global.State.ACTIVATE:
						output_lines_list[i].insert_line_at(output_lines_list[i].get_line_count()-1,node.cur_datas[i])
					else:
						if Global.current_v_mode == Global.VMode.SHOW:
							output_lines_list[i].insert_line_at(output_lines_list[i].get_line_count()-1,"v")
				
				
				
				
				
				
				
				
				
					
		#for node in node_list:#专门为髓鞘安排的遍历
			#if node.type == Global.Type.NEGATION or node.type == Global.Type.THRESHOLD or node.type == Global.Type.DELAY:
				#node.Act()
				
		for i in range(1,max_order+1):
			for node in node_list:
				if !node.is_neuron and node.order ==i:
					node.Act()
					
		
		
		
		$StepCounter.text = "Steps:" + str(Global.steps)
		Global.steps +=1
	pass
	
func Reload():
	get_tree().reload_current_scene()
	
	#print(input)
	#print(list)

func ResetAll():
	for node in node_list:
		#node.Reset()
		node and node.Reset()
		#node ? node.Reset() : null
		#node?.Reset()
	
	Global.steps = 0
	
	$StepCounter.text = "Steps:"
	
	actual_output_line1.clear()
	actual_output_line2.clear()
	actual_output_line3.clear()
	#Global.input_counter = 0
	#Global.output_counter = 0
	connection_list.clear()
	node_list.clear()


func _on_choose_level_pressed():
	file_dialog.popup()
	pass # Replace with function body.






func _on_file_dialog_file_selected(path):
	var config = ConfigFile.new()
	config.set_value("CurrentLevelPath","current_level_path",path)
	config.save("user://CurrentLevelPath.cfg")
	read_level()
	#var file = FileAccess.open(path, FileAccess.READ)
	#var content = file.get_as_text()
	#var lines = content.split("\n")
	#level_description.text = "{0}\n{1}\n".format([lines[0],lines[1]],"{_}")
	#test.text = "test:{0}/{1}".format([Global.current_test_index,lines[3]],"{_}")
	
	#var i1 = lines[2].split(",")
	#var i2 = lines[3].split(",")
	#var i3 = lines[4].split(",")
	
	#var e1 = lines[5].split(",")
	#var e2 = lines[6].split(",")
	#var e3 = lines[7].split(",")
	#for i in range(i1.size()):
		#input_lines1.insert_line_at(i,i1[i])
	#for i in range(i2.size()):
		#input_lines2.insert_line_at(i,i2[i])
	#for i in range(i3.size()):
		#input_lines3.insert_line_at(i,i3[i])	
	#
	#
	#for i in range(e1.size()):
		#expected_output_line1.insert_line_at(i,e1[i])
	#for i in range(e2.size()):
		#expected_output_line2.insert_line_at(i,e2[i])
	#for i in range(e3.size()):
		#expected_output_line3.insert_line_at(i,e3[i])
#
	
	

	pass # Replace with function body.




func read_level():
	input_lines1.clear()
	input_lines2.clear()
	input_lines3.clear()
	expected_output_line1.clear()
	expected_output_line2.clear()
	expected_output_line3.clear()
	
	var config =  ConfigFile.new()
	config.load("user://CurrentLevelPath.cfg")
	var path = config.get_value("CurrentLevelPath","current_level_path")
	
	
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	var lines = content.split("\n")
	level_description.text = "{0}\n{1}\n".format([lines[0],lines[1]],"{_}")
	test.text = "test:{0}/{1}".format([Global.current_test_index,lines[3]],"{_}")
	select_test.max_value = int(lines[3])
	
	var i1 = lines[5+(Global.current_test_index-1)*7].split(",")
	var i2 = lines[6+(Global.current_test_index-1)*7].split(",")
	var i3 = lines[7+(Global.current_test_index-1)*7].split(",")
	
	var e1 = lines[8+(Global.current_test_index-1)*7].split(",")
	var e2 = lines[9+(Global.current_test_index-1)*7].split(",")
	var e3 = lines[10+(Global.current_test_index-1)*7].split(",")
	
	
	for i in range(i1.size()):
		input_lines1.insert_line_at(i,i1[i])
	for i in range(i2.size()):
		input_lines2.insert_line_at(i,i2[i])
	for i in range(i3.size()):
		input_lines3.insert_line_at(i,i3[i])	
	
	
	for i in range(e1.size()):
		expected_output_line1.insert_line_at(i,e1[i])
	for i in range(e2.size()):
		expected_output_line2.insert_line_at(i,e2[i])
	for i in range(e3.size()):
		expected_output_line3.insert_line_at(i,e3[i])
	
	
	
	#print(path)
	
	pass










func _on_change_v_mode_pressed():
	if Global.current_v_mode == Global.VMode.SHOW:
		Global.current_v_mode = Global.VMode.HIDE
	else:
		Global.current_v_mode = Global.VMode.SHOW
	var config = ConfigFile.new()
	config.set_value("VMode","current_v_mode",Global.current_v_mode)
	config.save("user://VMode.cfg")
	
	pass # Replace with function body.


func _on_select_test_value_changed(value):
	Global.current_test_index = value
	read_level()
	pass # Replace with function body.
