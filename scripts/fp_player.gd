extends CharacterBody3D

const WALK_SPEED = 5.0
const SPRINT_MODIFIER = 1.3
const CROUCH_MODIFIER = .7
const JUMP_VELOCITY = 4.5

var current_speed = 0.0
var mouse_sensitivity = .15
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var cam_pivot = $CamPivot

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("action_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Determine the character's speed
	current_speed = WALK_SPEED
	if Input.is_action_pressed("action_crouch"):
		current_speed = WALK_SPEED * CROUCH_MODIFIER;
	elif Input.is_action_pressed("action_sprint"):
		current_speed = WALK_SPEED * SPRINT_MODIFIER;

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()
	
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		cam_pivot.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		cam_pivot.rotation.x = clamp(cam_pivot.rotation.x, deg_to_rad(-89), deg_to_rad(89))

