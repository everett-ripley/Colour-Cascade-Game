shader_type canvas_item;
uniform sampler2D alpha_texture;
uniform vec3 colour : source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float alpha_value = texture(alpha_texture, UV).r;
	COLOR = vec4(colour.rgb,alpha_value);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
