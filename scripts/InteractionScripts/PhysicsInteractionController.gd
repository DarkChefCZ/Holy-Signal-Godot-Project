extends Node

@onready var interaction_controller: Node = %InteractionController
@onready var ray_cast_3d: RayCast3D = $"../Head/Camera3D/InteractionRaycast"
@onready var hand: Marker3D = $"../Head/Camera3D/Hand"
@onready var player_camera: Camera3D = $"../Head/Camera3D"
@onready var control: Control = $"../GUI/ReticleLayer/Control"

# Reticles
@onready var default_reticle: TextureRect = $"../GUI/ReticleLayer/Control/DefaultReticle"
@onready var can_interact_reticle: TextureRect = $"../GUI/ReticleLayer/Control/CanInteractReticle"
@onready var interacting_reticle: TextureRect = $"../GUI/ReticleLayer/Control/InteractingReticle"

@export var InteractableDistance: float = -2.0 #negative z is where our camera is aiming at in the Player scene
@export var NameOfInteractionComponentNode: String #put here the name of the interaction component NODE that your rigid body 3D nodes have


var current_object: Object
var last_potential_object: Object
var interaction_component: Node

func _ready() -> void:
	ray_cast_3d.target_position.z = InteractableDistance
	hand.position.z = InteractableDistance
	
	default_reticle.position.x = get_viewport().size.x / 2 - default_reticle.texture.get_size().x / 2
	default_reticle.position.y = get_viewport().size.y / 2 - default_reticle.texture.get_size().y / 2
	
	can_interact_reticle.position.x = get_viewport().size.x / 2 - can_interact_reticle.texture.get_size().x / 2
	can_interact_reticle.position.y = get_viewport().size.y / 2 - can_interact_reticle.texture.get_size().y / 2
	
	interacting_reticle.position.x = get_viewport().size.x / 2 - interacting_reticle.texture.get_size().x / 2
	interacting_reticle.position.y = get_viewport().size.y / 2 - interacting_reticle.texture.get_size().y / 2

func _process(_delta: float) -> void:
	
	if interaction_component and interaction_component.is_interacting:
		changeReticle(interacting_reticle)
	
	# if on previous frame, we were interacting with an object, lets keep interacting with that object
	if current_object:
		if interaction_component:
			var maxInteractionDistance: float
			
			match interaction_component.interaction_type:
				interaction_component.InteractionType.DOOR:
					maxInteractionDistance = 3.0
				_:
					maxInteractionDistance = 2.0
			
			if hand.global_transform.origin.distance_to(current_object.global_transform.origin) > maxInteractionDistance:
				interaction_component.postInteract()
				current_object = null
			
		
		
		
		if Input.is_action_just_pressed("Secondary_mb"): # check if we are pressing the secondary/left mouse button - to throw
			if !interaction_component:
				return
			else:
				interaction_component.auxInteract()
				current_object = null
				changeReticle(default_reticle)
		elif Input.is_action_pressed("Primary_mb"): # check if we are still pressing the primary/left mouse button
			if !interaction_component:
				return
			else:
				interaction_component.interact()
		else:
			if !interaction_component:
				return
			else:
				interaction_component.postInteract()
				current_object = null
				
				changeReticle(default_reticle)
		
	else: # if we weren't interacting with something, lets see if we can
		var potential_object: Object = ray_cast_3d.get_collider()
		
		if potential_object and potential_object is Node:
			interaction_component = potential_object.get_node_or_null(NameOfInteractionComponentNode)
			if !interaction_component:
				changeReticle(default_reticle)
				return
			else:
				if interaction_component.can_interact == false:
					changeReticle(default_reticle)
					return
				
				last_potential_object = current_object
				changeReticle(can_interact_reticle)
				
				if Input.is_action_just_pressed("Primary_mb"): # check if pressing the primary/left mouse button
					current_object = potential_object
					interaction_component.preInteract(hand)
					
					if interaction_component.interaction_type == interaction_component.InteractionType.DOOR:
						interaction_component.set_direction(current_object.to_local(ray_cast_3d.get_collision_point()))
		else:
			changeReticle(default_reticle)
	

func isCameraLocked() -> bool:
	if !interaction_component:
		return false
	else:
		if interaction_component.lock_camera and interaction_component.is_interacting:
			return true
	
	return false

func changeReticle(reticleToggleVis: TextureRect) -> void:
	for child in control.get_children():
		child.visible = false
	reticleToggleVis.visible = true
