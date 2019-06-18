shader_type canvas_item;

uniform vec3 color = vec3(0, 0, 0);
uniform int OCTAVES = 4;

float rand(vec2 coord){
	//generate random opacity for the fog
	return fract(sin(dot(coord, vec2(56, 78)) * 1000.0) * 1000.0);
}

float noise(vec2 coord){
	vec2 i = floor(coord);
	vec2 f = fract(coord);

	// 4 corners of a rectangle surrounding our point
	float a = rand(i);
	float b = rand(i + vec2(1.0, 0.0));
	float c = rand(i + vec2(0.0, 1.0));
	float d = rand(i + vec2(1.0, 1.0));

	//change it from linear interpolation to something more smooth with cubic intorpolation
	vec2 cubic = f * f * (3.0 - 2.0 * f);

	//evil geometry maths, ask your math teacher about perlin noise or ready this https://thebookofshaders.com/13/
	return mix(a, b, cubic.x) + (c - a) * cubic.y * (1.0 - cubic.x) + (d - b) * cubic.x * cubic.y;
}

//Fractal Brownian Motion function, like a fractal generates a noise texture with infinite detail (isn't infinite but by the number of octaves because infinite recursion is, well, a bad thing)
float fbm(vec2 coord){
	float value = 0.0;
	float scale = 0.5;

	for(int i = 0; i < OCTAVES; i++){
		value += noise(coord) * scale;
		coord *= 2.0;
		scale *= 0.5;
	}
	return value;
}

//main function
void fragment() {
	vec2 coord = UV * 20.0;

	//generates the motion for the fog
	vec2 motion = vec2( fbm(coord + vec2(TIME * -0.5, TIME * 0.5)) );
	
	//final result
	float final = fbm(coord + motion);

	//sets the texture to the color you want + the FBM
	COLOR = vec4(color, final * 0.5);
}