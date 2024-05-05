extends CharacterBody2D

class_name  Bot

@export var health : int = 3
@export var movement_speed : int = 200
@export var melle_damage : int = 1
@export var attack_speed : float = 1
@export var controller : NodePath = ""
@export var cost : int = 1
@export var player_controlled = false

@onready var health_bar = get_node("TextureProgressBar")

func _ready():
	health_bar.max_value = float(health)
	health_bar.value = float(health)


func take_damage(damage):
	health -= damage
	health_bar.value = float(health)
	if health <= 0:
		die()
		
func die():
	$Area2D.monitoring = false
	call_deferred("queue_free")
