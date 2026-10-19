shader_type canvas_item;
// 5. Rewind look: blend the screen toward grayscale.
uniform sampler2D screen_tex : hint_screen_texture, filter_linear_mipmap;
uniform float amount : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec3 c = texture(screen_tex, SCREEN_UV).rgb;
	float g = dot(c, vec3(0.299, 0.587, 0.114));
	COLOR = vec4(mix(c, vec3(g), amount), 1.0);
}
