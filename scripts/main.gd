extends Node2D

var adderNeuron = preload("res://scenes/adderNeuron.tscn")
var inhibitoryNeuron = preload("res://scenes/inhibitoryNeuron.tscn")
var inhibitoryNeuron2 = preload("res://scenes/inhibitoryNeuron2.tscn")
var input = preload("res://scenes/input.tscn")
var output = preload("res://scenes/output.tscn")
var negation = preload("res://scenes/negation.tscn")
var threshold = preload("res://scenes/threshold.tscn")
var delay = preload("res://scenes/delay.tscn")
var constant = preload("res://scenes/constant.tscn")
var description = preload("res://scenes/description.tscn")

var play_icon = preload("res://AlxvUI/play_hover.png")
var pause_icon = preload("res://AlxvUI/pause_hover.png")

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

@onready var exp_out = [
	$Channels/ExpectedOutput, 
	$Channels/ExpectedOutput2, 
	$Channels/ExpectedOutput3,
]

@onready var act_out = [
	$Channels/ActualOutput,
	$Channels/ActualOutput2,
	$Channels/ActualOutput3,
]

@onready var current_test_number = $TestControl/TestNumber

@onready var current_v_sensitive = $VSensitive
@onready var timer = $Timer
@onready var timer_length = $HSlider

@onready var neuron_button = $Buttons/Neuron
@onready var myelin_button = $Buttons/Myelin
@onready var play_button = $Buttons/Run

#@onready var curList = []
#@onready var preList = []
#var Global.steps = 0

#var output_counter = 0
@onready var connection_list = [] #图的关系
@onready var node_list = [] #所有的点集合
#@onready var lines = []
# Called when the node enters the scene tree for the first time.

var out_cnt = [0,0,0]
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
	
	neuron_button.get_popup().id_pressed.connect(_add_neuron)
	myelin_button.get_popup().id_pressed.connect(_add_myelin)
	

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
	if FROM_NODE.type == Global.Type.INHIBITORY or FROM_NODE.type == Global.Type.INHIBITORY2:
		if TO_NODE.type == Global.Type.NEGATION or TO_NODE.type == Global.Type.THRESHOLD:
			return
	if TO_NODE.type == Global.Type.OUTPUT:
		#限定output前面不能是抑制神经元
		if FROM_NODE.type == Global.Type.INHIBITORY or FROM_NODE.type == Global.Type.INHIBITORY2:
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
			if child is GraphNode and child.name != "Description":
				node_list.append(child)
		
				
		for node in node_list:
			# print(node.name)
			for c in connection_list:
				if c["to_node"] == node.name:
					#返回的确实是int类型
					# print(typeof(connection["from_port"])) #这个connection["from_port"]
					#感觉是最重要的一步
					node.input_node_lists.append(
						[graph.get_node(str(c["from_node"])),c["from_port"],c["to_port"]]
					)
					
					if !node.is_neuron:
						node.pre_node = graph.get_node(str(c["from_node"]))
						print("Debug "+node.name)
						
						
					#if connection["from_node"] == node.name and !node.is_neuron:
						#node.next_node = graph.get_node(str(connection["to_node"]))
						
		for node in node_list:
			if !node.is_neuron:
				var cur_node = node
				var pre_node = node.pre_node
				while(pre_node and !pre_node.is_neuron and pre_node.type != Global.Type.INPUT):
					node.order += 1
					cur_node = pre_node
					pre_node = cur_node.pre_node
				if node.order>max_order:
					max_order = node.order
		
		if input_node !=null:
			for i in range(3):
				for line in range(input_lines[i].get_line_count()):  # 遍历所有行
					input_node.input_lines[i].append(input_lines[i].get_line(line))
				
			input_node.GetInput(Global.steps)
		
		
		for i in range(1,max_order+1):
			for node in node_list:
				if !node.is_neuron and node.order ==i:
					node.Act()
		
		
		for node in node_list:
			if node.type == Global.Type.CONSTANT:
				node.Act()
				#只用执行一次就够了吧
		
		$StepCounter.text = "Step:" + str(Global.steps)
		Global.steps +=1
		
		
	elif Global.steps !=0:
		for node in node_list:
			node.Update()
		
		for node in node_list:
			
			match node.type:
				Global.Type.INPUT:
					node.GetInput(Global.steps)
				Global.Type.ADDER, Global.Type.INHIBITORY, Global.Type.INHIBITORY2:
					node.Act()
				
				
				Global.Type.OUTPUT:
					node.Act()
					if _display_and_judge_output(node):
						if auto_run:
							
							if Global.current_test_index == max_test_number:
								_display_victory_info()
								_stop_auto_run()
							else:
								next_test()
								_start_auto_run()
						return
					
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
			if node.cur_datas[i] == exp_out[i].get_line(out_cnt[i]):
				act_out[i].insert_line_at(
					act_out[i].get_line_count()-1,
					node.cur_datas[i]
				)
				out_cnt[i] += 1
				if out_cnt[i] == exp_out[i].get_line_count()-1:
					if _output_match():
						return true
			else:
				act_out[i].insert_line_at(
					act_out[i].get_line_count()-1,
					">"+node.cur_datas[i]
				)
				if auto_pause: _stop_auto_run()
		else:
			if exp_out[i].get_line(out_cnt[i]) == "v":
				act_out[i].insert_line_at(act_out[i].get_line_count()-1,"v")
				out_cnt[i] += 1
			elif v_sensitive and out_cnt[i] > 0 and out_cnt[i] < exp_out[i].get_line_count()-1:
				act_out[i].insert_line_at(act_out[i].get_line_count()-1,">v")
				if auto_pause: _stop_auto_run()
	return false

func Reload():
	get_tree().reload_current_scene()
	

func ResetAll():
	for node in node_list:
		node.Reset()
	Global.running_state = Global.RunningState.IDLE
	Global.steps = 0
	$StepCounter.text = "Step:"
	for i in range(3):
		act_out[i].clear()
	out_cnt = [0,0,0]
	connection_list.clear()
	node_list.clear()
	_stop_auto_run()


func _on_choose_level_pressed():
	file_dialog.popup()
	pass # Replace with function body.

func _output_match():
	var output_match = 0
	for i in range(3):
		if out_cnt[i] == exp_out[i].get_line_count()-1:
			output_match += 1
	if output_match == 3:
		return true
	return false




func _on_file_dialog_file_selected(path):
	
	Global.current_test_index = 1
	
	var config = ConfigFile.new()
	config.set_value("CurrentLevelPath","current_level_path",path)
	config.save("user://CurrentLevelPath.cfg")
	read_level()




func read_level():
	
	for i in range(3):
		input_lines[i].clear()
		exp_out[i].clear()
	
	var config =  ConfigFile.new()
	config.load("user://CurrentLevelPath.cfg")
	var path = config.get_value("CurrentLevelPath","current_level_path")
	
	
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	var line = content.split("\n")
	
	#set name and despcription
	graph.get_node("Description").set_text("{0}\n{1}\n".format([line[0],line[1]],"{_}"))
	
	# level_description.text = "{0}\n{1}\n".format([line[0],line[1]],"{_}")
	
	
	v_sensitive = int(line[2])
	max_test_number = int(line[3])
	
	var reading_line
	for i in range(3):
		reading_line = line[i+5+(Global.current_test_index-1)*7].split(",")
		for line_number in range(reading_line.size()):
			input_lines[i].insert_line_at(line_number, reading_line[line_number])
		reading_line = line[i+8+(Global.current_test_index-1)*7].split(",")
		for line_number in range(reading_line.size()):
			exp_out[i].insert_line_at(line_number, reading_line[line_number])
	
	update_display()

func _change_v_sensitive():
	v_sensitive = not v_sensitive
	
	
	
	
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

func _set_test_case(case):
	Global.current_test_index = case
	ResetAll()
	read_level()


func prev_test():
	if Global.current_test_index != 1:
		_set_test_case(Global.current_test_index-1)
func next_test():
	if Global.current_test_index < max_test_number:
		_set_test_case(Global.current_test_index+1)
	

func update_display():
	test.text = "test:{0}/{1}".format([Global.current_test_index, max_test_number],"{_}")
	current_test_number.text = "Case {0}".format([Global.current_test_index])
	current_v_sensitive.button_pressed = bool(v_sensitive)
	
	
	pass

func _display_victory_info():
	graph.get_node("Description").display_victory_info()

func _toggle_auto_run():
	if !auto_run:
		_set_test_case(1)
		_start_auto_run()
	else:
		_stop_auto_run()


func _start_auto_run():
	Step()
	auto_run = true
	timer.start()
	play_button.icon = pause_icon

func _stop_auto_run():
	auto_run = false
	timer.stop()
	play_button.icon = play_icon


	
func _on_timer_changed(value):
	if auto_run:
		timer.stop()
		timer.wait_time = value
		timer.start()
	else:
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
