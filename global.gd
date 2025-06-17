extends Node

var current_labels:int = 0
var lbl_limit:int = 45
var can_dmg_num:bool = true
var can_afterimage:bool = true

var total_wep_select = []
var current_wep_select = 0

var upgrades_left:Array = []

var endless:bool = false

func clear_upgrades():
	upgrades_left = []
