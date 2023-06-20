Shader "Builtin/Cat/base"
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
		[Space(10)]
		[Header(AlphaTest)]
		[Space(10)]
		[Toggle(_ALPHATEST_ON)]_ALPHATEST_ON ("_ALPHATEST_ON", Float) = 1
		_Cutoff ("Alpha Cutoff", Range(0.01, 1)) = 0.5 // how "thick"
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
		[Space(10)]
		[Header(Frizzle)]
		[Space(10)]
		_FrizzleMap("Frizzle Map", 2D) = "grey" {}
		_FrizzleIntensity("curl strength", Range(0, 10)) = 0
		_FrizzleShadow("curly shadow", Range(0, 1)) = 0
		_FrizzleLen("curl density", Range(0, 10)) = 0.2
		[Space(10)]
		[Header(Direct)]
		[Space(10)]
		_LightFilter ("parallel light hair penetration", Range(-0.5, 0.5)) = 0.0
		_FurDirLightExposure ("direct light hair exposure", Float) = 1
		[Space(10)]
		[Header(SpecularColor)]
		[Space(10)]
		_SpecShininess ("highlight range", Float) = 1
		_SpecColor ("highlight color", Color) = (1, 1, 1, 1)
		_SpecOffset ("highlight migration", Range(-1, 1)) = 0
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
		Cull [_CullMode]
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
		}Fallback "Diffuse", 1
	}
}
