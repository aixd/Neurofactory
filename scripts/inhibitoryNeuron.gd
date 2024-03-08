extends "generalNode.gd"

@onready var pre_states = [Global.State.INACTIVATE]
@onready var cur_states = [Global.State.INACTIVATE]
@onready var pre_datas = ["v"]
@onready var cur_datas = ["v"]
#var canInhib = true#var cache = 0 # for computing
var type = Global.Type.INHIBITORY
@onready var data = $Data

@onready var input_node_lists = []



func _ready():
	canInhib = true

func Update():
	pre_states[0] = cur_states[0]
	pre_datas[0] = cur_datas[0]
	pass
	
func Reset():
	pre_states = [Global.State.INACTIVATE]
	cur_states = [Global.State.INACTIVATE]
	pre_datas = ["v"]
	cur_datas = ["v"]
	input_node_lists.clear()

	data.text = cur_datas[0]

func Act():
	var flag = false
	for input_node in input_node_lists:
		if input_node[0].pre_states[input_node[1]] == Global.State.ACTIVATE and  input_node[0].canInhib:
			flag = false
			break
		elif input_node[0].pre_states[input_node[1]] == Global.State.ACTIVATE and  !input_node[0].canInhib: 
			flag = true
	if flag:
		cur_states[0] = Global.State.ACTIVATE
		cur_datas[0] = "s"
		#cur_data = str(cache)
		#print("OK")
		#cache = 0
	else:
		cur_states[0] = Global.State.INACTIVATE
		cur_datas[0] = "v"
	
	data.text = cur_datas[0]
			
	pass
