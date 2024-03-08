extends "generalNode.gd"

@onready var pre_states = [Global.State.INACTIVATE,Global.State.INACTIVATE,Global.State.INACTIVATE]
@onready var cur_states = [Global.State.INACTIVATE,Global.State.INACTIVATE,Global.State.INACTIVATE]
@onready var pre_datas = ["v","v","v"]
@onready var cur_datas = ["v","v","v"]
#var cache = 0 # for computing
var type = Global.Type.OUTPUT
@onready var data1 = $Data
@onready var data2 = $Data2
@onready var data3 = $Data3

@onready var input_node_lists = []




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
	#cache = 0
	input_node_lists.clear()

	data1.text = cur_datas[0]
	data2.text = cur_datas[1]
	data3.text = cur_datas[2]
	
	

func Act():
	#var flag = false
	#for input_node in input_node_lists:
		#if input_node[0].pre_states[input_node[1]] == Global.State.ACTIVATE and input_node[0].canInhib:
			#flag = false
			#break
		#elif input_node[0].pre_states[input_node[1]] == Global.State.ACTIVATE and !input_node[0].canInhib: 
			#cache = cache + int(input_node[0].pre_datas[input_node[1]])
			#flag = true
	#if flag:
		#cur_states[0] = Global.State.ACTIVATE
		#cur_datas[0] = str(cache)
		##print("OK")
		#
	#else:
		#cur_states[0] = Global.State.INACTIVATE
		#cur_datas[0] = "v"
	#
	#data.text = cur_datas[0]
	for input_node in input_node_lists:
		if input_node[0].pre_states[input_node[1]] == Global.State.ACTIVATE:
			cur_states[input_node[2]] = Global.State.ACTIVATE
			cur_datas[input_node[2]] = input_node[0].pre_datas[input_node[1]]
		else:
			cur_states[input_node[2]] = Global.State.INACTIVATE
			cur_datas[input_node[2]] = "v"
		
		
		data1.text = cur_datas[0]
		data2.text = cur_datas[1]
		data3.text = cur_datas[2]
	
	
	
	
	
			
	pass


#func _input(event):
	# 检查事件是否是鼠标按下事件，按钮是否是右键，以及鼠标位置是否在节点内
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and get_rect().has_point(get_local_mouse_pos()):
		#if event.pressed:
			# 是鼠标按下事件，按下右键，鼠标在当前节点内则删除该节点
			#queue_free()

