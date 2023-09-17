uniform sampler2D uTexture;
uniform vec2 uTexScale;

uniform int uFogShow;
uniform vec4 uFogColor;
uniform float uFogDistance;
uniform float uFogSize;
uniform float uFogHeight;
uniform float uHeightFogStart;
uniform float uHeightFogEnd;
uniform float uDensity_Decrease;

uniform float uNoiseThreshold;
uniform float uVFogBottom;
uniform float uVFogTop;
uniform float uVFogWide;

uniform float uLightNear;
uniform float uLightFar;

uniform vec3 uCameraPosition;

varying vec3 vPosition;
varying vec4 vColor;
varying vec2 vTexCoord;
varying float vDepth;
varying vec3 wPosition;
varying mat4 view;
varying mat4 projection;

uniform float uOffx;
uniform float uOffy;
uniform float uOffz;

uniform float uVFogDensity;
uniform float uVFogPositionX;
uniform float uVFogPositionY;
uniform float uVFogPositionZ;

uniform float uVFogSize;

vec4 permute(vec4 x){return mod(((x*34.0)+1.0)*x, 289.0);}
vec4 taylorInvSqrt(vec4 r){return 1.79284291400159 - 0.85373472095314 * r;}
vec3 fade(vec3 t) {return t*t*t*(t*(t*6.0-15.0)+10.0);}


float permute(float x){return floor(mod(((x*34.0)+1.0)*x, 289.0));}



vec4 grad4(float j, vec4 ip){
  const vec4 ones = vec4(1.0, 1.0, 1.0, -1.0);
  vec4 p,s;

  p.xyz = floor( fract (vec3(j) * ip.xyz) * 7.0) * ip.z - 1.0;
  p.w = 1.5 - dot(abs(p.xyz), ones.xyz);
  s = vec4(lessThan(p, vec4(0.0)));
  p.xyz = p.xyz + (s.xyz*2.0 - 1.0) * s.www; 

  return p;
}

float snoise(vec4 v){
  const vec2  C = vec2( 0.138196601125010504,  // (5 - sqrt(5))/20  G4
                        0.309016994374947451); // (sqrt(5) - 1)/4   F4
// First corner
  vec4 i  = floor(v + dot(v, C.yyyy) );
  vec4 x0 = v -   i + dot(i, C.xxxx);

// Other corners

// Rank sorting originally contributed by Bill Licea-Kane, AMD (formerly ATI)
  vec4 i0;

  vec3 isX = step( x0.yzw, x0.xxx );
  vec3 isYZ = step( x0.zww, x0.yyz );
//  i0.x = dot( isX, vec3( 1.0 ) );
  i0.x = isX.x + isX.y + isX.z;
  i0.yzw = 1.0 - isX;

//  i0.y += dot( isYZ.xy, vec2( 1.0 ) );
  i0.y += isYZ.x + isYZ.y;
  i0.zw += 1.0 - isYZ.xy;

  i0.z += isYZ.z;
  i0.w += 1.0 - isYZ.z;

  // i0 now contains the unique values 0,1,2,3 in each channel
  vec4 i3 = clamp( i0, 0.0, 1.0 );
  vec4 i2 = clamp( i0-1.0, 0.0, 1.0 );
  vec4 i1 = clamp( i0-2.0, 0.0, 1.0 );

  //  x0 = x0 - 0.0 + 0.0 * C 
  vec4 x1 = x0 - i1 + 1.0 * C.xxxx;
  vec4 x2 = x0 - i2 + 2.0 * C.xxxx;
  vec4 x3 = x0 - i3 + 3.0 * C.xxxx;
  vec4 x4 = x0 - 1.0 + 4.0 * C.xxxx;

// Permutations
  i = mod(i, 289.0); 
  float j0 = permute( permute( permute( permute(i.w) + i.z) + i.y) + i.x);
  vec4 j1 = permute( permute( permute( permute (
             i.w + vec4(i1.w, i2.w, i3.w, 1.0 ))
           + i.z + vec4(i1.z, i2.z, i3.z, 1.0 ))
           + i.y + vec4(i1.y, i2.y, i3.y, 1.0 ))
           + i.x + vec4(i1.x, i2.x, i3.x, 1.0 ));
// Gradients
// ( 7*7*6 points uniformly over a cube, mapped onto a 4-octahedron.)
// 7*7*6 = 294, which is close to the ring size 17*17 = 289.

  vec4 ip = vec4(1.0/294.0, 1.0/49.0, 1.0/7.0, 0.0) ;

  vec4 p0 = grad4(j0,   ip);
  vec4 p1 = grad4(j1.x, ip);
  vec4 p2 = grad4(j1.y, ip);
  vec4 p3 = grad4(j1.z, ip);
  vec4 p4 = grad4(j1.w, ip);

// Normalise gradients
  vec4 norm = taylorInvSqrt(vec4(dot(p0,p0), dot(p1,p1), dot(p2, p2), dot(p3,p3)));
  p0 *= norm.x;
  p1 *= norm.y;
  p2 *= norm.z;
  p3 *= norm.w;
  p4 *= taylorInvSqrt(vec4(dot(p4,p4)));

// Mix contributions from the five corners
  vec3 m0 = max(0.6 - vec3(dot(x0,x0), dot(x1,x1), dot(x2,x2)), 0.0);
  vec2 m1 = max(0.6 - vec2(dot(x3,x3), dot(x4,x4)            ), 0.0);
  m0 = m0 * m0;
  m1 = m1 * m1;
  return 49.0 * ( dot(m0*m0, vec3( dot( p0, x0 ), dot( p1, x1 ), dot( p2, x2 )))
               + dot(m1*m1, vec2( dot( p3, x3 ), dot( p4, x4 ) ) ) ) ;

}


float cnoise(vec3 P){
  vec3 Pi0 = floor(P); // Integer part for indexing
  vec3 Pi1 = Pi0 + vec3(1.0); // Integer part + 1
  Pi0 = mod(Pi0, 289.0);
  Pi1 = mod(Pi1, 289.0);
  vec3 Pf0 = fract(P); // Fractional part for interpolation
  vec3 Pf1 = Pf0 - vec3(1.0); // Fractional part - 1.0
  vec4 ix = vec4(Pi0.x, Pi1.x, Pi0.x, Pi1.x);
  vec4 iy = vec4(Pi0.yy, Pi1.yy);
  vec4 iz0 = Pi0.zzzz;
  vec4 iz1 = Pi1.zzzz;

  vec4 ixy = permute(permute(ix) + iy);
  vec4 ixy0 = permute(ixy + iz0);
  vec4 ixy1 = permute(ixy + iz1);

  vec4 gx0 = ixy0 / 7.0;
  vec4 gy0 = fract(floor(gx0) / 7.0) - 0.5;
  gx0 = fract(gx0);
  vec4 gz0 = vec4(0.5) - abs(gx0) - abs(gy0);
  vec4 sz0 = step(gz0, vec4(0.0));
  gx0 -= sz0 * (step(0.0, gx0) - 0.5);
  gy0 -= sz0 * (step(0.0, gy0) - 0.5);

  vec4 gx1 = ixy1 / 7.0;
  vec4 gy1 = fract(floor(gx1) / 7.0) - 0.5;
  gx1 = fract(gx1);
  vec4 gz1 = vec4(0.5) - abs(gx1) - abs(gy1);
  vec4 sz1 = step(gz1, vec4(0.0));
  gx1 -= sz1 * (step(0.0, gx1) - 0.5);
  gy1 -= sz1 * (step(0.0, gy1) - 0.5);

  vec3 g000 = vec3(gx0.x,gy0.x,gz0.x);
  vec3 g100 = vec3(gx0.y,gy0.y,gz0.y);
  vec3 g010 = vec3(gx0.z,gy0.z,gz0.z);
  vec3 g110 = vec3(gx0.w,gy0.w,gz0.w);
  vec3 g001 = vec3(gx1.x,gy1.x,gz1.x);
  vec3 g101 = vec3(gx1.y,gy1.y,gz1.y);
  vec3 g011 = vec3(gx1.z,gy1.z,gz1.z);
  vec3 g111 = vec3(gx1.w,gy1.w,gz1.w);

  vec4 norm0 = taylorInvSqrt(vec4(dot(g000, g000), dot(g010, g010), dot(g100, g100), dot(g110, g110)));
  g000 *= norm0.x;
  g010 *= norm0.y;
  g100 *= norm0.z;
  g110 *= norm0.w;
  vec4 norm1 = taylorInvSqrt(vec4(dot(g001, g001), dot(g011, g011), dot(g101, g101), dot(g111, g111)));
  g001 *= norm1.x;
  g011 *= norm1.y;
  g101 *= norm1.z;
  g111 *= norm1.w;

  float n000 = dot(g000, Pf0);
  float n100 = dot(g100, vec3(Pf1.x, Pf0.yz));
  float n010 = dot(g010, vec3(Pf0.x, Pf1.y, Pf0.z));
  float n110 = dot(g110, vec3(Pf1.xy, Pf0.z));
  float n001 = dot(g001, vec3(Pf0.xy, Pf1.z));
  float n101 = dot(g101, vec3(Pf1.x, Pf0.y, Pf1.z));
  float n011 = dot(g011, vec3(Pf0.x, Pf1.yz));
  float n111 = dot(g111, Pf1);

  vec3 fade_xyz = fade(Pf0);
  vec4 n_z = mix(vec4(n000, n100, n010, n110), vec4(n001, n101, n011, n111), fade_xyz.z);
  vec2 n_yz = mix(n_z.xy, n_z.zw, fade_xyz.y);
  float n_xyz = mix(n_yz.x, n_yz.y, fade_xyz.x); 
  return 2.2 * n_xyz;
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

float linearizeDepth(float depth) {
    return (2.0 * uLightNear) / (uLightFar + uLightNear - depth * (uLightFar - uLightNear));
}

float mod289(float x){return x - floor(x * (1.0 / 289.0)) * 289.0;}
vec4 mod289(vec4 x){return x - floor(x * (1.0 / 289.0)) * 289.0;}
vec4 perm(vec4 x){return mod289(((x * 34.0) + 1.0) * x);}

float noise(vec3 p){
    vec3 a = floor(p);
    vec3 d = p - a;
    d = d * d * (3.0 - 2.0 * d);

    vec4 b = a.xxyy + vec4(0.0, 1.0, 0.0, 1.0);
    vec4 k1 = perm(b.xyxy);
    vec4 k2 = perm(k1.xyxy + b.zzww);

    vec4 c = k2 + a.zzzz;
    vec4 k3 = perm(c);
    vec4 k4 = perm(c + 1.0);

    vec4 o1 = fract(k3 * (1.0 / 41.0));
    vec4 o2 = fract(k4 * (1.0 / 41.0));

    vec4 o3 = o2 * d.z + o1 * (1.0 - d.z);
    vec2 o4 = o3.yw * d.x + o3.xz * (1.0 - d.x);

    return o4.y * d.y + o4.x * (1.0 - d.y);
}





float getCloudNoise(vec3 worldPos) {
    vec3 coord = worldPos;
    coord *= 0.2;
    float n  = cnoise(coord) * 0.5;   coord *= 3.0;
          n += cnoise(coord) * 0.25;  coord *= 3.01;
          n += cnoise(coord) * 0.125; coord *= 3.02;
          n += cnoise(coord) * 0.0625;
    return max(n - 0.5, 0.0) * (1.0 / (1.0 - 0.5));
}

float getFog()
{
	float fog;
	float fogFactor;
	if (uFogShow > 0)
	{
		float fogDepth = distance(vPosition, uCameraPosition);
		
		fogFactor = clamp(1.0 - (uFogDistance - fogDepth) / uFogSize, 0.0, 1.0);
		fogFactor *= clamp(1.0 - (vPosition.z - uFogHeight) / uFogSize, 0.0, 1.0);
		//fogFactor = pow(2.71,-abs(distance(wPosition,uCameraPosition)));
		vec2 position = vPosition.xy/(512.0);
		
		if(fogFactor<1.0)
		{
			fog = fogFactor;
		}
		else
		{
			fog = fogFactor;
		}
	}
	else
		fog = 0.0; 
	
	return fog;
}



vec4 getVolumeFog(vec3 worldPosition, vec3 cameraPosition,vec3 fogRange)
{
	vec3 direction = normalize(worldPosition - cameraPosition);
	vec3 steps = direction;
	vec4 colorSum = vec4(0.0);
	vec3 point = cameraPosition;
	
	if(point.z<fogRange.x)
	{
	point += direction *(abs(fogRange.x-cameraPosition.z)/abs(direction.z));
	}

	if(fogRange.y<point.z)
	{
   point += direction *(abs(cameraPosition.z - fogRange.y) / abs(direction.z));
	}

	
	float len1 = length(point - cameraPosition);
	float len2 = length(worldPosition - cameraPosition);
	
	if(len2<len1)
	{
    return vec4(0.0);
	}


	
	//ray marching
	for(int i=0;i<500;i++)
	{
		if(uNoiseThreshold==1.0)
		{
			break;
		}
		


		point += clamp(rand(point.xy),0.45,0.55)*2.0*steps *(vec3(1.0) + vec3(i)*vec3(0.1));
		if(fogRange.x>point.z||point.z>fogRange.y||-fogRange.z+uVFogPositionX>point.x||point.x>fogRange.z+uVFogPositionX||-fogRange.z+uVFogPositionY>point.y||point.y>fogRange.z+uVFogPositionY)
		{
			continue;
		}
		
		float len3 = length(point - cameraPosition);
		float len4 = length(worldPosition - cameraPosition);
		
		if(len4<len3)
		{
		break;
		}
		
		

		float mid = (fogRange.x + fogRange.y) / 2.0;
		float h = fogRange.y - fogRange.x;
		float weight = 1.0 - 2.0 * abs(mid - point.z) / h;
		weight = pow(weight, 0.5);
		
		vec3 uOff = vec3(uOffx,uOffy,uOffz);
		
		
		float noise_use = noise((point+uOff)/uVFogSize);         //这里对point.xy加减，可以偏移噪声图像，影响云的分布，例子：noise2D((point.xy+uOff)/50.0)
		noise_use += noise((point+uOff)/uVFogSize*3.5)/3.5;
		noise_use += noise((point+uOff)/uVFogSize*12.25)/12.25;
		noise_use += noise((point+uOff)/uVFogSize*42.87)/42.87;
		noise_use /= 1.4472;
		noise_use *= weight;
		
		//float noise_use = getCloudNoise(point/10.0);
		
		if(noise_use < uNoiseThreshold)//这里这个0.4可以改成其他数值，影响云的密度,默认0.4
		{
			noise_use = 0.0;
		}
		
		float density = noise_use*uVFogDensity;
		vec4 color = vec4(0.9,0.8,0.7,1.0)*density;
		colorSum = colorSum+color*(1.0-colorSum.a);
		

	}
	


	return colorSum;
	
}






void main()
{

	vec2 tex = vTexCoord;
	if (uTexScale.x < 1.0 || uTexScale.y < 1.0)
		tex = mod(tex * uTexScale, uTexScale); // GM sprite bug workaround
	vec4 baseColor = vColor * texture2D(uTexture, tex);
	vec4 outColor;
	float Height;
	float fogDensity;
	
	Height = wPosition.z-uHeightFogStart;
	fogDensity =(uHeightFogEnd - Height)/(uHeightFogEnd - uHeightFogStart);
	float noise_use = noise(wPosition.xyz/256.0);
	noise_use += noise(vPosition.xyz/256.0*3.5)/3.5;
	noise_use += noise(vPosition.xyz/256.0*12.25)/12.25;
	noise_use += noise(vPosition.xyz/256.0*42.87)/42.87;
	noise_use /= 1.4472;
	float fogDensity2 = fogDensity*noise_use;
	if (baseColor.a > 0.0)
		outColor = vec4(vec3(getFog()), 1.0);
	else
		discard;
		
	
	outColor.xyz += fogDensity*0.5*uDensity_Decrease;
	outColor.xyz += fogDensity2*0.25*uDensity_Decrease;

	
	//vec2 position = vPosition.xy/100.0;
	/*float noise_use = noise(vPosition.xy/100.0);
	noise_use += noise(vPosition.xy/72.0)*0.75;
	noise_use += noise(vPosition.xy/31.0)*0.35;
	noise_use += noise(vPosition.xy/5.0)*0.25;
	outColor.xyz += fogDensity*noise_use*0.1;*/
	vec3 fogRange = vec3(uVFogBottom+uVFogPositionZ,uVFogTop+uVFogPositionZ,uVFogWide);
	//vec3 fogRange = vec3(-10.0 , 80.0 ,200.0);    //这里用于控制雾气的范围：fogRange.x代表雾气底层的世界坐标高度，y是顶层高度，z是以原点为中心的正方形的宽的一半，这个矩形内会生成云。
	vec4 VolumeFog = getVolumeFog(wPosition,uCameraPosition,fogRange);
	outColor.rgb = outColor.rgb*(1.0-VolumeFog.a)+VolumeFog.rgb;
	
	
	
	gl_FragColor = outColor;
}
