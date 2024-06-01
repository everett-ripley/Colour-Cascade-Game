shader_type canvas_item;

uniform vec3 colour1 :source_color;
uniform vec3 colour2 :source_color;
uniform vec2 direction1 = vec2(0.05, 0.05);
uniform vec2 direction2 = vec2(-0.05, -0.05);
uniform sampler2D noise1 : repeat_enable;
uniform sampler2D noise2 : repeat_enable;



void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 colour = texture(noise1, UV + direction1 * TIME).r * colour1 + texture(noise2, UV + direction2 * TIME).r * colour2;
	COLOR = vec4(colour, 1.0);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
