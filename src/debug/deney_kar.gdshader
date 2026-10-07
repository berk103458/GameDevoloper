shader_type spatial;
render_mode unshaded;
void vertex() {
	VERTEX.y += 20.0 - mod(TIME * 6.0 + INSTANCE_CUSTOM.r * 20.0, 20.0);
	VERTEX.x += sin(TIME + INSTANCE_CUSTOM.r * 17.0) * 2.0;
}
void fragment() {
	ALBEDO = vec3(0.9, 0.95, 1.0);
}
