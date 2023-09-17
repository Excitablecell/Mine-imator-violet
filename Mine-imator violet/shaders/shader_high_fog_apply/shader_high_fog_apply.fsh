uniform sampler2D uFogBuffer;
uniform vec4 uFogColor;

varying vec2 vTexCoord;

void main()
{
	
	/*float alaphaSum = 0.0;
	int i = -10;
	int j = 0;
	float f = 0.0;
	float dv = 0.5/4096.0;
	float tot = 0.0;
	for(; i <= 10; ++i)
	{
		for(j = -10; j <= 10; ++j)
		{
			f = (1.1 - sqrt(float(i)*float(i) + float(j)*float(j))/8.0);
			f *= f;
			tot += f;
			alaphaSum += texture2D(uFogBuffer,vec2(vTexCoord.x + float(j) * dv, vTexCoord.y + float(i) * dv)).r * f;
		}
	}
	alaphaSum /= tot;*/

	float fog = texture2D(uFogBuffer, vTexCoord).r;
	gl_FragColor = vec4(uFogColor.rgb, fog);
	//gl_FragColor = vec4(uFogColor.rgb, alaphaSum);
}
