#include "UnityCG.cginc"

struct appdata
{
	half4 vertex : POSITION;
};

struct v2f
{
	half4 vertex : SV_POSITION;
	fixed4 color : COLOR;
};

fixed _PlaneHeight;

fixed4 _ShadowColor;
fixed _ShadowFalloff;
half3 _LightDir;

half3 ShadowProjectPos(float4 vertPos)
{
	half3 shadowPos;

	//we get the world space coordinates of the vertices
	half3 worldPos = mul(unity_ObjectToWorld, vertPos).xyz;

	//light direction
	half3 lightDir = _LightDir - worldPos;

	//the world space coordinates of the shadow（the parts below the ground are unchanged）
	shadowPos.y = min(worldPos.y, _PlaneHeight);
	shadowPos.xz = worldPos.xz - lightDir.xz * max(0, worldPos.y - _PlaneHeight) / lightDir.y;

	return shadowPos;
}

v2f VertexProgram(appdata v)
{
	v2f o;

	//get the world space coordinates of the shadow
	half3 shadowPos = ShadowProjectPos(v.vertex);
	//switch to cut space
	o.vertex = UnityWorldToClipPos(shadowPos);

	//you get the center point world coordinates
	half3 center = half3(unity_ObjectToWorld[0].w, _PlaneHeight, unity_ObjectToWorld[2].w);
	//computed shadow attenuation
	fixed falloff = 1 - saturate(distance(shadowPos.xz, center.xz) * _ShadowFalloff);

	//shadow color
	o.color = _ShadowColor;
	o.color.a = o.color.a * clamp(falloff, 0.2, 0.8);

	return o;
}

fixed4 frag(v2f i) : SV_Target
{
	return i.color;
}
