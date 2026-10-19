# Fuzzy Item Search with FuzzySearch (Godot 4.8)

From the Lexi Volt Godot tutorial that aired **Fri Oct 16, 2026**. [Watch on YouTube](https://youtu.be/bAyh2PpcWsc)

## What it shows

A live, typo-tolerant item search using the new `FuzzySearch` class from Godot 4.8 beta 1. Type `helth poton` and still get *Greater Health Potion*.

## Godot version

Godot 4.8 beta 1 or newer (`FuzzySearch` is new in 4.8; beta API may change before 4.8 stable).

## How to run

1. Open Godot (4.8 beta 1 or newer).
2. In the Project Manager, click **Import** and pick `fuzzysearch/project.godot`.
3. Press **Play** (F5).

## Try it

Type into the search box. Results update on every keystroke, best match first.
Hover a result to see its score. Try `helth poton`, `bow`, or `staff`.

## Files

- `item_search.gd`: the tutorial code (one reused `FuzzySearch`, tuned once in `_ready`).
- `item_search.tscn`: Control > VBoxContainer > LineEdit `%SearchBox` + ItemList `%Results`.

## Credits & licenses

No third-party assets. Everything on screen is built from plain Godot nodes. Code, scenes: Lexi Volt, MIT (see the repo [LICENSE](../LICENSE)).
