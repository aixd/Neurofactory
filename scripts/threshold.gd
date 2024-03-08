extends "generalNode.gd"

#var pre_state = Global.State.INACTIVATE
#var cur_state = Global.State.INACTIVATE
#var pre_data = "v"
#var cur_data = "v"

var type = Global.Type.THRESHOLD

@onready var threshold = $SpinBox.value
@onready var data1 = $Data
@onready var data2 = $Data2
@onready var data3 = $Data3

@onready var input_node_lists = []
@onready var pre_states = [Global.State.INACTIVATE,Global.State.INACTIVATE,Global.State.INACTIVATE]
@onready var cur_states = [Global.State.INACTIVATE,Global.State.INACTIVATE,Global.State.INACTIVATE]
@onready var pre_datas = ["v","v","v"]
@onready var cur_datas = ["v","v","v"]

#var next_node:Node
var pre_node:Node
var order = 1


func _ready():
	is_multiple_output = true
	is_neuron = false
#var canInhib = false
func Update():
	#pre_state = cur_state
	#pre_data = cur_data
	for i in range(3):
		pre_states[i] = cur_states[i]
		pre_datas[i] = cur_datas[i]

	pass

func Reset():
	#pre_state = Global.State.INACTIVATE
	#cur_state = Global.State.INACTIVATE
	#pre_data = "v"
	#cur_data = "v"
	for i in range(3):
		pre_states[i] = Global.State.INACTIVATE
		cur_states[i] = Global.State.INACTIVATE
		pre_datas[i] = "v"
		cur_datas[i] = "v"
		
		
	input_node_lists.clear()

	data1.text = cur_datas[0]
	data2.text = cur_datas[1]
	data3.text = cur_datas[2]
	
	

func Act():
	#var flag = false
	for input_node in input_node_lists:
		if input_node[0].cur_states[input_node[1]] == Global.State.ACTIVATE and !input_node[0].canInhib:
			if int(input_node[0].cur_datas[input_node[1]]) > threshold:
				#cur_data = input_node.cur_data
				#cur_state = Global.State.ACTIVATE
				cur_datas[0] = input_node[0].cur_datas[input_node[1]]
				cur_states[0] = Global.State.ACTIVATE
				cur_datas[1] = "v"
				cur_states[1] = Global.State.INACTIVATE
				cur_datas[2] = "v"
				cur_states[2] = Global.State.INACTIVATE
			elif int(input_node[0].cur_datas[input_node[1]]) == threshold:
				cur_datas[1] = input_node[0].cur_datas[input_node[1]]
				cur_states[1] = Global.State.ACTIVATE
				cur_datas[0] = "v"
				cur_states[0] = Global.State.INACTIVATE
				cur_datas[2] = "v"
				cur_states[2] = Global.State.INACTIVATE
				#cur_data = "v"
				#cur_state = Global.State.INACTIVATE
			elif int(input_node[0].cur_datas[input_node[1]]) < threshold:
				cur_datas[2] = input_node[0].cur_datas[input_node[1]]
				cur_states[2] = Global.State.ACTIVATE
				cur_datas[0] = "v"
				cur_states[0] = Global.State.INACTIVATE
				cur_datas[1] = "v"
				cur_states[1] = Global.State.INACTIVATE
				
		if input_node[0].cur_states[input_node[1]] == Global.State.INACTIVATE and !input_node[0].canInhib:
			#cur_data = "v"
			#cur_state = Global.State.INACTIVATE
			cur_datas[0] = "v"
			cur_states[0] = Global.State.INACTIVATE
			cur_datas[1] = "v"
			cur_states[1] = Global.State.INACTIVATE
			cur_datas[2] = "v"
			cur_states[2] = Global.State.INACTIVATE
	
	#print(cur_data)
	data1.text = cur_datas[0]
	data2.text = cur_datas[1]
	data3.text = cur_datas[2]
			
	pass


func _on_spin_box_value_changed(value):
	threshold = value
	pass # Replace with function body.
