// Arazi: taranmış çamur dokusu üstüne kırağı lekeleri (köşe rengi .r = kırağı maskesi).
// Döşeme tekrarı iki farklı ölçekte örneklenip karıştırılarak kırılır. Tasarım: design/gdd/kapi-manzarasi.md
shader_type spatial;

uniform sampler2D camur_renk : source_color, filter_linear_mipmap_anisotropic, repeat_enable;
uniform sampler2D camur_normal : hint_normal, filter_linear_mipmap_anisotropic, repeat_enable;
uniform sampler2D camur_kaba : hint_roughness_r, filter_linear_mipmap_anisotropic, repeat_enable;
uniform sampler2D kar_renk : source_color, filter_linear_mipmap_anisotropic, repeat_enable;
uniform sampler2D kar_normal : hint_normal, filter_linear_mipmap_anisotropic, repeat_enable;
uniform sampler2D kar_kaba : hint_roughness_r, filter_linear_mipmap_anisotropic, repeat_enable;
// Dokunun dünyada kapladığı boy (m) ve kırağının ne kadar yaygın olduğu.
uniform float boy = 3.5;
uniform float kar_esik = 0.5;
uniform vec3 ton : source_color = vec3(0.85, 0.82, 0.8);

varying vec3 dunya;

void vertex() {
	dunya = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	vec2 uv = dunya.xz / boy;
	vec2 uv2 = dunya.zx / (boy * 2.7) + vec2(0.31, 0.77);
	vec3 c1 = texture(camur_renk, uv).rgb;
	vec3 c2 = texture(camur_renk, uv2).rgb;
	vec3 camur = mix(c1, c2, 0.4) * ton;
	float leke = texture(kar_renk, dunya.xz / 9.0).r;
	float m = smoothstep(kar_esik - 0.12, kar_esik + 0.12, COLOR.r + (leke - 0.5) * 0.6);
	vec3 kar = texture(kar_renk, uv * 1.3).rgb * vec3(0.78, 0.82, 0.9);
	ALBEDO = mix(camur, kar, m * 0.85);
	NORMAL_MAP = mix(texture(camur_normal, uv).rgb, texture(kar_normal, uv * 1.3).rgb, m);
	NORMAL_MAP_DEPTH = 1.4;
	ROUGHNESS = mix(texture(camur_kaba, uv).r, texture(kar_kaba, uv * 1.3).r * 0.7, m);
}
