shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx,unshaded,world_vertex_coords;

uniform vec4 white = vec4(1, 1, 1, 1);
uniform vec4 albedo : hint_color =  vec4(1, 1, 1, 1);
uniform vec3 lightpos = vec3(4, 12, 6);
uniform vec3 lightpos2 = vec3(-4, 0, -6);
varying vec4 colorf;

void vertex() {
	float diffu1 = max(dot(NORMAL, normalize(lightpos)) + 0.45, 0.0) * 0.3;
	float diffu2 = max(dot(NORMAL, normalize(lightpos2)) + 0.4, 0.0) * 0.15;
	colorf = (white * max(diffu1, diffu2) * 2.0) + (white * 0.4);
	// light color and ambient are white
}

void fragment() {
	ALBEDO = (colorf * albedo).rgb;
}
