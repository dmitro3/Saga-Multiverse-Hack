Shader "Builtin/Cat/40"
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
		[Header(FlowMap)]
		[Space(10)]

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
		_HueShift("hue", Range(0, 1)) = 0
		_Brightness("brightness", Float) = 1
		_Saturation("saturation",Float) = 1
		_Contrast("contrast ratio",Float) = 1

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
		// Alphatest Greater [_Cutoff]
		Cull [_CullMode]
		
		SubShader
		{
			Pass
			{
				//ZWrite On

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
				#define FUR_MULTIPLIER 0.975
				#include "./Fur.cginc"
				ENDCG

			}
		}Fallback "Diffuse", 1
	}
}
