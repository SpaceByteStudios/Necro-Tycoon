shader_type canvas_item;

uniform sampler2D mask_texture : filter_nearest;
uniform vec4 cargo_color : source_color;

void fragment() {
	vec4 text = texture(TEXTURE, UV);
	float mask = texture(mask_texture, UV).r;
	float inv_mask = 1.0 - mask;

	COLOR = vec4(vec3(mask) * cargo_color.rgb, 1.0 * text.a) + text * inv_mask;
}
