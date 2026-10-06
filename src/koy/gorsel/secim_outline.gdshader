// Ters çevrilmiş kabuk (inverted hull) çerçevesi: üzerine gelinen/seçilen köylü ve yapı.
// `material_overlay` olarak verilir; model bir kez daha, normalleri boyunca şişirilip arka yüzle çizilir.
shader_type spatial;
render_mode unshaded, cull_front, depth_draw_opaque;

uniform vec4 renk : source_color = vec4(0.85, 0.68, 0.38, 1.0);
uniform float kalinlik = 0.025;

void vertex() {
	VERTEX += NORMAL * kalinlik;
}

void fragment() {
	ALBEDO = renk.rgb;
}
