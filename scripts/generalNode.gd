extends GraphNode

var canInhib = false
var is_multiple_output = false
var is_neuron = true
# @export_enum() var type: int

func Update():
	pass
	

func Reset():
	pass

func Act():
	pass


func _gui_input(event : InputEvent):
	if event.is_action_pressed("delete_node") and \
	Global.running_state == Global.RunningState.IDLE:
		if self.type == Global.Type.INPUT or  self.type == Global.Type.OUTPUT:
			return
		var graph = self.get_parent()
		var connection_list = graph.get_connection_list()
		for c in connection_list:
			if c["from_node"] == self.name or c["to_node"] == self.name:
				graph.disconnect_node(c["from_node"],c["from_port"],c["to_node"],c["to_port"])
		Global.cost -=1
		#print(self.get_tree().get_root().get_name())
		self.get_tree().get_root().get_node("Main").get_node("Cost").text = "Cost:" + str(Global.cost)
		self.get_tree().get_root().get_node("Main").ResetAll()
		self.queue_free()
			
