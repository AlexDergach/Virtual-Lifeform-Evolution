shader_type spatial;

global uniform vec3 oceanpos;

uniform vec3 base_albedo : source_color;
uniform vec3 secondary_albedo : source_color;
uniform float metallic_factor : hint_range(0.0, 1.0) = 0.0;
uniform float surface_roughness : hint_range(0.0, 1.0) = 0.02;

uniform sampler2D base_normal_map;
uniform sampler2D secondary_normal_map;

uniform sampler2D wave_texture;
uniform sampler2D wave_bump_texture;
uniform vec2 primary_wave_direction = vec2(2.0, 0.0);
uniform vec2 secondary_wave_direction = vec2(0.0, 1.0);
uniform float wave_time_scale : hint_range(0.0, 0.2, 0.005) = 0.025;

uniform float height_scaling : hint_range(0.0, 1.0) = 0.15;
uniform float noise_scaling : hint_range(0.0, 50.0) = 10.0;

varying float distance_to_ocean;
varying vec2 vertex_position;
varying vec3 world_position;

void vertex() {
    world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
    
    // Calculate distance to ocean
    distance_to_ocean = length(world_position - oceanpos);
    
    
    float wave_height_mix = texture(wave_texture, (world_position.xz / noise_scaling) + (TIME * primary_wave_direction) * wave_time_scale).r;
    VERTEX.y += wave_height_mix * height_scaling * (1.0 - clamp(distance_to_ocean / 85.0, 0.0, 1.0));
}

void fragment() {
	
    // Calculate time for wave animation
    vec2 primary_wave_time = (TIME * primary_wave_direction) * wave_time_scale;
    vec2 secondary_wave_time = (TIME * secondary_wave_direction) * wave_time_scale;
    
    // Blend normal maps
    vec3 blended_normal_map = mix(texture(base_normal_map, world_position.xz / 10.0 + primary_wave_time / 10.0).rgb, 
                                   texture(secondary_normal_map, world_position.xz / 10.0 + secondary_wave_time / 10.0).rgb, 0.5);
    
    // Blend wave bump maps
    vec3 blended_wave_bump_map = mix(texture(wave_bump_texture, world_position.xz / noise_scaling + primary_wave_time).xyz,
                                      texture(wave_bump_texture, world_position.xz / noise_scaling + secondary_wave_time).xyz, 0.3);
    
    // Calculate fresnel effect
    float fresnel_effect = pow((1.0 - abs(dot(normalize(NORMAL), normalize(VIEW)))), 5.0);
    
    // Blend surface colors based on fresnel effect
    vec3 blended_surface_color = mix(base_albedo, secondary_albedo, fresnel_effect);
    
    // Output final fragment color
    ALBEDO = clamp(blended_surface_color, vec3(0.0), vec3(1.0));
    SPECULAR = blended_wave_bump_map.r;
    METALLIC = metallic_factor;
    ROUGHNESS = surface_roughness;
    NORMAL_MAP = mix(blended_wave_bump_map, blended_normal_map, 0.5);
}
