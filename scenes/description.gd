extends GraphNode

@onready var description = $Control/TextEdit

func set_text(text):
	description.text = text
	
func display_victory_info():
	description.insert_line_at(
					description.get_line_count()-1,
					"complete"
				)
