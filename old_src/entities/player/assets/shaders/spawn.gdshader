shader_type spatial;
render_mode depth_draw_always, cull_disabled;

// Parameters that will be filled by the script
uniform vec4 albedo : source_color = vec4(1.0);
uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;

// Wireframe Parameters
uniform vec4 wire_color : source_color = vec4(0.0, 1.0, 1.0, 1.0);
uniform float grid_size = 20.0;
uniform float line_width = 0.08;

global uniform float player_spawn_height;

void fragment() {
    float world_y = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).y;
    float player_feet_y = MODEL_MATRIX[3].y;
    float current_spawn_y = player_feet_y + player_spawn_height;

    // Grid logic
    vec2 uv_grid = abs(fract(UV * grid_size - 0.5) - 0.5);
    float line_mask = 1.0 - smoothstep(0.0, line_width, min(uv_grid.x, uv_grid.y));

    if (world_y < current_spawn_y) {
        // Render Original Look
        vec4 tex = texture(texture_albedo, UV);
        ALBEDO = albedo.rgb * tex.rgb;
        ALPHA = tex.a * albedo.a;
    } else {
        // Render Wireframe Look
        ALBEDO = wire_color.rgb;
        EMISSION = wire_color.rgb * 2.0;
        ALPHA = line_mask * wire_color.a;
    }
    ALPHA_SCISSOR_THRESHOLD = 0.1;
}