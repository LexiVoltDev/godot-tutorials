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
