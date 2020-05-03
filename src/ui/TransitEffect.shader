shader_type canvas_item;
render_mode unshaded;

uniform float line;
uniform float zoom = 1;
uniform vec3 bg_color;
uniform bool is_enter;

const float PI = 3.141592;

float plot(vec2 st, float pct){
  return  smoothstep( pct-0.02, pct, st.y) -
          smoothstep( pct, pct+0.02, st.y);
}

bool is_even_px(float x) {
	return mod(floor(x / zoom), 2.0) == 0.0;
}

void fragment() {
	float l = (1.0 - (line + 1.0) ) / 2.0;
	vec2 st = UV;
	float x = UV.x;
	float y = smoothstep(0.3, 0.7, x + l);
	if (is_enter) {
		y = 1.0 - y;
	}
	
	// COLOR = vec3(1.0 - y);
	// COLOR = vec4(color, y);
	
	float xc = FRAGCOORD.x;
	float yc = FRAGCOORD.y;
		
	if (step(0.7, y) > 0.7) {
		COLOR = vec4(bg_color, 1.0);
	} else if (step(0.62, y) > 0.62) {
		if (is_even_px(xc)) {
			if (is_even_px(yc)) {
				COLOR = vec4(bg_color, 0.0);
			} else {
				COLOR = vec4(bg_color, 1.0);
			}
		} else {
			COLOR = vec4(bg_color, 1.0);
		}
	} else if (step(0.54, y) > 0.54) {
		// float yc = UV.y * 1000.0;
		//if (mod(floor(FRAGCOORD.y), 2) == 0.0) {
		if (is_even_px(xc)) {
			if (is_even_px(yc)) {
				COLOR = vec4(bg_color, 0.0);
			} else {
				COLOR = vec4(bg_color, 1.0);
			}
		} else {
			if (is_even_px(yc)) {
				COLOR = vec4(bg_color, 1.0);
			} else {
				COLOR = vec4(bg_color, 0.0);	
			}
		}
	} else if (step(0.46, y) > 0.46) {
		if (is_even_px(xc)) {
			if (is_even_px(yc)) {
				COLOR = vec4(bg_color, 0.0);
			} else {
				COLOR = vec4(bg_color, 1.0);
			}
		} else {
			COLOR = vec4(bg_color, 0.0);
		}
	} else {
		COLOR = vec4(bg_color, 0.0);
	}
}