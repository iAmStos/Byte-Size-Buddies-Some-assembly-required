extends CharacterBody2D

class_name  Bot

@export var health : int = 3
@export var movement_speed : int = 200
@export var melle_damage : int = 1
@export var attack_speed : float = 1
@export var controller : NodePath = ""
@export var cost : int = 1

func take_damage(damage):
	health -= damage
	if health < 0:
		die()
		
func die():
	call_deferred("queue_free")
