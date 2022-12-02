extends KinematicBody2D

# Distance from front to rear wheel
var wheel_base= 70
#how far Player turns, in degrees
var steering_angle= 15

var acceleration = Vector2.ZERO
var velocity = Vector2.ZERO
var max_speed_reverse = 150
onready var agent : NavigationAgent2D = $"../NavigationAgent2D"

var engine_power= 500
var friction = -0.9
var drag = -0.001
var braking = -450
var slip_speed = 400
var traction_fast = 0.1
var traction_slow = 0.7

#Calculting if the the player is turning left or right based on input, defining steering_angle in a range of -15 to 15
var steer_direction

onready var sprite = $Sprite
onready var speedlabel = $"../UI_Canvas/UI/VBoxContainer/SpeedLabel"

#main function
func _physics_process(delta):
	acceleration = Vector2.ZERO
	get_input()
	apply_friction()
	calculate_steering(delta)
	velocity += acceleration * delta
	velocity = move_and_slide(velocity)
	speedlabel.text = "Speed:" + String(velocity.length())


#limit speed with proportional amount of friction
func apply_friction():
	#print(velocity.length())
	if velocity.length() < 5:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction
	var drag_force = velocity * velocity.length() * drag
	acceleration += drag_force + friction_force
	
func get_input():
	var turn = 0
	#if right is pressed, streering_angle is defined as -15
	if Input.is_action_pressed("steer_right"):
		turn +=1
	#if left is pressed, streering_angle is defined as 15
	if Input.is_action_pressed("steer_left"):
		turn -=1
	#get either -15 or 15 depending on which key is pressed
	steer_direction = turn * deg2rad(steering_angle)
	
	#acceleration process
	if Input.is_action_pressed("accelerate"):
		acceleration = transform.x * engine_power
	if Input.is_action_pressed("brake"):
		acceleration = transform.x * braking
	

func calculate_steering(delta):
	#location of front and row controllers of the boat
	var rear_wheel = position - transform.x * wheel_base/2.0
	var front_wheel = position + transform.x * wheel_base/2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta
	
	#direction Player is facing
	var new_heading = (front_wheel - rear_wheel).normalized()
	
	#
	var traction = traction_slow
	if velocity.length() > slip_speed:
		traction = traction_fast
	
	#check if Player is going forward or backward
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = velocity.linear_interpolate(new_heading * velocity.length(), traction)
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
	rotation = new_heading.angle()

func _on_Area2D_area_entered(area):
	print(area.name, "Inside Zone")


func _on_Area2D_area_exited(area):
	print(area.name, "Exiting Zone")	
