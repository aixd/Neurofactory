extends "generalNode.gd"

@onready var pre_states = [Global.State.ACTIVATE]
@onready var cur_states= [Global.State.ACTIVATE]


var type = Global.Type.CONSTANT
@onready var constant = str($Control/SpinBox.value)
@onready var pre_datas = [constant]
@onready var cur_datas = [constant]


func Update():
	pre_states[0] = cur_states[0]
	pre_datas[0] = cur_datas[0]

	pass

func Reset():
	pre_states = [Global.State.ACTIVATE]
	cur_states = [Global.State.ACTIVATE]
	pre_datas = ["v"]
	cur_datas = ["v"]
	#cache = 0
	#input_node_lists.clear()
	#output_node_lists.clear()
	#data.text = cur_data
	
	

func Act():

	cur_datas[0] = constant
	pass


func _on_spin_box_value_changed(value):
	constant = str(value)
	#cur_datas[0] = constant
	pass # Replace with function body.
