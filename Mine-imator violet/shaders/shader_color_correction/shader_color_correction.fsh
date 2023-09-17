varying vec2 vTexCoord;

uniform float uContrast;
uniform float uBrightness;
uniform float uSaturation;
uniform float uVibrance;
uniform vec4 uColorBurn;
uniform float uTemperature;

const lowp vec3 warmFilter =vec3(0.93,0.54,0.0);
const mediump mat3 RGBtoYIQ = mat3(0.299, 0.587, 0.114, 0.596, -0.274, -0.322, 0.212, -0.523, 0.311);
const mediump mat3 YIQtoRGB = mat3(1.0, 0.956, 0.621, 1.0, -0.272, -0.647, 1.0, -1.105, 1.702);
const mediump vec3 luminanceWeighting = vec3(0.2125,0.7154,0.0721);

vec3 transfer(float value)
{
    const float a = 64.0, b = 85.0, scale = 1.785;
    vec3 result;
    float i = value * 255.0;
    float shadows = clamp ((i - b) / -a + 0.5, 0.0, 1.0) * scale;
    float midtones = clamp ((i - b) /  a + 0.5, 0.0, 1.0) * clamp ((i + b - 255.0) / -a + .5, 0.0, 1.0) * scale;
    float highlights = clamp (((255.0 - i) - b) / -a + 0.5, 0.0, 1.0) * scale;
    result.r = shadows;
    result.g = midtones;
    result.b = highlights;
    return result;
}

vec4 rgbtohsb(vec4 c)
{
	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
	vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

	float d = q.x - min(q.w, q.y);
	float e = 1.0e-10;
	return vec4(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x, c.a);
}

vec3 rgb2hsl(vec3 color){
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(color.bg, K.wz), vec4(color.gb, K.xy), step(color.b, color.g));
    vec4 q = mix(vec4(p.xyw, color.r), vec4(color.r, p.yzx), step(p.x, color.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}


vec3 ACESToneMapping(vec3 color, float adapted_lum) 
{
	const float A = 2.51;
	const float B = 0.03;
	const float C = 2.43;
	const float D = 0.59;
	const float E = 0.14;
	color *= adapted_lum;
	return (color * (A * color + B)) / (color * (C * color + D) + E);
}

vec3 hsl2rgb(vec3 color)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(color.xxx + K.xyz) * 6.0 - K.www);
    return color.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), color.y);
}

vec3 gammaCorrect(vec3 color,float gamma){
	return pow(color,vec3(1.0/gamma));
}



void main()
{
	// Get base
	vec4 baseColor = texture2D(gm_BaseTexture, vTexCoord);
	

	
	
	
	// Brightness and contrast
	//baseColor.rgb = (baseColor.rgb - vec3(0.5)) * vec3(uContrast) + vec3(uBrightness + 0.5);
	//Obsolete old algorithm
	baseColor.rgb = gammaCorrect(baseColor.rgb,0.45);
	
	//-baseColor.rgb = ACESToneMapping(baseColor.rgb,1.0);
	if(uBrightness>0.0)
	{
		baseColor.rgb = baseColor.rgb + baseColor.rgb * (1.0/(1.0-uBrightness)-1.0);
	}
	else
	{
		baseColor.rgb = baseColor.rgb + baseColor.rgb * uBrightness;
	}
	baseColor.rgb = gammaCorrect(baseColor.rgb,2.2);
	baseColor.rgb = (baseColor.rgb - vec3(0.5)) * vec3(uContrast) + vec3(0.5);
	baseColor.rgb = clamp(baseColor.rgb, vec3(0.0), vec3(1.0));
	
	// Saturation
	vec3 W = vec3(0.2125, 0.7154, 0.0721);
	vec3 satIntensity = vec3(dot(baseColor.rgb, W));
	baseColor.rgb = mix(satIntensity, baseColor.rgb, uSaturation);
	baseColor.rgb = clamp(baseColor.rgb, vec3(0.0), vec3(1.0));
	
	// Vibrance(Saturates desaturated colors)
	satIntensity = vec3(dot(baseColor.rgb, W));
	float sat = rgbtohsb(baseColor).g;
	float vibrance = 1.0 - pow(pow(sat, 8.0), .15);
	baseColor.rgb = mix(satIntensity, baseColor.rgb, 1.0 + (vibrance * uVibrance));
	baseColor.rgb = clamp(baseColor.rgb, vec3(0.0), vec3(1.0));
	

	// Color burn
	baseColor.rgb = 1.0 - (1.0 - baseColor.rgb) / uColorBurn.rgb; 
	
	//color temperature
	mediump vec3 yiq = RGBtoYIQ * baseColor.rgb;
	yiq.b = clamp(yiq.b,-0.5226,0.5226);
	lowp vec3 RGB = YIQtoRGB * yiq;
	lowp float A = (RGB.r <0.5? (2.0* RGB.r * warmFilter.r) : (1.0-2.0* (1.0 - RGB.r) * (1.0- warmFilter.r)));
	lowp float B = (RGB.g <0.5? (2.0* RGB.g * warmFilter.g) : (1.0-2.0* (1.0 - RGB.g) * (1.0- warmFilter.g)));
	lowp float C = (RGB.b <0.5? (2.0* RGB.b * warmFilter.b) : (1.0-2.0* (1.0 - RGB.b) * (1.0- warmFilter.b)));
	lowp vec3 processed = vec3(A,B,C);
	
	//color balance
	

	vec4 base2 = vec4(mix(RGB, processed,uTemperature), baseColor.a);
	
	
	float cyan_red_shadow=0.0;
	float cyan_red_midtones=0.0;
	float cyan_red_highlights=0.0;

	float magenta_green_shadow=0.0;
	float magenta_green_midtones=0.0;                  //左边这些变量全都要写成控件
	float magenta_green_highlights=0.0;

	float yellow_blue_shadow=0.0;
	float yellow_blue_midtones=0.0;
	float yellow_blue_highlights=0.0;

	
	vec3 hsl = rgb2hsl(base2.rgb);
    vec3 weight_r = transfer(base2.r);
    vec3 weight_g = transfer(base2.g);
    vec3 weight_b = transfer(base2.b);
    vec3 color = vec3(base2.rgb * 255.0);
    color.r += cyan_red_shadow * weight_r.r;
    color.r += cyan_red_midtones * weight_r.g;
    color.r += cyan_red_highlights * weight_r.b;

    color.g += magenta_green_shadow * weight_g.r;
    color.g += magenta_green_midtones * weight_g.g;
    color.g += magenta_green_highlights * weight_g.b;

    color.b += yellow_blue_shadow * weight_b.r;
    color.b += yellow_blue_midtones * weight_b.g;
    color.b += yellow_blue_highlights * weight_b.b;



    color.r = clamp(color.r, 0.0, 255.0);
    color.g = clamp(color.g, 0.0, 255.0);
    color.b = clamp(color.b, 0.0, 255.0);

    vec3 hsl2 = rgb2hsl(color / 255.0);
	//hsl2.z = hsl.z*(-2.0*hsl.z+3.0);     //这里加个可选开启的控件吧
    //hsl2.z = hsl.z;

    gl_FragColor=vec4(hsl2rgb(hsl2), base2.a);
	
}


//HSL brightness adjustment(Replaceable)
/*void main()
{
	vec4 baseColor = texture2D(gm_BaseTexture, vTexCoord);
	
	//Convert the RGB value in the range of 0-1 to 0-255
	float r = baseColor.r * 255.0;
	float g = baseColor.g * 255.0;
	float b = baseColor.b * 255.0;
	
	//float L=((max(r,max(g,b))+min(r,min(g,b)))/2.0);
	//Another brightness calculation formula(Replaceable)
	float L=0.3*r+0.6*g+0.1*b;
	float rHS = 0.0;
	float gHS = 0.0;
	float bHS = 0.0;
	
	if(L > 128.0)
	{
		rHS = (r * 128.0 - (L - 128.0) * 256.0) / (256.0 - L);
        gHS = (g * 128.0 - (L - 128.0) * 256.0) / (256.0 - L);
        bHS = (b * 128.0 - (L - 128.0) * 256.0) / (256.0 - L);
	}
	else
	{
		rHS = r * 128.0 / L;
        gHS = g * 128.0 / L;
        bHS = b * 128.0 / L;
    }
	
	float delta = uBrightness*256.0;
    float newL = L + delta - 128.0;
    float newR = .0;
    float newG = .0;
    float newB = .0;
	
    if(newL > 0.0) {
        newR = rHS + (256.0 - rHS) * newL / 128.0;
        newG = gHS + (256.0 - gHS) * newL / 128.0;
        newB = bHS + (256.0 - bHS) * newL / 128.0;
    } else {
        newR = rHS + rHS * newL / 128.0;
        newG = gHS + gHS * newL / 128.0;
        newB = bHS + bHS * newL / 128.0;
		
    }
	baseColor.rgb =vec3(newR/255.0, newG/255.0, newB/255.0);
	baseColor.rgb = (baseColor.rgb - vec3(0.5)) * vec3(uContrast) + vec3(0.5);
	baseColor.rgb = clamp(baseColor.rgb, vec3(0.0), vec3(1.0));
	
	vec3 W = vec3(0.2125, 0.7154, 0.0721);
	vec3 satIntensity = vec3(dot(baseColor.rgb, W));
	baseColor.rgb = mix(satIntensity, baseColor.rgb, uSaturation);
	baseColor.rgb = clamp(baseColor.rgb, vec3(0.0), vec3(1.0));
	
	satIntensity = vec3(dot(baseColor.rgb, W));
	float sat = rgbtohsb(baseColor).g;
	float vibrance = 1.0 - pow(pow(sat, 8.0), .15);
	baseColor.rgb = mix(satIntensity, baseColor.rgb, 1.0 + (vibrance * uVibrance));
	baseColor.rgb = clamp(baseColor.rgb, vec3(0.0), vec3(1.0));
	
	baseColor.rgb = 1.0 - (1.0 - baseColor.rgb) / uColorBurn.rgb; 
	
	gl_FragColor = baseColor;
}


//HSL brightness adjustment(Replaceable)
/*void main()
{
	vec4 baseColor = texture2D(gm_BaseTexture, vTexCoord);
	
	//Convert the RGB value in the range of 0-1 to 0-255
	float r = baseColor.r * 255.0;
	float g = baseColor.g * 255.0;
	float b = baseColor.b * 255.0;
	
	//float L=((max(r,max(g,b))+min(r,min(g,b)))/2.0);
	//Another brightness calculation formula(Replaceable)
	float L=0.3*r+0.6*g+0.1*b;
	float rHS = 0.0;
	float gHS = 0.0;
	float bHS = 0.0;
	
	if(L > 128.0)
	{
		rHS = (r * 128.0 - (L - 128.0) * 256.0) / (256.0 - L);
        gHS = (g * 128.0 - (L - 128.0) * 256.0) / (256.0 - L);
        bHS = (b * 128.0 - (L - 128.0) * 256.0) / (256.0 - L);
	}
	else
	{
		rHS = r * 128.0 / L;
        gHS = g * 128.0 / L;
        bHS = b * 128.0 / L;
    }
	
	float delta = uBrightness*256.0;
    float newL = L + delta - 128.0;
    float newR = .0;
    float newG = .0;
    float newB = .0;
	
    if(newL > 0.0) {
        newR = rHS + (256.0 - rHS) * newL / 128.0;
        newG = gHS + (256.0 - gHS) * newL / 128.0;
        newB = bHS + (256.0 - bHS) * newL / 128.0;
    } else {
        newR = rHS + rHS * newL / 128.0;
        newG = gHS + gHS * newL / 128.0;
        newB = bHS + bHS * newL / 128.0;
		
    }
	baseColor.rgb =vec3(newR/255.0, newG/255.0, newB/255.0);
	baseColor.rgb = (baseColor.rgb - vec3(0.5)) * vec3(uContrast) + vec3(0.5);
	baseColor.rgb = clamp(baseColor.rgb, vec3(0.0), vec3(1.0));
	
	vec3 W = vec3(0.2125, 0.7154, 0.0721);
	vec3 satIntensity = vec3(dot(baseColor.rgb, W));
	baseColor.rgb = mix(satIntensity, baseColor.rgb, uSaturation);
	baseColor.rgb = clamp(baseColor.rgb, vec3(0.0), vec3(1.0));
	
	satIntensity = vec3(dot(baseColor.rgb, W));
	float sat = rgbtohsb(baseColor).g;
	float vibrance = 1.0 - pow(pow(sat, 8.0), .15);
	baseColor.rgb = mix(satIntensity, baseColor.rgb, 1.0 + (vibrance * uVibrance));
	baseColor.rgb = clamp(baseColor.rgb, vec3(0.0), vec3(1.0));
	
	baseColor.rgb = 1.0 - (1.0 - baseColor.rgb) / uColorBurn.rgb; 
	
	gl_FragColor = baseColor;
	
}*/
