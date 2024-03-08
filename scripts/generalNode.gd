extends GraphNode

var canInhib = false
var is_multiple_output = false
var is_neuron = true





func Update():
	pass
	

func Reset():
	pass

func Act():
	pass


func _gui_input(event : InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
			#self.clear_all_slots() 通过禁用插槽无法将这些线给删除！
			if self.type == Global.Type.INPUT:
				Global.input_counter -=1
			elif self.type == Global.Type.OUTPUT:
				Global.output_counter -=1
			var graph = self.get_parent()
			var connection_list = graph.get_connection_list()
			for connection in connection_list:
				if connection["from_node"]== self.name:
					graph.disconnect_node(connection["from_node"],connection["from_port"],connection["to_node"],connection["to_port"])
				if connection["to_node"]== self.name:
					graph.disconnect_node(connection["from_node"],connection["from_port"],connection["to_node"],connection["to_port"])
			Global.cost -=1	
			#print(self.get_tree().get_root().get_name())
			self.get_tree().get_root().get_node("Main").get_node("Cost").text = "Cost:" + str(Global.cost) 	
			self.queue_free()
			
