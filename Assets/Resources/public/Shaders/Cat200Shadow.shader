Shader "Builtin/Cat/Shadow200"
{
	Properties
	{
		[Header(Main)]
		[Space(10)]
		[MainTexture] _BaseMap ("BaseMap", 2D) = "white" { }
		[MainColor] _BaseColor ("Color", Color) = (1, 1, 1, 1)
		_FlowMap ("Flow Map", 2D) = "gray" { }
		_Roughness ("Roughness", Range(0.01, 1)) = 0.5
		_ColorMaskR ("Mask R", 2d) = "black" { }
		_ColorR ("Color R", Color) = (1, 1, 1, 1)
		_ColorMaskG ("Mask G", 2d) = "black" { }
		_ColorG ("Color G", Color) = (1, 1, 1, 1)
		_ColorMaskB ("Mask B", 2d) = "black" { }
		_ColorB ("Color B", Color) = (1, 1, 1, 1)

		// [Header(Normal)]
		// [Space(10)]
		// _BumpScale ("Noramal Scale", Range(0, 1)) = 1.0
		// _BumpMap ("Normal Map", 2D) = "bump" { }

		[Space(10)]
		[Header(AlphaTest)]
		[Space(10)]
		[Toggle(_ALPHATEST_ON)]_ALPHATEST_ON ("_ALPHATEST_ON", Float) = 1
		_Cutoff ("Alpha Cutoff", Range(0.01, 1)) = 0.5 // how "thick"
		// _AlphaLevel ("Alpha Level", Range(0, 5)) = 1
		_AlphaMin ("Alpha Min", Range(0, 5)) = 0.5
		_AlphaMax ("Alpha Max", Range(1, 5)) = 2.5
		_CameraLength ("Camera Length", Float) = 10
		_FurMask ("Fur Mask", Range(0.01, 1)) = 0.01
		_FurTming ("Fur Tming", Float) = 1
		
		[Space(10)]
		[Header(Fur)]
		[Space(10)]
		_NoiseMap ("Noise Map", 2D) = "white" { }
		_FurLength ("hair length", Range(0, 0.1)) = .02
		_FurOffset ("hair migration", Range(0, 1)) = 1
		_DensityMap ("density mapping", 2D) = "white" { }
		_DensityMin ("minimum hair density", Float) = 1.0
		_DensityMax ("maximum hair density", Float) = 1.0
		// _FresnelLV ("Fresnel LV", Float) = 1
		// _EdgeFade ("the edge of the hair is blurred", Range(0, 1)) = 0.15

		[Space(10)]
		[Header(Frizzle)]
		[Space(10)]
		_FrizzleMap ("Frizzle Map", 2D) = "grey" { }
		_FrizzleIntensity ("curl strength", Range(0, 10)) = 0
		_FrizzleShadow ("curly shadow", Range(0, 1)) = 0
		_FrizzleLen ("curl density", Range(0, 10)) = 0.2

		[Space(10)]
		[Header(Direct)]
		[Space(10)]
		_LightFilter ("parallel light hair penetration", Range(-0.5, 0.5)) = 0.0
		_FurDirLightExposure ("direct light hair exposure", Float) = 1

		// [Space(10)]
		// [Header(Gravity)]
		// [Space(10)]
		// _Gravity ("Gravity Direction", Vector) = (0, -1, 0, 0)
		// _GravityStrength ("Gravity Strength", Range(0, 1)) = 0

		[Space(10)]
		[Header(SpecularColor)]
		[Space(10)]
		_SpecShininess ("highlight range", Float) = 1
		_SpecColor ("highlight color", Color) = (1, 1, 1, 1)
		_SpecOffset ("highlight migration", Range(-1, 1)) = 0
		// _SPColor2 ("highlight color2", Color) = (1, 1, 1, 1)

		[Space(10)]
		[Header(Rim)]
		[Space(10)]
		_RimColor ("edge light color", Color) = (0.0, 0.0, 0.0, 0.0)
		_RimPower ("edge light range", Range(0.5, 8.0)) = 4.0
		_RimIntensity ("edge intensity", Float) = 1
		_SHIntensity ("environmental color influence degree", Range(0, 1)) = 1
		_OcclusionColor ("Occlusion Color", Color) = (0.5, 0.5, 0.5, 1.0)

		[Space(10)]
		[Header(PostProcess)]
		[Space(10)]
		_HueShift ("hue", Range(0, 1)) = 0
		_Brightness ("brightness", Float) = 1
		_Saturation ("saturation", Float) = 1
		_Contrast ("contrast ratio", Float) = 1

		[Space(10)]
		[Header(Shadow)]
		[Space(10)]
		_PlaneHeight ("Plane Height", float) = 1.545
		_ShadowColor ("Shadow Color", COLOR) = (0, 0, 0, 0.5)
		_ShadowFalloff ("_ShadowFalloff", Range(0, 1)) = 0.203
		_LightDir ("_LightDir", Vector) = (6.18, 5.95, 2.14)

		// Blending state
		[Header(Settings)]
		[Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend ("Src Blend Mode", Float) = 5
		[Enum(UnityEngine.Rendering.BlendMode)] _DstBlend ("Dst Blend Mode", Float) = 10
		[Toggle]_ZWrite ("ZWrite", Float) = 1.0
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode ("CullMode", float) = 2
	}
	
	Category
	{
		ZWrite On
		Tags { "Queue" = "Transparent" "RenderType" = "Opaque" " IgnoreProjector" = "True" }
		Tags { "LightMode" = "ForwardBase" }
		Blend SrcAlpha OneMinusSrcAlpha
		Cull[_CullMode]
		SubShader
		{
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment fragBase
				#define FUR_MULTIPLIER 0.0
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.005
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.01
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.015
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.02
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.025
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.03
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.035
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.04
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.045
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.05
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.055
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.06
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.065
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.07
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.075
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.08
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.085
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.09
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.095
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.1
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.105
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.11
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.115
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.12
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.125
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.13
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.135
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.14
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.145
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.15
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.155
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.16
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.165
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.17
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.175
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.18
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.185
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.19
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.195
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.2
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.205
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.21
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.215
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.22
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.225
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.23
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.235
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.24
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.245
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.25
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.255
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.26
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.265
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.27
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.275
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.28
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.285
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.29
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.295
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.3
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.305
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.31
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.315
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.32
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.325
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.33
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.335
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.34
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.345
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.35
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.355
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.36
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.365
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.37
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.375
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.38
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.385
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.39
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.395
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.4
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.405
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.41
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.415
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.42
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.425
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.43
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.435
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.44
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.445
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.45
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.455
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.46
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.465
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.47
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.475
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.48
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.485
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.49
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.495
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.5
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.505
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.51
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.515
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.52
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.525
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.53
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.535
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.54
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.545
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.55
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.555
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.56
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.565
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.57
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.575
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.58
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.585
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.59
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.595
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.6
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.605
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.61
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.615
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.62
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.625
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.63
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.635
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.64
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.645
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.65
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.655
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.66
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.665
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.67
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.675
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.68
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.685
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.69
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.695
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.7
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.705
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.71
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.715
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.72
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.725
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.73
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.735
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.74
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.745
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.75
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.755
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.76
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.765
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.77
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.775
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.78
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.785
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.79
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.795
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.8
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.805
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.81
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.815
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.82
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.825
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.83
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.835
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.84
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.845
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.85
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.855
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.86
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.865
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.87
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.875
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.88
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.885
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.89
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.895
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.9
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.905
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.91
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.915
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.92
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.925
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.93
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.935
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.94
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.945
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.95
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.955
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.96
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.965
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.97
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.975
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.98
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.985
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.99
				#include "./Fur.cginc"
				ENDCG

			}
			Pass
			{
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.995
				#include "./Fur.cginc"
				ENDCG

			}
			//shadowpass
			
			Pass
			{
				
				//use template testing to ensurealphadisplay correctly
				Stencil
				{
					Ref 0
					Comp equal
					Pass incrWrap
					Fail keep
					ZFail keep
				}

				//transparent blending mode
				Blend SrcAlpha OneMinusSrcAlpha
				// Blend off
				//turn off deep write
				ZWrite off

				//the depth is slightly offset to prevent shadows from penetrating the ground
				Offset -1, 0
				CGPROGRAM

				#pragma multi_compile_fwdbase
				#pragma vertex VertexProgram
				#pragma fragment frag
				#define FUR_MULTIPLIER 0.995
				#include "./Shadow.cginc"
				ENDCG

			}
		}Fallback "Diffuse", 1
	}
}
