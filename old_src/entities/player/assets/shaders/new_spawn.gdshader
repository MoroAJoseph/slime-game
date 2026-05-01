shader_type spatial;
render_mode depth_draw_always, cull_disabled, blend_mix;

uniform vec4 albedo : source_color = vec4(1.0);
uniform sampler2D texture_albedo : source_color;
uniform vec4 wire_color : source_color = vec4(0.0, 1.0, 1.0, 1.0);
uniform float grid_size = 20.0;
uniform float line_width = 0.08;
uniform float spawn_height; 

varying float v_world_y;

void vertex() {
    v_world_y = (MODEL_MATRIX * vec4(VERTEX, 1.0)).y;
}

void fragment() {
    vec4 tex = texture(texture_albedo, UV);
    vec3 base_color = albedo.rgb * tex.rgb;
    float base_alpha = albedo.a * tex.a;

    if (v_world_y < spawn_height) {
        ALBEDO = base_color;
        ALPHA = base_alpha;
    } else {
        vec2 uv = abs(fract(UV * grid_size - 0.5) - 0.5);
        float mask = 1.0 - smoothstep(0.0, line_width, min(uv.x, uv.y));
        ALBEDO = wire_color.rgb;
        EMISSION = wire_color.rgb * 2.0;
        ALPHA = mask * wire_color.a;
    }
    float edge_glow = 1.0 - smoothstep(0.0, 0.05, abs(v_world_y - spawn_height));
    ALBEDO = mix(ALBEDO, vec3(1.0), edge_glow);
    EMISSION += wire_color.rgb * edge_glow * 10.0;
}