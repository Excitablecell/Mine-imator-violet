#define PI 3.14159265
#define TAU PI * 2.0
#define MAXSAMPLES 64

uniform sampler2D uTexture;
uniform vec2 uTexScale;
uniform vec4 uBlendColor;
uniform int uIsSky;
uniform int uIsWater;

uniform vec3 uLightPosition;
uniform vec4 uLightColor;
uniform float uLightNear;
uniform float uLightFar;

uniform vec3 uCameraPosition;

uniform sampler2D uDepthBuffer;

uniform int uBlurQuality;
uniform float uBlurSize;

uniform float uDiffuseBoost;
uniform float uBleedLight;

varying vec3 vPosition;
varying float vDepth;
varying vec3 vNormal;
varying vec3 viewNormal;
varying vec3 viewPosition;
varying vec2 vTexCoord;
varying vec4 vScreenCoord;
varying float vBrightness;
varying float vLightBleed;

float SchlickFresnel(float u) {
    float m = clamp(1.0-u, 0.0, 1.0);
    float m2 = m*m;
    return m2*m2*m; // pow(m,5)
}

float rand(vec2 n) { 
	return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

float noise2D(vec2 p){
	vec2 ip = floor(p);
	vec2 u = fract(p);
	u = u*u*(3.0-2.0*u);
	
	float res = mix(
		mix(rand(ip),rand(ip+vec2(1.0,0.0)),u.x),
		mix(rand(ip+vec2(0.0,1.0)),rand(ip+vec2(1.0,1.0)),u.x),u.y);
	return res*res;
}

float phong(vec3 worldPos, vec3 cameraPos, vec3 lightPos, vec3 normal)
{
    vec3 N = normalize(normal);
    vec3 V = normalize(worldPos - cameraPos);
    vec3 L = normalize(worldPos - lightPos);
    vec3 R = reflect(L, N);
	vec3 H = normalize(V+L);
	
	
	
	float distFactor = 1.0/pow(distance(lightPos,worldPos),2.0);
    float ambient = 1.0;
    float diffuse = max(dot(-N, -L), 0.0) * 0.1;
	float diffuse2 = max(dot(N, -L), 0.0) * 0.7;
	float diffusemask = max(dot(N, -L), 0.0) * 0.7;
    float specular = pow(max(dot(N, -H), 0.0), 50.0) * 0.75;
	specular *= diffusemask;
	//float specular=pow(saturate(dot(N,H)),shiness);

	
	
	return ambient+specular;
	
}

float unpackDepth(vec4 c)
{
	return c.r + c.g / 255.0 + c.b / (255.0 * 255.0);
}




void main()
{
	vec3 light;
	
	if (uIsSky > 0)
		light = vec3(1.0);
	else
	{
		// Diffuse factor
		float dif = max(0.0, dot(normalize(vNormal), normalize(uLightPosition - vPosition)));	
		dif = clamp(dif + min(1.0, vLightBleed + uBleedLight), 0.0, 1.0);
		//dif = dot(normalize(vNormal), normalize(uLightPosition - vPosition))*0.5+0.5;
		float dif2 = 1.0-dot(normalize(vNormal), normalize(uLightPosition - vPosition));
		float shadow = 0.0;
		

	
		if (dif > 0.0 && vBrightness < 1.0)
		{
			dif *= uDiffuseBoost;
			
			float fragDepth = min(vScreenCoord.z, uLightFar);
			vec2 fragCoord = (vec2(vScreenCoord.x, -vScreenCoord.y) / vScreenCoord.z + 1.0) / 2.0;
		
			// Texture position must be valid
			if (fragCoord.x > 0.0 && fragCoord.y > 0.0 && fragCoord.x < 1.0 && fragCoord.y < 1.0)
			{
				// Blur size(Increase if there's light bleeding)
				float blurSize = uBlurSize + (.2 * min(1.0, vLightBleed + uBleedLight));
				
				// Calculate bias
				float bias = 1.0 + (uLightFar / fragDepth) * blurSize;
			
				// Calculate sample size
				float sampleSize = blurSize / fragDepth;
				
				/*float noise_use = noise2D(vPosition.xy/50.0);
				noise_use += noise2D(vPosition.xy/50.0*3.5)/3.5;
				noise_use += noise2D(vPosition.xy/50.0*12.25)/12.25;
				noise_use += noise2D(vPosition.xy/50.0*42.87)/42.87;
				noise_use /= 1.4472;*/
			
				// Find shadow
				for (int i = 0; i < MAXSAMPLES; i++)
				{
					if (i < uBlurQuality)
					{
						// Sample from circle
						float angle = (float(i) / float(uBlurQuality)) * TAU;
						vec2 off = vec2(cos(angle), sin(angle));
					
						// Get sample depth
						vec2 sampleCoord = fragCoord + off * sampleSize;
						float sampleDepth = uLightNear + unpackDepth(texture2D(uDepthBuffer, sampleCoord)) * (uLightFar - uLightNear);
					
						// Add to shadow
						shadow += ((fragDepth - bias) > sampleDepth) ? 1.0: 0.0;
						/*if(noise_use>0.4)
						{
							shadow += noise_use*noise_use;
						}*/
					}
					else
						break;
				}
			
				shadow /= float(uBlurQuality);
				
				
			}
		}
		
		float cosine = dot(normalize(viewPosition),normalize(viewNormal));
		cosine = clamp(abs(cosine),0.0,1.0);
		float waterFactor = pow(1.0-cosine,4.0);
	
		// Calculate light
		if (uIsWater == 1)
			light = mix((uLightColor.rgb *dif* phong(vPosition, uCameraPosition, uLightPosition, vNormal))*0.1,(uLightColor.rgb * dif * phong(vPosition, uCameraPosition, uLightPosition, vNormal)),waterFactor);
		else
			light = uLightColor.rgb  *dif* (1.0 - shadow) * phong(vPosition, uCameraPosition, uLightPosition, vNormal);
		
			
		light = mix(light, vec3(1.0), vBrightness);
	}
	
	// Set final color
	vec3 N = normalize(vNormal);
	vec3 V = -normalize(vPosition - uCameraPosition);
	vec3 L = normalize(vPosition - uLightPosition);
	vec3 R = reflect(L, N);
	vec3 H = normalize(V+L);
		
	float roughness = 0.8;
	
	
	float Fd90 = 0.5 + 2.0 * dot(L,H) * dot(L,H) * roughness;
	float FL = SchlickFresnel(dot(N,L));
	float FV = SchlickFresnel(dot(N,V));
	float Fd = mix(1.0, Fd90, FL) * mix(1.0, Fd90, FV);
	
	
	
	
	
	vec2 tex = vTexCoord;
	if (uTexScale.x < 1.0 || uTexScale.y < 1.0)
		tex = mod(tex * uTexScale, uTexScale); // GM sprite bug workaround
	vec4 baseColor = texture2D(uTexture, tex);
	vec3 diffuse3 = uLightColor.rgb  *Fd * baseColor.xyz / PI;
	vec4 outColor = vec4(light+diffuse3, uBlendColor.a * baseColor.a);
	
	gl_FragColor = outColor;
	if (gl_FragColor.a == 0.0)
		discard;
}
