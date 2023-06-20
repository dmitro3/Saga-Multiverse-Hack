#ifndef XRAY_CGINC
#define XRAY_CGINC

float4 _XrayColor, _XrayBottomColor, _XrayTopColor, _Dir;
float _Rim, _Inside;
sampler2D _MaskTex;
float4 _MaskTex_ST;

sampler2D _ProjMaskTex;
float4x4 unity_Projector;

struct v2f
{
	float4 pos    : SV_POSITION;
	float4 col    : COLOR;
	float2 uv     : TEXCOORD0;
	float4 projuv : TEXCOORD1;
	float3 normal : TEXCOORD2;
};
v2f vert (appdata_base v)
{
	v2f o;
	o.pos = UnityObjectToClipPos(v.vertex);
	o.uv = TRANSFORM_TEX(v.texcoord, _MaskTex);
	o.projuv = mul(unity_Projector, v.vertex);
	o.normal = mul((float3x3)UNITY_MATRIX_IT_MV, SCALED_NORMAL);
	o.col = float4(o.normal, 1.0);

	// vertex shading is artifacts, use fragment shading.
//	n = normalize(n);
//#if USE_HEMISPHERE
//	float fade = (dot(n, float3(0, 1, 0)) + 1) / 2;
//	float4 c = lerp(_XrayBottomColor, _XrayTopColor, fade);
//	o.col = lerp(SEXrayBlendColor, c, saturate(max(1 - pow(n.z, _Rim), _Inside)));
//#else
//	o.col = lerp(SEXrayBlendColor, _XrayColor, saturate(max(1 - pow(n.z, _Rim), _Inside)));
//#endif

//#if USE_DIR_TRANSPARENT
//	float up = dot(n, normalize(_Dir.xyz));
//	o.col.a *= up;
//#endif
	return o;
}
float4 frag (v2f input) : SV_Target
{
	float3 nrm = normalize(input.normal);
	float4 c = 0.0;

#if USE_HEMISPHERE
	float fade = (dot(nrm, float3(0, 1, 0)) + 1) / 2;
	c = lerp(_XrayBottomColor, _XrayTopColor, fade);
	c = lerp(SEXrayBlendColor, c, saturate(max(1 - pow(nrm.z, _Rim), _Inside)));
#else
	c = lerp(SEXrayBlendColor, _XrayColor, saturate(max(1 - pow(nrm.z, _Rim), _Inside)));
#endif

#if USE_DIR_TRANSPARENT
	float fade2 = dot(nrm, normalize(_Dir.xyz));
	c.a *= fade2;
#endif

#ifdef USE_PROJ
	half mask = tex2Dproj(_ProjMaskTex, UNITY_PROJ_COORD(input.projuv)).r;
	c *= mask;
#endif
	return c;
}
float4 fragMask (v2f input) : SV_Target
{
	float3 nrm = normalize(input.normal);
	float4 c = 0.0;

#if USE_HEMISPHERE
	float fade = (dot(nrm, float3(0, 1, 0)) + 1) / 2;
	c = lerp(_XrayBottomColor, _XrayTopColor, fade);
	c = lerp(SEXrayBlendColor, c, saturate(max(1 - pow(nrm.z, _Rim), _Inside)));
#else
	c = lerp(SEXrayBlendColor, _XrayColor, saturate(max(1 - pow(nrm.z, _Rim), _Inside)));
#endif

#if USE_DIR_TRANSPARENT
	float fade2 = dot(nrm, normalize(_Dir.xyz));
	fade2 = fade2 * 0.5 + 0.5;
	c.a *= fade2;
#endif

	half mask = 1.0;
#ifdef USE_PROJ
	mask = tex2Dproj(_ProjMaskTex, UNITY_PROJ_COORD(input.projuv)).r;
	c *= mask;
#endif

	mask = tex2D(_MaskTex, input.uv).r;
	c.rgb *= mask;

//	return input.col;
//	return float4(nrm * 0.5 + 0.5, 1.0);
//	return float4(nrm, 1.0);
	return c;
}

#endif