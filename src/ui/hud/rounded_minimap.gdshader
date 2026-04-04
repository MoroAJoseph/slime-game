shader_type canvas_item;

uniform vec4 bg_color : source_color = vec4(0.0, 0.0, 0.0, 0.5); 
uniform float feather : hint_range(0.0, 0.1) = 0.01;

void fragment() {
    float dist = distance(UV, vec2(0.5));
    
    // Sample the Viewport texture
    vec4 tex_color = texture(TEXTURE, UV);
    
    // Create the mask (0.5 is the edge)
    float mask = smoothstep(0.5, 0.5 - feather, dist);
    
    // MIXING LOGIC:
    // If the viewport texture is transparent (alpha ~ 0), show bg_color.
    // Otherwise, show the viewport texture.
    vec4 final_color = mix(bg_color, tex_color, tex_color.a);
    
    // Apply the circular clipping to everything
    COLOR = vec4(final_color.rgb, final_color.a * mask);
}