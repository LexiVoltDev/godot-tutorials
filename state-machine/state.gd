# state.gd: base class every state extends.
class_name State
extends Node

# 1. A state asks to leave; it never switches itself.
signal finished(next_state: StringName)

## Set by the StateMachine before anything runs.
var actor: CharacterBody2D


func enter() -> void:
	pass


func exit() -> void:
	pass


func physics_update(_delta: float) -> void:
	pass
