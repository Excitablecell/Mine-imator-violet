uniform float uThreshold;
uniform float uBrightness;

varying vec2 vTexCoord;

vec3 gammaCorrect(vec3 color,float gamma){
	return pow(color,vec3(1.0/gamma));
}

/*void main()
{
	vec4 baseColor = texture2D(gm_BaseTexture, vTexCoord);
	
	if (max(max(baseColor.r, baseColor.g), baseColor.b) > uThreshold)
		gl_FragColor = baseColor;
	else
		gl_FragColor = vec4(vec3(0.0), 1.0);
}*/

void main()
{
	vec4 baseColor = texture2D(gm_BaseTexture, vTexCoord);
	baseColor.rgb = gammaCorrect(baseColor.rgb,0.45);
	if(uBrightness>0.0)
	{
		baseColor.rgb = baseColor.rgb + baseColor.rgb * (1.0/(1.0-uBrightness)-1.0);
	}
	else
	{
		baseColor.rgb = baseColor.rgb + baseColor.rgb * uBrightness;
	}
	baseColor.rgb = gammaCorrect(baseColor.rgb,2.2);
	float brightness = 0.299*baseColor.r + 0.587*baseColor.g + 0.114*baseColor.b;
    if(brightness > uThreshold) {
       gl_FragColor = baseColor;
    }
    else
	{
		gl_FragColor = vec4(vec3(0.0), 1.0);
	}
}