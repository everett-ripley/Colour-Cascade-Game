shader_type canvas_item;

uniform vec3 colour:source_color;
uniform vec2 center;
uniform float force;
uniform float size;
uniform float alpha;
uniform float thickness;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	//float ratio = SCREEN_PIXEL_SIZE.x /SCREEN_PIXEL_SIZE.y;
	//vec2 scaledUV = (UV - vec2(0.5, 0.0))/vec2(ratio, 1.0) + vec2(0.5, 0.0);
	float mask = (1.0 - smoothstep(size, size + 0.1,length(UV - center))) * smoothstep(size - thickness-0.1, size -thickness,length(UV - center));
	vec2 disp = normalize(UV - center) * force * mask;
	COLOR = texture(SCREEN_TEXTURE, SCREEN_UV - disp) + vec4(colour, 0.0);
	COLOR.a = mask * alpha;
	//COLOR.rgb = vec3(mask);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
