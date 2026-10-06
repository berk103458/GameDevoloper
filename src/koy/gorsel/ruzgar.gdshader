// Rüzgârda sallanan bitki (ağaç ve çim): tepe noktaları yükseklikle orantılı salınır.
// MultiMesh örnekleri dünya konumundan faz alır; her ağaç ayrı sallanır.
shader_type spatial;
render_mode cull_disabled, diffuse_burley;

uniform sampler2D albedo_doku : source_color, filter_linear_mipmap;
uniform vec4 renk_carpani : source_color = vec4(1.0);
uniform float siddet = 0.08;
uniform float hiz = 1.4;
// Model biriminde salınımın başladığı yükseklik.
uniform float taban = 0.15;
uniform float boy = 1.0;

void vertex() {
	vec3 merkez = (MODEL_MATRIX * vec4(0.0, 0.0, 0.0, 1.0)).xyz;
	float faz = merkez.x * 0.37 + merkez.z * 0.21;
	float pay = clamp((VERTEX.y - taban) / boy, 0.0, 1.0);
	pay *= pay;
	float s = sin(TIME * hiz + faz) * 0.7 + sin(TIME * hiz * 2.3 + faz * 1.7) * 0.3;
	VERTEX.x += s * siddet * pay;
	VERTEX.z += cos(TIME * hiz * 0.8 + faz) * siddet * 0.5 * pay;
}

void fragment() {
	vec4 d = texture(albedo_doku, UV);
	ALBEDO = d.rgb * renk_carpani.rgb;
	ROUGHNESS = 0.9;
}
