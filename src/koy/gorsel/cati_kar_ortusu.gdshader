shader_type spatial;
render_mode blend_mix, depth_draw_never;
uniform float kar_ortusu : hint_range(0.0, 1.0) = 0.0;
uniform float yukari_esik : hint_range(0.0, 1.0) = 0.45;
varying float yukari;
void vertex() {
 yukari = normalize(MODEL_NORMAL_MATRIX * NORMAL).y;
 VERTEX += NORMAL * 0.012;
}
void fragment() {
 if (yukari <= yukari_esik || kar_ortusu <= 0.0) discard;
 ALBEDO = vec3(0.88, 0.93, 0.98);
 ALPHA = kar_ortusu * smoothstep(yukari_esik, 0.9, yukari);
 ROUGHNESS = 0.95;
}
