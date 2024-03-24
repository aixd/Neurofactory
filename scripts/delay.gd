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
	pre_datas[0] = cur_datas[0]
	pre_states[0] = cur_states[0]

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
	if pre_node:
		if Global.steps == 0:
			if pre_node.canInhib: canInhib = true
			for i in range(delay):
				data_sequence.append("v")
				state_sequence.append(Global.State.INACTIVATE)
		for input_node in input_node_lists:
			cur_datas[0] = data_sequence.pop_front()
			cur_states[0] = state_sequence.pop_front()
			data_sequence.append(input_node[0].cur_datas[input_node[1]])
			state_sequence.append(input_node[0].cur_states[input_node[1]])


func _on_spin_box_value_changed(value):
	delay = value
	pass # Replace with function body.
