shader_type spatial;

uniform vec3 albedo : source_color;
uniform vec3 albedo2 : source_color;
uniform float metallic : hint_range(0.0, 1.0) = 0;
uniform float roughness : hint_range(0.0, 1.0) = 0.02;

uniform sampler2D texture_normal;
uniform sampler2D texture_normal2;

uniform sampler2D wave;
uniform vec2 wave_direction = vec2(2.0,0.0);
uniform vec2 wave_direction2 = vec2(0.0,1.0);

uniform float time_scale : hint_range(0.0, 0.2, 0.005) = 0.025;

uniform float height_scale = 0.15;
uniform float noise_scale = 10.0;
varying float height;
varying vec3 world_pos;

uniform float edge_scale = 0.1;
uniform float near = 0.5;
uniform float far = 100.0;
uniform vec3 edge_color : source_color;


float fresnel(float amount, vec3 normal, vec3 view)
{
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0)), amount);
}

float edge(float depth) {
	depth = 2.0 * depth - 1.0;
	return near * far / (far + depth * (near - far));
}

void vertex(){
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	height = texture(wave, world_pos.xz / noise_scale + TIME * time_scale).r;
	VERTEX.y += height * height_scale;
}

void fragment() {

	vec2 time = (TIME * wave_direction) * time_scale;
	vec2 time2 = (TIME * wave_direction2) * time_scale;
	
	vec3 normal_blend = mix(texture(texture_normal, UV + time).rgb, texture(texture_normal2,UV+ time2).rgb, 0.5);
	
	float fresnel = fresnel(5.0, NORMAL, VIEW);
	vec3 surface_color = mix(albedo, albedo2, fresnel);
	
	ALBEDO = clamp(surface_color,vec3(0.0),vec3(1.0));
	METALLIC = metallic;
	ROUGHNESS = roughness;
	NORMAL_MAP = normal_blend;
}
