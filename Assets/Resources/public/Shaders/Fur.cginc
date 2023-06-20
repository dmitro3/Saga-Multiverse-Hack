
#include "UnityCG.cginc"
#include "AutoLight.cginc"
#include "UnityImageBasedLighting.cginc"

uniform half4 _BaseMap_ST;
uniform half4 _NoiseMap_ST;
uniform half4 _BaseColor;
uniform half4 _ColorR;
uniform half4 _ColorG;
uniform half4 _ColorB;
uniform half4 _EmissionColor;
uniform half4 _OcclusionColor;
// uniform half4 _SPColor1;
uniform half4 _SPColor2;
// uniform half4 _SpecColor;
uniform half4 _RimColor;
uniform half3 _Gravity;
uniform half _RimPower;
uniform half _GravityStrength;
uniform half _FurLength;
uniform half _Cutoff;
uniform half _Roughness;
uniform half _Metallic;
uniform half _BumpScale;
uniform half _Parallax;
uniform half _OcclusionStrength;
uniform half _FurMask;
uniform half _FurTming;
uniform half _FresnelLV;
uniform half _LightFilter;
uniform half _UVoffset;
uniform half _AlphaLevel;
uniform half _EdgeFade;
uniform half _FurDirLightExposure;
uniform half _FurOffset;
uniform half _RimIntensity;
uniform half _SHIntensity;
uniform half _AlphaMin;
uniform half _AlphaMax;
uniform half _CameraLength;
uniform half _SpecOffset;
uniform half _SpecShininess;
uniform half _DensityMin;
uniform half _DensityMax;
uniform half _Brightness;
uniform half _Saturation;
uniform half _Contrast;
uniform half _HueShift;
uniform half _FrizzleIntensity;
uniform half _FrizzleLen;
uniform half _FrizzleShadow;

// uniform fixed4 _LightColor;
// uniform fixed4 _LightColor0;

sampler2D _BaseMap;
sampler2D _NoiseMap;
sampler2D _FlowMap;
sampler2D _FrizzleMap;
sampler2D _DensityMap;
sampler2D _ColorMaskR;
sampler2D _ColorMaskG;
sampler2D _ColorMaskB;

struct Attributes
{
    float4 vertex : POSITION;
    float3 normalOS : NORMAL;
    float4 tangentOS : TANGENT;
    float2 texcoord : TEXCOORD0;
    float4 color : COLOR;
};

struct Varyings
{
    float4 pos : SV_POSITION;
    half4 uv : TEXCOORD0;
    half4 uv2 : TEXCOORD1;
    fixed4 color : COLOR0;
    fixed4 rim : TEXCOORD2;
    fixed4 ref : TEXCOORD3;
    half3 N : TEXCOORD4;
    half3 V : TEXCOORD5;
    half3 positionWS : TEXCOORD6;
    LIGHTING_COORDS(7, 8)
    half3 T : TEXCOORD9;
    half3 B : TEXCOORD10;
};

half3 ShiftTangent(half3 T, half3 N, half shift)
{
    return normalize(T + N * shift);
}

half3 D_KajiyaKay(half3 T, half3 H, half specularExponent)
{
    half TdotH = dot(T, H);
    half sinTHSq = sqrt(1.0 - TdotH * TdotH);
    half dirAttn = smoothstep(-1.0, 0.0, TdotH);
    return dirAttn * pow(sinTHSq, specularExponent);
}

float3 HSVToRGB(float3 c)
{
    float4 K = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    float3 p = abs(frac(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * lerp(K.xxx, saturate(p - K.xxx), c.y);
}

float3 RGBToHSV(float3 c)
{
    float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    float4 p = lerp(float4(c.bg, K.wz), float4(c.gb, K.xy), step(c.b, c.g));
    float4 q = lerp(float4(p.xyw, c.r), float4(c.r, p.yzx), step(p.x, c.r));
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return float3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

Varyings VertexProgram(Attributes v)
{
    Varyings o;
    //UNITY_INITIALIZE_o(vertexo,o);
    float3 binormal = cross(normalize(v.normalOS), normalize(v.tangentOS.xyz)) * v.tangentOS.w;

    o.uv.xy = TRANSFORM_TEX(v.texcoord, _BaseMap);
    o.uv.zw = TRANSFORM_TEX(v.texcoord, _NoiseMap);

    //vertex migration
    half4 flowMap = tex2Dlod(_FlowMap, float4(o.uv.xy, 0, 0));
    half2 flowDir = 0.5 - flowMap.rg;

    half3 tangentWS = UnityObjectToWorldNormal(v.tangentOS.xyz) * - flowDir.r;
    half3 bitangentWS = UnityObjectToWorldNormal(binormal) * - flowDir.g;
    // half3 bitangentWS = UnityObjectToWorldNormal(binormal) * -flowDir.g * FUR_MULTIPLIER* FUR_MULTIPLIER * _FurOffset;

    half3 offset = UnityObjectToWorldNormal(v.normalOS);
    offset = normalize(offset * _FurLength * 2 + (tangentWS + bitangentWS) * FUR_MULTIPLIER * _FurOffset) * FUR_MULTIPLIER * _FurLength * 2 * flowMap.b;
    // offset *= FUR_MULTIPLIER * _FurLength * FUR_MULTIPLIER * flowMap.b;

    fixed3 P = v.vertex.xyz;

    //data
    fixed3 positionWS = mul(unity_ObjectToWorld, half4(P, 1.0)).xyz + offset;
    o.pos = UnityWorldToClipPos(positionWS);
    fixed3 normalWS = normalize(fixed3(mul(fixed4(v.normalOS, 0.0), unity_WorldToObject).xyz));
    fixed3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
    fixed3 viewDirectionWS = normalize(_WorldSpaceCameraPos.xyz - positionWS.xyz);
    
    // fixed3 diffuseReflection = _LightColor0.xyz * max(0.0, dot(normalWS, lightDirection));
    // fixed3 ambientLighting = UNITY_LIGHTMODEL_AMBIENT.xyz * _LightColor0.xyz;
    
    // fixed3 specularReflection;
    
    // if (dot(normalWS, lightDirection) < 0.0)
    // {
    //     specularReflection = fixed3(0.0, 0.0, 0.0);
    // }
    // else
    // {
    //     specularReflection = _LightColor0.xyz * _SpecColor.xyz * pow(max(0.0, dot(reflect(-lightDirection, normalWS).xyz, viewDirectionWS)), 1.0 - _Roughness);
    // }
    
    //float4 nD = normalize(float3(mul(float4(v.normal, 0.0), _World2Object)));
    o.ref = reflect(-fixed4(viewDirectionWS, 0.0), fixed4(normalWS, 0.0));
    
    // o.color = fixed4((ambientLighting + diffuseReflection + specularReflection /*+ vertexLighting*/), v.color.a);
    // o.color = flowDir.r * FUR_MULTIPLIER;

    o.N = normalWS;
    o.T = tangentWS;
    o.B = bitangentWS;
    o.V = viewDirectionWS;
    o.positionWS = positionWS;
    // o.color = fixed4(ambientLighting, 1.0);
    TRANSFER_SHADOW(o);
    return o;
}

fixed4 frag(Varyings input) : COLOR
{
    half3 L = normalize(_WorldSpaceLightPos0.xyz);
    half3 V = input.V;
    half3 N = input.N;
    half3 T = input.T;
    half3 B = input.B;
    half3 H = normalize(L + V); //half angular vector

    //base color
    half4 baseColor = tex2D(_BaseMap, input.uv.xy);
    half4 flowMap = tex2D(_FlowMap, input.uv.xy);
    half density = tex2D(_DensityMap, input.uv.xy).r;
    half colorMaskR = tex2D(_ColorMaskR, input.uv.xy).r;
    half colorMaskG = tex2D(_ColorMaskG, input.uv.xy).r;
    half colorMaskB = tex2D(_ColorMaskB, input.uv.xy).r;

    half3 albedo = lerp(baseColor.rgb, _ColorR.rgb, colorMaskR);
    albedo = lerp(albedo, _ColorG.rgb, colorMaskG);
    albedo = lerp(albedo, _ColorB.rgb, colorMaskB);
    baseColor.rgb = albedo;

    //frizz effect
    // half2 frizzleUV;
    // frizzleUV = lerp(0.1, 0.2 + _FrizzleLen, FUR_MULTIPLIER);
    half2 frizzle = tex2D(_FrizzleMap, input.uv.xy * _FrizzleLen).rg;
    //modify color
    baseColor.rgb *= lerp(1.0, saturate(frizzle.r * frizzle.g * 4), _FrizzleShadow);
    frizzle = (0.5 - frizzle);
    frizzle = frizzle * FUR_MULTIPLIER * _FrizzleIntensity * 0.1;

    // baseColor.rgb *= saturate((0.5 - frizzle).r * (0.5 - frizzle).g * 4);
    
    //hair strength
    half uvOffset = lerp(_DensityMin, _DensityMax, density);
    fixed3 noiseMip = tex2Dlod(_NoiseMap, half4((input.uv.zw + frizzle) * uvOffset, 0, 4.0)).r;
    fixed3 noise = tex2D(_NoiseMap, (input.uv.zw + frizzle) * uvOffset).r;
    noise = (noise + noiseMip) / 2;

    //display strength
    half4 color = half4(1, 1, 1, 1);
    half lenLerp = saturate(distance(input.positionWS, _WorldSpaceCameraPos.xyz) / _CameraLength);
    half alpha = lerp(_AlphaMin, _AlphaMax, lenLerp);

    // color.a = saturate(noise * _AlphaLevel - (FUR_MULTIPLIER * FUR_MULTIPLIER) * _EdgeFade) * baseColor.a * flowMap.b * 2;
    color.a = saturate((noise * 2 * alpha * smoothstep(0, 0.5, flowMap.b) - (FUR_MULTIPLIER * FUR_MULTIPLIER + (FUR_MULTIPLIER * _FurMask * 5))) * _FurTming) * baseColor.a;

    // clip(FUR_MULTIPLIER > max(color.a * input.color.a, _Cutoff) ? - 1 : 1);
    clip(color.a - _Cutoff);

    half atten = LIGHT_ATTENUATION(input);

    //lambert
    half NoL = dot(L, N);
    half DirIntensity = saturate(NoL + _LightFilter + FUR_MULTIPLIER) ;
    half3 DirLight = _LightColor0 * _FurDirLightExposure * DirIntensity * atten;
    // DirLight = lerp(_OcclusionColor.rgb * DirLight, DirLight, occlusion);

    //direct mirror surface reflection
    float3 t = ShiftTangent(B, N, _SpecOffset);
    half intensity = max(D_KajiyaKay(t, H, _SpecShininess), 0) * DirIntensity * _SpecColor.a;
    half3 specularColor = _SpecColor.rgb * intensity * atten;

    //SH
    half occlusion = FUR_MULTIPLIER * FUR_MULTIPLIER + 0.04;
    half3 SH = lerp(half3(1.0, 1.0, 1.0), ShadeSH9(half4(input.N, 1)), _SHIntensity);
    half3 SHL = lerp(_OcclusionColor.rgb * SH, SH, occlusion);

    //edge light
    half3 rim = 1.0 - saturate(dot(V, N));
    half rimIntensity = -dot(L, V) * 0.5 + 0.5;
    rim = fixed4(_RimColor.rgb * pow(rim, _RimPower), 1.0) * _RimIntensity * rimIntensity * atten;

    //ambient mirror surface reflection
    Unity_GlossyEnvironmentData envData;
    envData.roughness = _Roughness; // roughness
    envData.reflUVW = input.ref;     // rightCubeMapsampling direction
    half3 inDirSpecular = Unity_GlossyEnvironment(UNITY_PASS_TEXCUBE(unity_SpecCube0), unity_SpecCube0_HDR, envData);

    color.rgb = (DirLight + specularColor + SHL + rim + inDirSpecular) * baseColor;

    //hue
    float3 hsv = RGBToHSV(color.rgb);
    hsv.r = hsv.r + _HueShift;
    color.rgb = HSVToRGB(hsv);

    //brightness
    color.rgb = color.rgb * _Brightness;
    //saturation
    float lumin = dot(color.rgb, float3(0.22, 0.707, 0.071));
    color.rgb = lerp(lumin, color.rgb, _Saturation);
    //contrast ratio
    float3 midpoint = float3(0.5, 0.5, 0.5);
    color.rgb = lerp(midpoint, color.rgb, _Contrast);
    // color.rgb = DirLight;

    return color;
}


fixed4 fragBase(Varyings input) : COLOR
{
    half3 L = normalize(_WorldSpaceLightPos0.xyz);
    half3 V = input.V;
    half3 N = input.N;
    half4 color = half4(1, 1, 1, 1);

    fixed4 baseColor = tex2D(_BaseMap, input.uv.xy);
    half colorMaskR = tex2D(_ColorMaskR, input.uv.xy).r;
    half colorMaskG = tex2D(_ColorMaskG, input.uv.xy).r;
    half colorMaskB = tex2D(_ColorMaskB, input.uv.xy).r;

    half3 albedo = lerp(baseColor.rgb, _ColorR.rgb, colorMaskR);
    albedo = lerp(albedo, _ColorG.rgb, colorMaskG);
    albedo = lerp(albedo, _ColorB.rgb, colorMaskB);
    baseColor.rgb = albedo;

    half atten = LIGHT_ATTENUATION(input);

    //lambert
    half NoL = max(dot(L, N), 0.0);
    half3 DirLight = saturate(NoL + _LightFilter + FUR_MULTIPLIER * 0.5) ;
    DirLight *= _LightColor0 * _FurDirLightExposure * atten;

    //SH
    half occlusion = FUR_MULTIPLIER * FUR_MULTIPLIER + 0.04;
    half3 SH = ShadeSH9(half4(input.N, 1));
    half3 SHL = _OcclusionColor.rgb * SH;

    //ambient mirror surface reflection
    Unity_GlossyEnvironmentData envData;
    envData.roughness = _Roughness; // roughness
    envData.reflUVW = input.ref;     // rightCubeMapsampling direction
    half3 specular = Unity_GlossyEnvironment(UNITY_PASS_TEXCUBE(unity_SpecCube0), unity_SpecCube0_HDR, envData);

    color.rgb = (DirLight + SHL + specular) * baseColor;

    //hue
    float3 hsv = RGBToHSV(color.rgb);
    hsv.r = hsv.r + _HueShift;
    color.rgb = HSVToRGB(hsv);
    //brightness
    color.rgb = color.rgb * _Brightness;
    //saturation
    float lumin = dot(color.rgb, float3(0.22, 0.707, 0.071));
    color.rgb = lerp(lumin, color.rgb, _Saturation);
    //contrast ratio
    float3 midpoint = float3(0.5, 0.5, 0.5);
    color.rgb = lerp(midpoint, color.rgb, _Contrast);

    color.a = 1.0;

    return color;
}
