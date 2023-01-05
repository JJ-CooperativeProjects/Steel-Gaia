shader_type canvas_item;
uniform sampler2D Colormap : hint_albedo;

void fragment() {
// Get the fragment location
	vec3 location = vec3(UV, 0.0);

// Get the colors from the image at specified location
	vec3 colorIn;
	float alphaIn;
	{
		vec4 TEXTURE_tex_read = texture(TEXTURE, location.xy);
		colorIn = TEXTURE_tex_read.rgb;
		alphaIn = TEXTURE_tex_read.a;
	}

// get the greyscale value through the highest of r, g, and b
	float grey;
	{
		vec3 c = colorIn;
		float max1 = max(c.r, c.g);
		float max2 = max(max1, c.b);
		grey = max2;
	}

// Read the colormap and use the greyscale value to map in the new color.
	vec3 colorOut;
	float alphaOut;
	{
		vec4 n_tex_read = texture(Colormap, vec2(grey, 0.0));
		colorOut = n_tex_read.rgb;
		alphaOut = n_tex_read.a;
	}

// Profit.
	COLOR.rgb = colorOut;
	COLOR.a = alphaIn;

}