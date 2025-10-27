#|*******************************************************************
# card_mc.gd
#*******************************************************************
# This file is part of g_flashcards.
# 
# g_flashcards is an open-source software library.
# g_flashcards is licensed under the MIT license.
# https://github.com/gammasynth/g_flashcards
#*******************************************************************
# Copyright (c) 2025 AD - present; 1447 AH - present, Gammasynth.  
# 
# Gammasynth
# 
# Gammasynth (Gammasynth Software), Texas, U.S.A.
# https://gammasynth.com
# https://github.com/gammasynth
# 
# This software is licensed under the MIT license.
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# 
#|*******************************************************************
extends MarginContainer
class_name CardMC

signal card_placed
signal card_flipped
signal card_pushed

@export var base: Control
@export var card_content: Control
@export var card_content_back: Control

var card_test_scene:CardTestDMC

var touchable:bool = false
var flipped:bool = false
var flip_tween:Tween
var actual_size:Vector2

func _ready() -> void:
	card_content.visible = true
	card_content_back.visible = false
	await get_tree().create_timer(0.2).timeout
	actual_size = base.size
	touchable = true
	card_placed.emit()

func do_flip_tween(to_x:float, next:Callable) -> void:
	if flip_tween and is_instance_valid(flip_tween): flip_tween.kill()
	flip_tween = create_tween().set_parallel()
	flip_tween.tween_property(base, "size", Vector2(to_x, actual_size.y), 0.15)
	flip_tween.tween_callback(next).set_delay(0.15)

func flip() -> void: do_flip_tween(0.0, continue_flip)

func continue_flip() -> void: do_flip_tween(actual_size.x, finish_flip)

func finish_flip() -> void:
	flipped = true
	card_content.visible = false
	card_content_back.visible = true
	card_flipped.emit()

func try_push_card() -> void: 
	if not flipped: flip()
	else: push_card()

func push_card() -> void: 
	card_pushed.emit()
	card_test_scene.push_card(self)

func _on_gui_input(event: InputEvent) -> void: 
	if not touchable or event.is_echo() or not event.is_pressed(): return
	if event is InputEventMouseButton or event is InputEventScreenTouch: return try_push_card()
