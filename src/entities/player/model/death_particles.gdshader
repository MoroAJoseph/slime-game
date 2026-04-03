shader_type spatial;
render_mode unshaded; 

uniform vec4 color_cyan : source_color = vec4(0.0, 1.0, 1.0, 1.0);
uniform vec4 color_magenta : source_color = vec4(1.0, 0.0, 0.5, 1.0);
uniform vec4 color_yellow : source_color = vec4(1.0, 1.0, 0.0, 1.0);

varying float v_random;

void vertex() {
    // We grab a random value from the particle's custom data or index
    v_random = fract(sin(float(INSTANCE_ID)) * 43758.5453);
}

void fragment() {
    // 1. Pick a color based on the random value from vertex
    vec3 base_col = color_cyan.rgb;
    if (v_random > 0.66) {
        base_col = color_magenta.rgb;
    } else if (v_random > 0.33) {
        base_col = color_yellow.rgb;
    }

    // 2. Add a digital flicker
    float flicker = step(0.95, sin(TIME * 20.0 + v_random * 100.0));
    
    ALBEDO = base_col;
    // Boost the brightness for a "neon" look
    EMISSION = base_col * (1.0 + flicker * 5.0);
}