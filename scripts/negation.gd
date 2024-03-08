extends "generalNode.gd"

@onready var pre_states = [Global.State.INACTIVATE]
@onready var cur_states = [Global.State.INACTIVATE]
@onready var pre_datas = ["v"]
@onready var cur_datas = ["v"]

var type = Global.Type.NEGATION
@onready var data = $Data

@onready var input_node_lists = []

#var next_node:Node
var pre_node:Node

#var canInhib = false 
var order = 1

func _ready():
	is_neuron = false


func Update():
	pre_states[0] = cur_states[0]
	pre_datas[0] = cur_datas[0]


func Reset():
	pre_states = [Global.State.INACTIVATE]
	cur_states = [Global.State.INACTIVATE]
	pre_datas = ["v"]
	cur_datas = ["v"]
	input_node_lists.clear()

	data.text = cur_datas[0]
	
	

func Act():
	#var flag = false
	for input_node in input_node_lists:
		if input_node[0].cur_states[input_node[1]] == Global.State.ACTIVATE and !input_node[0].canInhib:
			cur_datas[0] = str(- int(input_node[0].cur_datas[input_node[1]]))
			cur_states[0] = Global.State.ACTIVATE
		if input_node[0].cur_states[input_node[1]] == Global.State.INACTIVATE and !input_node[0].canInhib:
			cur_datas[0] = "v"
			cur_states[0] = Global.State.INACTIVATE
	
	#print(cur_data)
	data.text = cur_datas[0]
			
	pass

