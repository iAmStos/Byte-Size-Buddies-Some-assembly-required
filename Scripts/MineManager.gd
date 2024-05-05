extends Node2D

@onready var navmesh_agent = $NavigationAgent2D

func _ready():
	navmesh_agent.target_position = self.position
