shader_type spatial;
render_mode cull_disabled, depth_prepass_alpha;

uniform vec4 albedo: source_color = vec4(0.2, 0.2, 0.2, 1.0);
uniform sampler2D albedo_texture: source_color;
uniform bool use_albedo_texture = false;
uniform float metallic: hint_range(0.0, 1.0) = 0.0;
uniform float roughness: hint_range(0.0, 1.0) = 0.5;

// Dissolve
group_uniforms dissolve;
uniform vec3 dissolve_direction = vec3(0.0, 1.0, 0.0);
uniform float dissolve_amount : hint_range(0.0, 1.0) = 0.0;
uniform float object_min = -1.0;
uniform float object_max = 1.0;
uniform bool invert_direction = false;
group_uniforms;

// Dissolve - Noise
group_uniforms dissolve.noise;
uniform sampler3D noise_texture;
uniform float noise_scale = 5.0;
uniform float noise_strength = 0.25;
group_uniforms;

// Edge Glow
group_uniforms edge_glow;
uniform vec4 edge_color_primary: source_color = vec4(1.0, 0.5, 0.0, 1.0);
uniform vec4 edge_color_secondary: source_color = vec4(1.0, 0.8, 0.0, 1.0);
uniform float edge_width = 0.05;
uniform float emission_intensity = 5.0;
group_uniforms;

// Noise Emission
group_uniforms noise_emission;
uniform bool use_noise_emission = false;
uniform sampler2D noise_emission_gradient: source_color;
uniform float noise_emission_scale = 1.0;
uniform float noise_emission_intensity = 1.0;
uniform float noise_emission_threshold: hint_range(0.0, 1.0) = 0.5;
group_uniforms;

varying vec3 world_position;

void vertex() {
	world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	vec3 direction = normalize(abs(dissolve_direction));
	float dissolve_position = world_position.x * direction.x + world_position.y * direction.y + world_position.z * direction.z;
	
	float noise_value = texture(noise_texture, world_position * noise_scale).r;
	float remapped_noise = (noise_value * 2.0 - 1.0) * noise_strength;
	float adjusted_amount = invert_direction ? (1.0 - dissolve_amount) : dissolve_amount;
	
	float cutoff_threshold = mix(object_min, object_max, adjusted_amount) + remapped_noise;
	if (invert_direction) {
		dissolve_position = -dissolve_position;
		cutoff_threshold = -cutoff_threshold;
	}
	
	float dissolve_mask = step(cutoff_threshold, dissolve_position);
	
	float edge_threshold = cutoff_threshold + edge_width;
	float edge_mask = step(edge_threshold, dissolve_position);
	float edge_distance = dissolve_position - cutoff_threshold;
	float edge_gradient = clamp(edge_distance / edge_width, 0.0, 1.0);
	vec3 edge_color = mix(edge_color_primary.rgb, edge_color_secondary.rgb, edge_gradient);
	float edge = dissolve_mask - edge_mask;
	
	vec3 noise_emission = vec3(0.0);
	if (use_noise_emission) {
		float emission_noise = texture(noise_texture, world_position * noise_emission_scale).r;
		float emission_mask = step(noise_emission_threshold, emission_noise);
		vec3 gradient_color = texture(noise_emission_gradient, vec2(emission_noise, 0.5)).rgb;
		noise_emission = gradient_color * emission_mask; 
	}
	
	vec3 base_albedo = use_albedo_texture ? texture(albedo_texture, UV).rgb : albedo.rgb;
	vec3 final_albedo = base_albedo * (1.0 - edge);
	
	ALBEDO = final_albedo.rgb;
	EMISSION = edge_color * edge * emission_intensity + noise_emission * (1.0 - edge) * noise_emission_intensity;
	ALPHA = dissolve_mask;
}
