Shader "Selected Effect --- Xray/XrayOnePass" {
	Properties {
		[Header(Basic)][Space(5)]
		_MaskTex         ("Mask", 2D) = "white" {}
		[HDR]_XrayColor  ("Color", Color) = (0, 1, 0, 1)
		_Inside          ("Inside", Range(0, 1)) = 0
		_Rim             ("Rim", Float) = 1.2

		[Header(Directional Transparent)][Space(5)]
		[Toggle(USE_DIR_TRANSPARENT)] _DirTrans ("Use Directional Transparent", Int) = 0
		_Dir  ("Direction", Vector) = (0, 1, 0, 1)

		[Header(HemiSphere)][Space(5)]
		[Toggle(USE_HEMISPHERE)] _Hemisphere ("Use HemiSphere", Int) = 0
		[HDR]_XrayBottomColor ("Bottom Color", Color) = (0, 1, 0, 1)
		[HDR]_XrayTopColor    ("Top Color", Color) = (1, 1, 0, 1)

		[Header(RenderState)][Space(5)]
		[Enum(UnityEngine.Rendering.BlendMode)] _BlendSrc ("Blend Src", Int) = 1
		[Enum(UnityEngine.Rendering.BlendMode)] _BlendDst ("Blend Dst", Int) = 0
		[Enum(UnityEngine.Rendering.CullMode)] _CullMode ("Cull Mode", Float) = 2
	}
	SubShader {
		Tags { "Queue" = "Transparent" }
		Blend [_BlendSrc] [_BlendDst] Cull [_CullMode] Zwrite Off
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment fragMask
			#define SEXrayBlendColor float4(0, 0, 0, 0)
			#pragma multi_compile _ USE_HEMISPHERE
			#pragma multi_compile _ USE_DIR_TRANSPARENT
			#include "UnityCG.cginc"
			#include "Xray.cginc"
			ENDCG
		}
	}
	FallBack "Diffuse"
}