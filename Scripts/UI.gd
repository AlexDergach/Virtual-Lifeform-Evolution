extends Control

@onready var desert_label = $"PopPanel/Desert/Label"
@onready var forest_label = $"PopPanel/Forest/Label"
@onready var fire_label = $"PopPanel/Fire/Label"
@onready var stone_label = $"PopPanel/Stone/Label"
@onready var ice_label = $"PopPanel/Ice/Label"
@onready var time_label = $"Panel/Time"


@onready var TotalPopLabel = $"TotalPop/Label"

@onready var time = $Panel

@onready var PopPanel = $PopPanel
@onready var TotalPop = $TotalPop
@onready var Controls = $Controls

var toggel = 1

func _ready():
	
	#Control.MOUSE_FILTER_IGNORE - Is passed in Insepector
	pass # Replace with function body.

func _process(delta):
	if toggel == 1:
		if Input.is_action_just_pressed("Vis"):
			PopPanel.visible = false
			TotalPop.visible = false
			Controls.visible = false
			time.visible = false
			toggel = 0
	else:
		if Input.is_action_just_pressed("Vis"):
			PopPanel.visible = true
			TotalPop.visible = true
			Controls.visible = true
			time.visible = true
			toggel = 1			
