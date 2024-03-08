extends Node2D
enum Type {INPUT,ADDER,INHIBITORY,INHIBITORY2,OUTPUT,NEGATION,THRESHOLD,DELAY,CONSTANT}
enum State {ACTIVATE,INACTIVATE}
enum VMode {SHOW,HIDE} #展示或者隐藏void


var steps = 0

var cost = 0

var input_counter = 0
var output_counter = 0






var current_v_mode 
var current_test_index = 1



func _ready():
	var config = ConfigFile.new()
	config.load("user://VMode.cfg")
	current_v_mode= config.get_value("VMode","current_v_mode",Global.VMode.SHOW)
