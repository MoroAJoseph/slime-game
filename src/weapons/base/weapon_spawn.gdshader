shader_type spatial;
render_mode depth_draw_always, cull_disabled, blend_mix;

// --- Camo / Weapon Data ---
uniform bool use_red_camo; uniform bool use_green_camo; uniform bool use_blue_camo;
uniform sampler2D red_camo; uniform sampler2D green_camo; uniform sampler2D blue_camo;
uniform sampler2D ao_map;
uniform vec4 red_color : source_color; uniform vec4 green_color : source_color; uniform vec4 blue_color : source_color;
uniform vec4 camo_tone_light : source_color; uniform vec4 camo_tone_dark : source_color;
uniform float camo_scale = 1.0;

// --- Spawn Data ---
uniform vec4 wire_color : source_color = vec4(0.0, 1.0, 1.0, 1.0);
uniform float grid_size = 20.0;
uniform float line_width = 0.08;
uniform float spawn_height; 

varying vec3 local_v; 
varying vec3 v_color;
varying float v_world_y;

void vertex() {
    local_v = VERTEX; 
    v_color = COLOR.rgb;
    v_world_y = (MODEL_MATRIX * vec4(VERTEX, 1.0)).y;
}

void fragment() {
    if (v_world_y < spawn_height) {
        // --- TRIPLANAR WEAPON CAMO LOGIC ---
        vec3 w = abs(NORMAL); 
        w /= (w.x + w.y + w.z);
        vec3 p = local_v * camo_scale;
        
        float r_b = texture(red_camo, p.zy).r * w.x + texture(red_camo, p.xz).r * w.y + texture(red_camo, p.xy).r * w.z;
        vec3 r_l = use_red_camo ? mix(camo_tone_dark.rgb, camo_tone_light.rgb, r_b) : red_color.rgb;
        
        float g_b = texture(green_camo, p.zy).r * w.x + texture(green_camo, p.xz).r * w.y + texture(green_camo, p.xy).r * w.z;
        vec3 g_l = use_green_camo ? mix(camo_tone_dark.rgb, camo_tone_light.rgb, g_b) : green_color.rgb;
        
        float b_b = texture(blue_camo, p.zy).r * w.x + texture(blue_camo, p.xz).r * w.y + texture(blue_camo, p.xy).r * w.z;
        vec3 b_l = use_blue_camo ? mix(camo_tone_dark.rgb, camo_tone_light.rgb, b_b) : blue_color.rgb;

        vec3 final_color = vec3(0.1); 
        final_color = mix(final_color, r_l, step(0.5, v_color.r));
        final_color = mix(final_color, g_l, step(0.5, v_color.g));
        final_color = mix(final_color, b_l, step(0.5, v_color.b));
        
        ALBEDO = final_color * texture(ao_map, UV).r;
        METALLIC = 1.0;
        ROUGHNESS = 0.5;
        ALPHA = 1.0;
    } else {
        // --- DIGITAL GRID SPAWN EFFECT ---
        vec2 uv = abs(fract(UV * grid_size - 0.5) - 0.5);
        float mask = 1.0 - smoothstep(0.0, line_width, min(uv.x, uv.y));
        ALBEDO = wire_color.rgb;
        EMISSION = wire_color.rgb * 2.0;
        ALPHA = mask * wire_color.a;
    }
    
    // Add the scanline highlight
    float edge = 1.0 - smoothstep(0.0, 0.05, abs(v_world_y - spawn_height));
    ALBEDO = mix(ALBEDO, vec3(1.0), edge);
    EMISSION += wire_color.rgb * edge * 8.0;
}