extends CharacterBody3D

const WALK_SPEED = 5.0
const SPRINT_MODIFIER = 1.3
const CROUCH_MODIFIER = .45
const JUMP_VELOCITY = 4.5
const CAMPIVOT_HEIGHT = .5
const CROUCH_DEPTH = -.5

var current_speed = 0.0
var mouse_sensitivity = .15
var lerp_speed = 10.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var direction = Vector3.ZERO

var is_crouched = false

var interacting_obj = null

signal interact_prompt_changed(new_value: String)

@onready var cam_pivot = $CamPivot
@onready var collider = $Main_Collider
@onready var crouch_raycast = $CrouchRaycast
@onready var crouch_collider = $Crouch_Collider
@onready var interact_raycast = $CamPivot/Camera/InteractRaycast

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
		is_crouched = true
	elif Input.is_action_pressed("action_sprint") and not is_crouched:
		current_speed = WALK_SPEED * SPRINT_MODIFIER;

	# if the player is crouched, adjust camera and capsule collision
	if is_crouched:
		if !crouch_raycast.is_colliding():
			is_crouched = false
		current_speed = WALK_SPEED * CROUCH_MODIFIER;
		cam_pivot.position.y = lerp(cam_pivot.position.y, CAMPIVOT_HEIGHT + CROUCH_DEPTH, delta*lerp_speed)
		collider.disabled = true
		crouch_collider.disabled = false
	else:
		collider.disabled = false
		crouch_collider.disabled = true
		cam_pivot.position.y = lerp(cam_pivot.position.y, CAMPIVOT_HEIGHT, delta*lerp_speed)
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta*lerp_speed)
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()
	
func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# Check for interactables
	if interact_raycast.is_colliding() and interact_raycast.get_collider().get_parent() is Interactable:
		if interact_raycast.get_collider().get_parent() != interacting_obj:	
			interacting_obj = interact_raycast.get_collider().get_parent()
			interact_prompt_changed.emit(interacting_obj.get_prompt())
	else:
		interacting_obj = null
		interact_prompt_changed.emit('')

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		cam_pivot.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		cam_pivot.rotation.x = clamp(cam_pivot.rotation.x, deg_to_rad(-89), deg_to_rad(89))
		
	if Input.is_action_just_pressed("action_interact") and interacting_obj:
		interacting_obj.interact(self, func (response: String): print(response))
	
	if Input.is_action_just_pressed("action_open_tasks"):
		var ui = get_ui()
		if ui.tasks.visible:
			ui.hide_tasks()
		else:
			ui.show_tasks()

func get_ui():
	if get_parent() and get_parent().has_method('get_ui'):
		return get_parent().get_ui()
	return null
