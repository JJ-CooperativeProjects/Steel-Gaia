shader_type canvas_item;
//render_mode blend_premul_alpha;

uniform float pixelFactor: hint_range(0,50) = 5;


void fragment(){
	vec2 pixelNumber = vec2(textureSize(TEXTURE, 0)) * pixelFactor;
	vec2 pixelatedUV = round(UV * pixelNumber) / pixelNumber;
	
	vec4 pixel_color  = texture(TEXTURE, pixelatedUV);
	
	COLOR = pixel_color;
	
	
}


