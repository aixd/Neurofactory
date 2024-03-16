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

@onready var file_dialog = $FileDialog
@onready var level_description = $Description
@onready var select_test = $SelectTest

@onready var input_lines = [
	$Channels/Input, 
	$Channels/Input2, 
	$Channels/Input3,
]

@onready var expected_output = [
	$Channels/ExpectedOutput, 
	$Channels/ExpectedOutput2, 
	$Channels/ExpectedOutput3,
]

@onready var actual_output = [
	$Channels/ActualOutput,
	$Channels/ActualOutput2,
	$Channels/ActualOutput3,
]

@onready var current_test_number = $TestControl/TestNumber

@onready var current_v_sensitive = $VSensitive
@onready var timer = $Timer
@onready var timer_length = $HSlider

@onready var neuron = $Buttons/Neuron
@onready var myelin = $Buttons/Myelin
#@onready var curList = []
#@onready var preList = []
#var Global.steps = 0

#var output_counter = 0
@onready var connection_list = [] #图的关系
@onready var node_list = [] #所有的点集合
#@onready var lines = []
# Called when the node enters the scene tree for the first time.

var output_counter = [0,0,0]
var judge_output_lines = [[], [], []]





var max_test_number = 1
var v_sensitive = true
var auto_run = false
var auto_pause = true


var max_order = 1




func _ready():
	Global.input_counter = 0
	Global.output_counter = 0
	
	
	Global.running_state = Global.RunningState.IDLE
	
	neuron.get_popup().id_pressed.connect(_add_neuron)
	myelin.get_popup().id_pressed.connect(_add_myelin)
	

func _add_neuron(id):
	match id:
		0:createAdderNeuron()
		1:createInhibitoryNeuron()
		2:createInhibitoryNeuron2()
		
func _add_myelin(id):
	match id:
		0:createNegation()
		1:createThreshold()
		2:createDelay()
		3:createConstant()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func createConstant():
	add_to_graph(constant.instantiate())

func createDelay():
	add_to_graph(delay.instantiate())
	
func createAdderNeuron():
	add_to_graph(adderNeuron.instantiate())
	
func createInhibitoryNeuron():
	add_to_graph(inhibitoryNeuron.instantiate())
	
func createInhibitoryNeuron2():
	add_to_graph(inhibitoryNeuron2.instantiate())

func createNegation():
	add_to_graph(negation.instantiate())

func createThreshold():
	add_to_graph(threshold.instantiate())

func createInput():
	if Global.input_counter == 0:
		Global.input_counter = 1
		add_to_graph(input.instantiate())
		
	pass # Replace with function body. 
	
func createOutput():
	if Global.output_counter == 0:
		Global.output_counter = 1
		add_to_graph(output.instantiate())
	
func add_to_graph(node):
	if Global.running_state == Global.RunningState.IDLE:
		graph.add_child(node)
		update_cost()
		
	pass


func _on_graph_edit_connection_request(from_node, from_port, to_node, to_port):
	var FROM_NODE = graph.get_node(str(from_node))
	var TO_NODE = graph.get_node(str(to_node))
	
	var connection_list_ = graph.get_connection_list()
	for connection in connection_list_:
		if connection["to_port"]==to_port and connection["to_node"]==to_node:
			return
	
	#每个输入端口只能接一条线，但不影响输出端口拉多条线
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
	
	Global.running_state = Global.RunningState.RUNNING
	
	#print(null) 即使是null也会被打印出来
	#print() 只有括号里面什么都不加才一点都不显示
	if Global.steps == 0:
		var input_node = graph.get_node("Input")
		connection_list = graph.get_connection_list()
		#print(connection_list)
		for child in graph.get_children():
			if child is GraphNode:
				node_list.append(child)
		
				
		for node in node_list:
			print(node.name)
			if node.type != Global.Type.INPUT:
				for c in connection_list:
					if c["to_node"] == node.name:
						#print(typeof(connection["from_port"])) #这个connection["from_port"]返回的确实是int类型 
						node.input_node_lists.append([graph.get_node(str(c["from_node"])),c["from_port"],c["to_port"]])#感觉是最重要的一步
						
						if !node.is_neuron:
							node.pre_node = graph.get_node(str(c["from_node"]))
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
					
					
					
					
				
		
		
		if input_node !=null:
			for i in range(3):
				for line in range(input_lines[i].get_line_count()):  # 遍历所有行
					input_node.input_lines[i].append(input_lines[i].get_line(line))
				
			input_node.GetInput(Global.steps)
		
		
		for i in range(1,max_order+1):
			for node in node_list:
				if !node.is_neuron and node.order ==i and node.type == Global.Type.DELAY:
					node.Update()
		
		
		for node in node_list:
			if node.type == Global.Type.CONSTANT:
				node.Act()
				#只用执行一次就够了吧
		
		$StepCounter.text = "Steps:" + str(Global.steps)
		Global.steps +=1
		
		
	elif Global.steps !=0:
		for node in node_list:
			node.Update()
					
		
		
		
			
		for node in node_list:
			
			match node.type:
				Global.Type.INPUT:
					node.GetInput(Global.steps)
				Global.Type.ADDER, \
				Global.Type.INHIBITORY, \
				Global.Type.INHIBITORY2:
					node.Act()
				
				
				Global.Type.OUTPUT:
					node.Act()
					_display_and_judge_output(node)
					
					
		#for node in node_list:#专门为髓鞘安排的遍历
			#if node.type == Global.Type.NEGATION or node.type == Global.Type.THRESHOLD or node.type == Global.Type.DELAY:
				#node.Act()
				
		for i in range(1,max_order+1):
			for node in node_list:
				if !node.is_neuron and node.order ==i:
					node.Act()
					
		
		
		
		$StepCounter.text = "Step:" + str(Global.steps)
		Global.steps +=1
	pass
	
	
func _display_and_judge_output(node):
	for i in range(3):
		if node.cur_states[i] == Global.State.ACTIVATE:
			if node.cur_datas[i] == expected_output[i].get_line(output_counter[i]):
				actual_output[i].insert_line_at(actual_output[i].get_line_count()-1,node.cur_datas[i])
				output_counter[i] += 1
			else:
				actual_output[i].insert_line_at(actual_output[i].get_line_count()-1,">"+node.cur_datas[i])
				if auto_pause: _stop_auto_run()
		elif Global.current_v_mode == Global.VMode.SHOW:
			#before output
			if output_counter[i] == 0 or output_counter[i] >= expected_output[i].get_line_count()-1:
				actual_output[i].insert_line_at(actual_output[i].get_line_count()-1,"v")
			#output correct
			elif expected_output[i].get_line(output_counter[i]) == "v":
				actual_output[i].insert_line_at(actual_output[i].get_line_count()-1,"v")
				output_counter[i] += 1
			#output wrong
			else:
				actual_output[i].insert_line_at(actual_output[i].get_line_count()-1,">v")
				if auto_pause: _stop_auto_run()
	
func Reload():
	get_tree().reload_current_scene()
	

func ResetAll():
	for node in node_list:
		node.Reset()
		
		# node and node.Reset()
	
	Global.running_state = Global.RunningState.IDLE
	
	Global.steps = 0
	
	$StepCounter.text = "Step:"
	
	for i in range(3):
		actual_output[i].clear()
		output_counter[i] = 0
	
	connection_list.clear()
	node_list.clear()
	
	_stop_auto_run()


func _on_choose_level_pressed():
	file_dialog.popup()
	pass # Replace with function body.






func _on_file_dialog_file_selected(path):
	
	Global.current_test_index = 1
	
	var config = ConfigFile.new()
	config.set_value("CurrentLevelPath","current_level_path",path)
	config.save("user://CurrentLevelPath.cfg")
	read_level()




func read_level():
	
	for i in range(3):
		input_lines[i].clear()
		expected_output[i].clear()
	
	var config =  ConfigFile.new()
	config.load("user://CurrentLevelPath.cfg")
	var path = config.get_value("CurrentLevelPath","current_level_path")
	
	
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	var line = content.split("\n")
	
	#set name and despcription
	level_description.text = "{0}\n{1}\n".format([line[0],line[1]],"{_}")
	
	v_sensitive = int(line[2])
	max_test_number = int(line[3])
	
	var reading_line
	for i in range(3):
		reading_line = line[i+5+(Global.current_test_index-1)*7].split(",")
		for line_number in range(reading_line.size()):
			input_lines[i].insert_line_at(line_number, reading_line[line_number])
		reading_line = line[i+8+(Global.current_test_index-1)*7].split(",")
		for line_number in range(reading_line.size()):
			expected_output[i].insert_line_at(
				line_number, reading_line[line_number])
	
	update_display()

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
	ResetAll()
	read_level()
	pass # Replace with function body.


func prev_test():
	if Global.current_test_index != 1:
		Global.current_test_index -= 1
		ResetAll()
		read_level()

	pass # Replace with function body.


func next_test():
	if Global.current_test_index < max_test_number:
		Global.current_test_index += 1
		ResetAll()
		read_level()
	pass # Replace with function body.
	
func update_display():
	
	test.text = "test:{0}/{1}".format([Global.current_test_index, max_test_number],"{_}")
	current_test_number.text = "Case {0}".format([Global.current_test_index])
	current_v_sensitive.button_pressed = bool(v_sensitive)
	
	
	pass


func _toggle_auto_run():
	auto_run = not auto_run
	
	if auto_run:
		timer.start()
	else:
		timer.stop()
	pass # Replace with function body.
	
func _stop_auto_run():
	auto_run = false
	timer.stop()


	
func _on_timer_changed(value):
	timer.wait_time = value
	


func _toggle_auto_pause():
	auto_pause = not auto_pause
	pass # Replace with function body.


func _toggle_v_mode():
	if Global.current_v_mode == Global.VMode.SHOW:
		Global.current_v_mode = Global.VMode.HIDE
	else:
		Global.current_v_mode = Global.VMode.SHOW
	pass # Replace with function body.
