# 2D Dissolve Shader (Godot 4.8 beta 1)

From the Lexi Volt Godot tutorial on making sprites burn away with noise. Video coming soon.

## What it shows

Three cards. Press **Space** and each one burns away from the inside, with a glowing orange
edge right before it goes. A noise texture gives every pixel its own burn time, one
`progress` value slides from 0 to 1, and a tween drives it from code.

## Godot version

Tested on **Godot 4.8 beta 1** (4.8.beta1.official.4d10419ca) and 4.3 stable, Compatibility
renderer. The shader uses nothing renderer-specific. 4.8 is a beta.

## How to run

1. Open Godot 4.8 beta 1 (4.3 or newer also works).
2. In the Project Manager, click **Import** and pick `dissolve-shader/project.godot`.
3. Press **Play** (F5), then press **Space** to burn the next card, left to right.

## What to look for

- Each card burns in 1.2 s (`burn_time` in the Inspector), then is freed.
- Select a card (with the game stopped) and drag the material's `progress` to scrub the burn.
- Change the FastNoiseLite **Frequency**: low gives big chunks, high fizzes.

## Files

- `dissolve.gdshader`: the shader (steps 1 to 5 match the video).
- `burn.gd`: on each card; duplicates its material and tweens `progress` (step 6).
- `main.gd`: demo input only. Space burns the next card.
- `main.tscn`: the scene. All three cards share one ShaderMaterial on purpose; `burn.gd` duplicates it in `_ready`.

## The code

```glsl
shader_type canvas_item;

// 1. The knobs: a noise map, how far the burn has gone, and the glowing edge.
uniform sampler2D noise_tex : repeat_enable;
uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform float edge_width : hint_range(0.0, 0.2) = 0.06;
uniform vec4 edge_color : source_color = vec4(1.0, 0.45, 0.1, 1.0);

void fragment() {
	// 2. Read the noise. Each pixel gets its own burn time from 0 to 1.
	float n = texture(noise_tex, UV).r;
	// 3. Stretch progress so 0 shows everything and 1 hides everything.
	float p = progress * (1.0 + 2.0 * edge_width) - edge_width;
	// 4. Cut: keep only pixels whose burn time hasn't come yet.
	float keep = step(p, n);
	// 5. Edge: the thin band that burns next glows.
	float edge = keep - step(p + edge_width, n);
	COLOR.rgb = mix(COLOR.rgb, edge_color.rgb, edge);
	COLOR.a *= keep;
}
```

```gdscript
extends Sprite2D

@export var burn_time: float = 1.2


func _ready() -> void:
	# Give every copy its own material, or they all burn together.
	material = material.duplicate()


func burn() -> void:
	# 6. Burn it: tween progress from 0 to 1, then free the node.
	var tween := create_tween()
	tween.tween_property(material, "shader_parameter/progress", 1.0, burn_time)
	tween.tween_callback(queue_free)
```

## Good to know

- Copies of a sprite share one material, so burning one burns them all. Duplicate it in
  `_ready` (as here) or tick **Local to Scene** on the material.
- NoiseTexture2D normalizes to exactly 0 and 1. Without the stretch in step 3, the brightest
  pixel survives at progress 1 and the darkest pixels already glow at progress 0.
- On a sprite sheet with a region, `UV` covers the whole sheet. Godot 4.5+ can remap with
  `texture(noise_tex, (UV - REGION_RECT.xy) / REGION_RECT.zw)`.

## Credits & licenses

No third-party assets. All visuals are generated in-engine (GradientTexture2D cards and a
NoiseTexture2D with FastNoiseLite). Code and scenes: Lexi Volt, MIT (see the repo [LICENSE](../LICENSE)).
