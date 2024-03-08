extends "generalNode.gd"

@onready var pre_states = [Global.State.INACTIVATE,Global.State.INACTIVATE,Global.State.INACTIVATE]
@onready var cur_states = [Global.State.INACTIVATE,Global.State.INACTIVATE,Global.State.INACTIVATE]
@onready var pre_datas = ["v","v","v"]
@onready var cur_datas = ["v","v","v"]
#var cache = 0 # for computing
var type = Global.Type.INPUT
@onready var data1 = $Data
@onready var data2 = $Data2
@onready var data3 = $Data3
#var canInhib = false
#@onready var input_node_lists = []
#@onready var output_node_lists = []
@onready var input_lines1 = []
@onready var input_lines2 = []
@onready var input_lines3 = []

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
	
	input_lines1.clear()
	input_lines2.clear()
	input_lines3.clear()
	
	data1.text = cur_datas[0]
	data2.text = cur_datas[1]
	data3.text = cur_datas[2]
	
func GetInput(steps):
	var cache1
	var cache2
	var cache3
	if steps >= input_lines1.size():#即使一开始什么都不输入是个空框，大小也是1（输了数也是1）
		cache1 = "v"
	else:
		cache1 = input_lines1[steps]
		if cache1 =="" or cache1 == "e":cache1 = "v"
	if cache1 != "v":
		cur_states[0] = Global.State.ACTIVATE
	else:
		cur_states[0] = Global.State.INACTIVATE
	cur_datas[0] = cache1
	data1.text = cur_datas[0]
	
	
	if steps >= input_lines2.size():#即使一开始什么都不输入是个空框，大小也是1
		cache2 = "v"
	else:
		cache2 = input_lines2[steps]
		if cache2 =="" or cache2 == "e":cache2 = "v"
	if cache2 != "v":
		cur_states[1] = Global.State.ACTIVATE
	else:
		cur_states[1] = Global.State.INACTIVATE
	cur_datas[1] = cache2
	data2.text = cur_datas[1]
	
	
	if steps >= input_lines3.size():#即使一开始什么都不输入是个空框，大小也是1
		cache3 = "v"
	else:
		cache3 = input_lines3[steps]
		if cache3 =="" or cache3 == "e":cache3 = "v"
	if cache3 != "v":
		cur_states[2] = Global.State.ACTIVATE
	else:
		cur_states[2] = Global.State.INACTIVATE
	cur_datas[2] = cache3
	data3.text = cur_datas[2]
	
	
	
	




