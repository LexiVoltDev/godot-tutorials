# Godot 4.8 beta 1: live fuzzy item search with FuzzySearch.
# Scene: Control (root, this script) > VBoxContainer > LineEdit "SearchBox", ItemList "Results".
extends Control

const ITEMS: PackedStringArray = [
	"Potion of Healing", "Greater Health Potion", "Poison Vial",
	"Iron Sword", "Fire Staff", "Frost Bow",
]

# 1. Create one FuzzySearch and reuse it.
var _fuzzy := FuzzySearch.new()

@onready var _search_box: LineEdit = %SearchBox
@onready var _results: ItemList = %Results


func _ready() -> void:
	# 2. Tune it once: cap results, keep weak typo matches.
	_fuzzy.max_results = 20
	_fuzzy.filter_low_scores = false
	_search_box.text_changed.connect(_on_search_changed)
	_on_search_changed("")


func _on_search_changed(query: String) -> void:
	_results.clear()
	# 3. Empty query returns nothing, so show everything.
	if query.strip_edges().is_empty():
		for item_name: String in ITEMS:
			_results.add_item(item_name)
		return
	# 4. Search all names; results come back best match first.
	for hit: FuzzySearchMatch in _fuzzy.search_all(query, ITEMS):
		var row: int = _results.add_item(hit.target)
		# 5. original_index points back to your real data.
		_results.set_item_metadata(row, hit.original_index)
		_results.set_item_tooltip(row, "score %d" % hit.score)
