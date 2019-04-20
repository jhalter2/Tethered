// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Team5Shader"
{
	Properties
	{
		_Albedo("Albedo", 2D) = "white" {}
		_AlbedoColor("Albedo Color", Color) = (0,0,0,0)
		_MetallicTex("Metallic Tex", 2D) = "white" {}
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_EmissionTexture("Emission Texture", 2D) = "white" {}
		[HDR]_Emission("Emission", Color) = (0,0,0,0)
		_DissolveTexture("Dissolve Texture", 2D) = "white" {}
		_ScaleDissolveTex("Scale Dissolve Tex", Range( 0 , 20)) = 1
		_DissolveSpeed("Dissolve Speed", Vector) = (0.19,0,0,0)
		_GlowDistributionTex("Glow Distribution Tex", 2D) = "white" {}
		_ScaleGlowTex("Scale Glow Tex", Range( 0 , 20)) = 1
		_GlowSpeed("Glow Speed", Vector) = (0.19,0,0,0)
		[HDR]_DissolveColor("Dissolve Color", Color) = (0,0,0,0)
		[HDR]_GlowDistributionColor("Glow Distribution Color", Color) = (0,0,0,0)
		_Dissolve("Dissolve", Range( 0 , 1)) = 0
		_GlowDistance("Glow Distance", Range( 0 , 1)) = 1
		_GlowDistribution("Glow Distribution", Range( 0 , 1)) = 1
		_WorldPos("World Pos", Vector) = (0,0,0,0)
		_Opacity_Offset("Opacity_Offset", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform float4 _AlbedoColor;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform float3 _WorldPos;
		uniform sampler2D _DissolveTexture;
		uniform float2 _DissolveSpeed;
		uniform float _ScaleDissolveTex;
		uniform float _Dissolve;
		uniform float _GlowDistance;
		uniform float4 _DissolveColor;
		uniform sampler2D _EmissionTexture;
		uniform float4 _EmissionTexture_ST;
		uniform float4 _Emission;
		uniform float _GlowDistribution;
		uniform float4 _GlowDistributionColor;
		uniform sampler2D _GlowDistributionTex;
		uniform float2 _GlowSpeed;
		uniform float _ScaleGlowTex;
		uniform sampler2D _MetallicTex;
		uniform float4 _MetallicTex_ST;
		uniform float _Metallic;
		uniform float _Smoothness;
		uniform float _Opacity_Offset;
		uniform float DissolveMaxs[5];
		uniform float DissolveMins[5];


		float WaveLoop294( float MinArray , float MaxArray , float length )
		{
			float output = 0;
			for(int i = 0; i < 5; i++)
			{
			  float min = DissolveMins[i];
			  float max = DissolveMaxs[i];
			  if(length < max && length > min)
			  {
			     output = 1;
			  }
			}
			return output;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			o.Albedo = ( _AlbedoColor * tex2D( _Albedo, uv_Albedo ) ).rgb;
			float2 appendResult288 = (float2(_WorldPos.x , _WorldPos.z));
			float3 ase_worldPos = i.worldPos;
			float2 appendResult289 = (float2(ase_worldPos.x , ase_worldPos.z));
			float temp_output_135_0 = length( ( appendResult288 - appendResult289 ) );
			float2 panner15 = ( _Time.y * _DissolveSpeed + float2( 0,0 ));
			float2 uv_TexCoord16 = i.uv_texcoord + panner15;
			float2 uv_EmissionTexture = i.uv_texcoord * _EmissionTexture_ST.xy + _EmissionTexture_ST.zw;
			float2 panner245 = ( _Time.y * _GlowSpeed + float2( 0,0 ));
			float2 uv_TexCoord247 = i.uv_texcoord + panner245;
			o.Emission = (( ( temp_output_135_0 + ( tex2D( _DissolveTexture, (uv_TexCoord16*_ScaleDissolveTex + float2( 0,0 )) ).r * ( 1.0 - _Dissolve ) ) ) <= _GlowDistance ) ? _DissolveColor :  ( ( ( tex2D( _EmissionTexture, uv_EmissionTexture ) * _Emission ) + saturate( ( 1.0 - ( ( 1.0 - (-1.0 + (_GlowDistribution - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) ) + ( 0.0 - 0.0 ) ) ) ) ) * ( _GlowDistributionColor * tex2D( _GlowDistributionTex, (uv_TexCoord247*_ScaleGlowTex + float2( 0,0 )) ) ) ) ).rgb;
			float2 uv_MetallicTex = i.uv_texcoord * _MetallicTex_ST.xy + _MetallicTex_ST.zw;
			float4 tex2DNode22 = tex2D( _MetallicTex, uv_MetallicTex );
			o.Metallic = ( tex2DNode22.r * _Metallic );
			o.Smoothness = ( tex2DNode22.a * _Smoothness );
			float MinArray294 = DissolveMaxs[0];
			float MaxArray294 = DissolveMins[0];
			float length294 = temp_output_135_0;
			float localWaveLoop294 = WaveLoop294( MinArray294 , MaxArray294 , length294 );
			float clampResult297 = clamp( ( _Opacity_Offset + localWaveLoop294 ) , 0.0 , 1.0 );
			o.Alpha = clampResult297;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
