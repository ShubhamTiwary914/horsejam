shader_type canvas_item;

// --- CONFIGURATION ---
group_uniforms General_Appearance;
uniform highp float zoom : hint_range(0.1, 10.0) = 1.0;
uniform highp float pattern_scale : hint_range(1.0, 100.0) = 30.0;
uniform highp float spin_rotation_speed : hint_range(0.0, 10.0) = 2.0;
uniform highp float move_speed : hint_range(0.0, 20.0) = 7.0;
uniform highp vec2 offset = vec2(0.0, 0.0);
uniform highp float contrast : hint_range(0.0, 10.0) = 3.5;
uniform highp float lighting : hint_range(0.0, 1.0) = 0.4;
uniform highp float spin_amount : hint_range(0.0, 1.0) = 0.25;

group_uniforms Colors;
uniform vec4 colour_1 : source_color = vec4(0.871, 0.267, 0.231, 1.0);
uniform vec4 colour_2 : source_color = vec4(0.0, 0.42, 0.706, 1.0);
uniform vec4 colour_3 : source_color = vec4(0.086, 0.137, 0.145, 1.0);
uniform float color_intensity : hint_range(0.0, 1.0) = 1.0;

group_uniforms Advanced;
uniform highp float pixel_filter : hint_range(10.0, 1500.0) = 740.0;
uniform int iteration_count : hint_range(1, 15) = 5;
uniform bool is_rotating = false;

#define SPIN_EASE 1.0

vec4 effect(vec2 uv_in, float time_val){
	// Normalizing coordinates to be centered at (0,0) relative to the element
	highp vec2 uv = uv_in - 0.5 - offset;
	
	// Ensure aspect ratio doesn't stretch the swirl if the sprite is a rectangle
	// We use 1.0 here because we are working in normalized UV space (0 to 1)
	uv *= zoom;
	
	highp float uv_len = length(uv);

	highp float speed = (spin_rotation_speed * SPIN_EASE * 0.2);
	if(is_rotating){
		speed = time_val * speed;
	}
	speed += 302.2;
	
	highp float new_pixel_angle = (atan(uv.y, uv.x)) + speed - SPIN_EASE * 20.0 * (1.0 * spin_amount * uv_len + (1.0 - 1.0 * spin_amount));
	
	// Keeping the center fixed inside the element
	uv = vec2(uv_len * cos(new_pixel_angle), uv_len * sin(new_pixel_angle));

	uv *= pattern_scale;
	speed = time_val * (move_speed);
	highp vec2 uv2 = vec2(uv.x + uv.y);

	for(int i = 0; i < iteration_count; i++) {
		uv2 += sin(max(uv.x, uv.y)) + uv;
		uv  += 0.5 * vec2(cos(5.1123314 + 0.353 * uv2.y + speed * 0.131121), sin(uv2.x - 0.113 * speed));
		uv  -= 1.0 * cos(uv.x + uv.y) - 1.0 * sin(uv.x * 0.711 - uv.y);
	}

	highp float contrast_mod = (0.25 * contrast + 0.5 * spin_amount + 1.2);
	highp float paint_res = min(2.0, max(0.0, length(uv) * (0.035) * contrast_mod));
	highp float c1p = max(0.0, 1.0 - contrast_mod * abs(1.0 - paint_res));
	highp float c2p = max(0.0, 1.0 - contrast_mod * abs(paint_res));
	highp float c3p = 1.0 - min(1.0, c1p + c2p);
	
	highp float light_val = (lighting - 0.2) * max(c1p * 5.0 - 4.0, 0.0) + lighting * max(c2p * 5.0 - 4.0, 0.0); 
	
	highp vec4 ret_col = (0.3 / contrast) * colour_1 + (1.0 - 0.3 / contrast) * (colour_1 * c1p + colour_2 * c2p + vec4(c3p * colour_3.rgb, c3p * colour_1.a)) + light_val;
	
	return mix(vec4(0.0), ret_col, color_intensity);
}

void fragment() {
	// Pixelate UVs relative to the sprite size
	vec2 pixelated_uv = floor(UV * pixel_filter) / pixel_filter;
	
	// Get the swirl color
	vec4 swirl_color = effect(pixelated_uv, TIME);
	
	// Sample the original texture for alpha masking
	vec4 tex_color = texture(TEXTURE, UV);
	
	// Apply: Swirl Color + Original Alpha
	COLOR.rgb = swirl_color.rgb;
	COLOR.a = tex_color.a * swirl_color.a;
}