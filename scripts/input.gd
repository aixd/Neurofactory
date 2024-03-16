extends "generalNode.gd"

@onready var pre_states = [Global.State.INACTIVATE,Global.State.INACTIVATE,Global.State.INACTIVATE]
@onready var cur_states = [Global.State.INACTIVATE,Global.State.INACTIVATE,Global.State.INACTIVATE]
@onready var pre_datas = ["v","v","v"]
@onready var cur_datas = ["v","v","v"]
#var cache = 0 # for computing
var type = Global.Type.INPUT
@onready var data = [$Data, $Data2, $Data3]
#var canInhib = false
#@onready var input_node_lists = []
#@onready var output_node_lists = []
@onready var input_lines = [[], [], []]

func Update():
	for i in range(3):
		pre_states[i] = cur_states[i]
		pre_datas[i] = cur_datas[i]
	pass
	
func Reset():
	for i in range(3):
		pre_states[i] = Global.State.INACTIVATE
		cur_states[i] = Global.State.INACTIVATE
		pre_datas[i] = "v"
		cur_datas[i] = "v"
		input_lines[i].clear()
		data[i].text = "v"
	
func GetInput(steps):
	for i in range(3):
		cur_datas[i] = "v"
		if steps < input_lines[i].size():#即使一开始什么都不输入是个空框，大小也是1（输了数也是1）
			cur_datas[i] = input_lines[i][steps]
		if cur_datas[i] =="" or cur_datas[i] == "e":
			cur_datas[i] = "v"
			
		if cur_datas[i] != "v":
			cur_states[i] = Global.State.ACTIVATE
		else:
			cur_states[i] = Global.State.INACTIVATE
		data[i].text = cur_datas[i]






