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
	for input in input_node_lists:
		cur_states[0] = Global.State.INACTIVATE
		cur_datas[0] = "v"
		if input[0].cur_states[input[1]] == Global.State.ACTIVATE and !input[0].canInhib:
			cur_states[0] = Global.State.ACTIVATE
			cur_datas[0] = str(- int(input[0].cur_datas[input[1]]))
	
	#print(cur_data)
	data.text = cur_datas[0]
			
	pass

