extends "generalNode.gd"

@onready var pre_states = [Global.State.INACTIVATE]
@onready var cur_states = [Global.State.INACTIVATE]
@onready var pre_datas = ["v"]
@onready var cur_datas = ["v"]

var type = Global.Type.DELAY
@onready var delay = $SpinBox.value
#@onready var data = $Data

@onready var input_node_lists = []

@onready var data_sequence = []
@onready var state_sequence = []


#var next_node:Node
var pre_node:Node
var order = 1

func _ready():
	is_neuron = false


func Update():
	if Global.steps == 0:
		for i in range(delay):
			data_sequence.append("v")
			state_sequence.append(Global.State.INACTIVATE)
		#for input_node in input_node_lists:
			#if input_node[0].type == Global.Type.INHIBITORY:
				#data_sequence.append("v")
				#state_sequence.append(Global.State.INACTIVATE)
				#canInhib = true
			#elif input_node[0].type == Global.Type.INHIBITORY2:
				#data_sequence.append("s")
				#state_sequence.append(Global.State.ACTIVATE)
				#canInhib = true
			#else:
				#data_sequence.append("v")
				#state_sequence.append(Global.State.INACTIVATE)
		if pre_node and pre_node.canInhib:
			canInhib = true
		data_sequence.append(pre_node.cur_datas[0]) 
		state_sequence.append(pre_node.cur_states[0])
		pre_datas[0] = data_sequence.pop_front()
		pre_states[0] = state_sequence.pop_front()
	else:
		#pre_datas[0] = data_sequence.pop_front()
		#pre_states[0] = state_sequence.pop_front()
		
		pre_datas[0] = cur_datas[0]
		pre_states[0] = cur_states[0]
		pass

	pass

func Reset():
	pre_states = [Global.State.INACTIVATE]
	cur_states = [Global.State.INACTIVATE]
	pre_datas = ["v"]
	cur_datas = ["v"]


	input_node_lists.clear()
	data_sequence.clear()
	state_sequence.clear()
	#data.text = cur_data
	
	

func Act():
	#var flag = false
	for input_node in input_node_lists:
		if !input_node[0].canInhib:
			data_sequence.append(input_node[0].cur_datas[input_node[1]])
			state_sequence.append(input_node[0].cur_states[input_node[1]])
		elif input_node[0].canInhib:
			data_sequence.append(input_node[0].cur_datas[input_node[1]])
			state_sequence.append(input_node[0].cur_states[input_node[1]])
	
	#if pre_node.canInhib:
		#data_sequence.append(pre_node.cur_datas[0])
		#state_sequence.append(pre_node.cur_states[0])
	#else:
		#data_sequence.append(pre_node.cur_datas[0])
		#state_sequence.append(pre_node.cur_states[0])
	cur_datas[0] = data_sequence.pop_front()
	cur_states[0] = state_sequence.pop_front()
	
			
	pass


func _on_spin_box_value_changed(value):
	delay = value
	pass # Replace with function body.
