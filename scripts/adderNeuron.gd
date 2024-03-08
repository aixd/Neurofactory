extends "generalNode.gd"

@onready var pre_states = [Global.State.INACTIVATE]
@onready var cur_states = [Global.State.INACTIVATE]
@onready var pre_datas = ["v"]
@onready var cur_datas = ["v"]
var cache = 0 # for computing
var type = Global.Type.ADDER
@onready var data = $Data

@onready var input_node_lists = []




func Update():
	pre_states[0] = cur_states[0]
	pre_datas[0] = cur_datas[0]
	cache = 0
	pass

func Reset():
	pre_states = [Global.State.INACTIVATE]
	cur_states = [Global.State.INACTIVATE]
	pre_datas = ["v"]
	cur_datas = ["v"]
	cache = 0
	input_node_lists.clear()

	data.text = cur_datas[0]
	
	

func Act():
	var flag = false
	for input_node in input_node_lists:
		if input_node[0].pre_states[input_node[1]] == Global.State.ACTIVATE and input_node[0].canInhib:
			flag = false
			break
		elif input_node[0].pre_states[input_node[1]] == Global.State.ACTIVATE and !input_node[0].canInhib: 
			cache = cache + int(input_node[0].pre_datas[input_node[1]])
			
			flag = true
	if flag:
		cur_states[0] = Global.State.ACTIVATE
		cache = Limit(cache)
		cur_datas[0] = str(cache)
		#print("OK")
		
	else:
		cur_states[0] = Global.State.INACTIVATE
		cur_datas[0] = "v"
	
	data.text = cur_datas[0]
			
	pass


func Limit(number:int) -> int:
	if number>100:
		number =100
	elif number<-100:
		number = -100
	return number
	

#func _input(event):
	# 检查事件是否是鼠标按下事件，按钮是否是右键，以及鼠标位置是否在节点内
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and get_rect().has_point(get_local_mouse_pos()):
		#if event.pressed:
			# 是鼠标按下事件，按下右键，鼠标在当前节点内则删除该节点
			#queue_free()

