shader_type spatial;

// TOGGLES - MUST CHECK THESE IN THE INSPECTOR TO SEE CAMO
uniform bool use_red_camo = false;
uniform bool use_green_camo = false;
uniform bool use_blue_camo = false;

// Texture Slots
uniform sampler2D red_camo : hint_default_black;
uniform sampler2D green_camo : hint_default_black;
uniform sampler2D blue_camo : hint_default_black;
uniform sampler2D ao_map : hint_default_white;

// Fallback Colors (Used when toggle is OFF)
uniform vec4 red_color : source_color = vec4(0.1, 0.1, 0.1, 1.0);
uniform vec4 green_color : source_color = vec4(0.2, 0.2, 0.2, 1.0);
uniform vec4 blue_color : source_color = vec4(0.0, 0.0, 0.5, 1.0);

// Camo Toning (Used when toggle is ON)
uniform vec4 camo_tone_light : source_color = vec4(1.0);
uniform vec4 camo_tone_dark : source_color = vec4(0.0, 0.0, 0.0, 1.0);

uniform float camo_scale = 10.0;

varying vec3 local_v; 
varying vec3 v_color;

void vertex() {
    local_v = VERTEX; 
    v_color = COLOR.rgb;
}

void fragment() {
    // 1. Setup Triplanar Coordinates
    vec3 w = abs(NORMAL);
    w /= (w.x + w.y + w.z);
    vec3 p = local_v * camo_scale;

    // 2. Define the three possible layers
    vec3 r_layer;
    if (use_red_camo) {
        float b = texture(red_camo, p.zy).r * w.x + texture(red_camo, p.xz).r * w.y + texture(red_camo, p.xy).r * w.z;
        r_layer = mix(camo_tone_dark.rgb, camo_tone_light.rgb, b);
    } else {
        r_layer = red_color.rgb;
    }

    vec3 g_layer;
    if (use_green_camo) {
        float b = texture(green_camo, p.zy).r * w.x + texture(green_camo, p.xz).r * w.y + texture(green_camo, p.xy).r * w.z;
        g_layer = mix(camo_tone_dark.rgb, camo_tone_light.rgb, b);
    } else {
        g_layer = green_color.rgb;
    }

    vec3 b_layer;
    if (use_blue_camo) {
        float b = texture(blue_camo, p.zy).r * w.x + texture(blue_camo, p.xz).r * w.y + texture(blue_camo, p.xy).r * w.z;
        b_layer = mix(camo_tone_dark.rgb, camo_tone_light.rgb, b);
    } else {
        b_layer = blue_color.rgb;
    }

    // 3. Composite the result
    // We start with a neutral gray for any area NOT painted R, G, or B
    vec3 final_color = vec3(0.1); 

    // This layers them based on vertex color. 
    // If v_color.r is 1.0, it uses r_layer (which is either camo or red_color)
    final_color = mix(final_color, r_layer, step(0.5, v_color.r));
    final_color = mix(final_color, g_layer, step(0.5, v_color.g));
    final_color = mix(final_color, b_layer, step(0.5, v_color.b));

    // 4. AO and Output
    float ao = texture(ao_map, UV).r;
    ALBEDO = final_color * ao;
    
    METALLIC = 1.0;
    ROUGHNESS = 0.5;
}