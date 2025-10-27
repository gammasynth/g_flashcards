#|*******************************************************************
# card_test_dmc.gd
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
extends DatabaseMarginContainer
class_name CardTestDMC

@onready var card_arc: AspectRatioContainer = $vbox/hbox_body/card_arc

var current_card:CardMC
var previous_card:CardMC

var available_cards: Array[CardMC] = []

func pick_new_card(random:bool=true) -> void:
	var new_card:CardMC
	if random: 
		new_card = available_cards.pick_random()
		available_cards.erase(new_card)
	else: new_card = available_cards.pop_front()
	push_card(new_card)

func push_card(card:CardMC=null, random:bool=true) -> void:
	var next_card:CardMC = card
	if not card or card and current_card == card: return pick_new_card(random)
	
	if current_card: 
		previous_card = current_card
		Make.fade_delete(previous_card, 0.25)
	
	current_card = next_card
	current_card.modulate = Color(0.0,0.0,0.0,0.0)
	current_card.card_test_scene = self
	await Make.child(current_card, card_arc)
	Make.fade(current_card, 0.25, false, Make.FADE_TYPES.IN)
