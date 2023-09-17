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
uniform float uLightFadeSize;
uniform float uLightSpotSharpness;

uniform sampler2D uDepthBuffer;
uniform vec3 uCameraPosition;

uniform int uBlurQuality;
uniform float uBlurSize;

uniform float uBleedLight;

varying vec3 vPosition;
varying vec3 vNormal;
varying vec2 vTexCoord;
varying vec4 vScreenCoord;
varying float vBrightness;
varying float vLightBleed;

float SchlickFresnel(float u) {
    float m = clamp(1.0-u, 0.0, 1.0);
    float m2 = m*m;
    return m2*m2*m; // pow(m,5)
}


float unpackDepth(vec4 c)
{
	return c.r + c.g / 255.0 + c.b / (255.0 * 255.0);
}

void main() 
{
	vec3 light;
	float shadow2;
	if (uIsSky > 0)
		light = vec3(1.0);
	else
	{
		float dif = 0.0;
		float shadow = 0.0;
		
		// Check if not behind the spot light
		if (vScreenCoord.w > 0.0)
		{
			// Diffuse factor
			dif = max(0.0, dot(normalize(vNormal), normalize(uLightPosition - vPosition)));
			dif = clamp(dif + min(1.0, vLightBleed + uBleedLight), 0.0, 1.0);
			
			// Attenuation factor
			dif *= 1.0 - clamp((distance(vPosition, uLightPosition) - uLightFar * (1.0 - uLightFadeSize)) / (uLightFar * uLightFadeSize), 0.0, 1.0);
		
			if (dif > 0.0 && vBrightness < 1.0)
			{
				float fragDepth = min(vScreenCoord.z, uLightFar);
				vec2 fragCoord = (vec2(vScreenCoord.x, -vScreenCoord.y) / vScreenCoord.z + 1.0) / 2.0;
			
				// Texture position must be valid
				if (fragCoord.x > 0.0 && fragCoord.y > 0.0 && fragCoord.x < 1.0 && fragCoord.y < 1.0)
				{
					// Blur size(Increase if there's light bleeding)
					float blurSize = uBlurSize + (.2 * min(1.0, vLightBleed + uBleedLight));
					
					// Create circle
					dif *= 1.0 - clamp((distance(fragCoord, vec2(0.5, 0.5)) - 0.5 * uLightSpotSharpness) / (0.5 * max(0.01, 1.0 - uLightSpotSharpness)), 0.0, 1.0);
					//shadow2 =1.0 - clamp((distance(fragCoord, vec2(0.5, 0.5)) - 0.5 * uLightSpotSharpness) / (0.5 * max(0.01, 1.0 - uLightSpotSharpness)), 0.0, 1.0);
					// Calculate bias
					float bias = 0.1 * (uLightFar / fragDepth);
				
					// Calculate sample size
					float sampleSize = uBlurSize / fragDepth;
				
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
							shadow += ((fragDepth - bias) > sampleDepth) ? 1.0 : 0.0;
						}
						else
							break;
					}
				
					shadow /= float(uBlurQuality);
				
				} 
				else
					dif = 0.0;
					
			}
			shadow2 = dif;
		}
	
		// Calculate light
		if (uIsWater == 1)
			light = uLightColor.rgb * dif;
		else
			light = uLightColor.rgb * dif * (1.0 - shadow);
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
	vec3 diffuse3 = Fd * baseColor.xyz / PI;
	gl_FragColor = vec4(light+diffuse3*(shadow2/2.0), uBlendColor.a * baseColor.a);
	
	if (gl_FragColor.a == 0.0)
		discard;
}
