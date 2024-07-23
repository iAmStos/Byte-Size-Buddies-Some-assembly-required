extends CharacterBody2D

class_name  Bot

@export var health : int = 10
@export var movement_speed : int = 200
@export var melle_damage : int = 3
@export var attack_speed : float = 1
@export var controller : NodePath = ""
@export var cost : int = 1
@export var player_controlled = false
@export var scrap: int = 0
@export var mining_value: int = 1
@export var mining_speed: int = 2

@onready var health_bar = get_node("TextureProgressBar")

signal bot_signal()

func _ready():
	health_bar.max_value = float(health)
	health_bar.value = float(health)
	var game_manager = get_tree().root.get_child(0)
	var _error = bot_signal.connect(game_manager.update_objectives)

func take_damage(damage):
	health -= damage
	health_bar.value = float(health)
	if health <= 0:
		die()
		
func die():
	if not player_controlled:
		emit_signal("bot_signal", "enemy", 1)
	$Area2D.monitoring = false
	call_deferred("queue_free")

func update_sprite(playerControlled):
	if playerControlled == false:
		$Sprite2D.texture = load("res://Sprites/Mining Robot Evil.png")
