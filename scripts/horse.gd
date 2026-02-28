extends CharacterBody2D

@export var area_top_left: Vector2
@export var area_bottom_right: Vector2

@export var adultAge_seconds : int = 10;
@export var default_scale: float = 3.0
@export var adult_scale: float = 5.0

@export var move_speed: float = 100.0
@export var target_change_interval: int = 5
@export var target_reach_threshold: float = 5.0
@export var moveProbability_onturn : float = 0.6

@onready var start_marker: Marker2D = $start
@onready var end_marker: Marker2D = $end

var age : int;
var adult : bool;
var target: Vector2
var target_change_counter: int = 0
var reached: bool = false
var moveturn: bool = true

func _ready() -> void:
	scale = Vector2(default_scale, default_scale)
	_born()
	_pick_new_target()
	
func __on_second_timeout() -> void:
	_grow_old()
	moveturn = true
	_check_target_change()
	
func _physics_process(delta: float) -> void:
	if not moveturn:
		velocity = Vector2.ZERO
		reached = true
		move_and_slide()
		return
	var dir: Vector2 = target - global_position
	var dist := dir.length()

	if dist <= target_reach_threshold:
		velocity = Vector2.ZERO
		reached = true
	else:
		velocity = dir.normalized() * move_speed
		reached = false
	move_and_slide()

func _born() -> void:
	age=0; 
	adult=false;
	scale = Vector2(default_scale, default_scale)
	target_change_counter = target_change_interval
	$second.start()	
	
func _grow_old() -> void:	
	age += 1
	print(age)
	if not adult and age >= adultAge_seconds:
		adult = true
		scale = Vector2(adult_scale, adult_scale)

func _check_target_change() -> void:
	target_change_counter -= 1
	if target_change_counter <= 0:
		target_change_counter = target_change_interval
		_pick_new_target()

func _pick_new_target() -> void:
	if age > 0: 
		moveturn = randf() < moveProbability_onturn
	if not moveturn:
		print("not moving this turn")
		return

	print("moving now")

	var min_x = min(area_top_left.x, area_bottom_right.x)
	var max_x = max(area_top_left.x, area_bottom_right.x)
	var min_y = min(area_top_left.y, area_bottom_right.y)
	var max_y = max(area_top_left.y, area_bottom_right.y)

	target = Vector2(
		randf_range(min_x, max_x),
		randf_range(min_y, max_y)
	)
