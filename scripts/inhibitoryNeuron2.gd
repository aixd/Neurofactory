extends "generalNode.gd"

@onready var pre_states = [Global.State.ACTIVATE]
@onready var cur_states = [Global.State.ACTIVATE]
@onready var pre_datas = ["s"]
@onready var cur_datas = ["s"]
#第一回合是s，所以一开始就是s
var type = Global.Type.INHIBITORY2
@onready var data = $Data

@onready var input_node_lists = []



func _ready():
	canInhib = true

func Update():
	pre_states[0] = cur_states[0]
	pre_datas[0] = cur_datas[0]
	pass
	
func Reset():
	pre_states = [Global.State.ACTIVATE]
	cur_states = [Global.State.ACTIVATE]
	pre_datas = ["s"]
	cur_datas = ["s"]
	input_node_lists.clear()

	data.text = cur_datas[0]

func Act():
	var flag = true
	for input_node in input_node_lists:
		if input_node[0].pre_states[input_node[1]] == Global.State.ACTIVATE:
			flag = false
			break
		#elif input_node.pre_state == Global.State.ACTIVATE and  !input_node.canInhib: 
			#flag = true
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
