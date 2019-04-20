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
/*ASEBEGIN
Version=16400
187.2;54.8;1212;764;-330.1334;272.8094;1.364098;True;False
Node;AmplifyShaderEditor.CommentaryNode;52;-1551.625,-583.8807;Float;False;1698.142;921.6166;Glow;19;235;184;43;168;169;171;187;162;247;243;244;245;237;238;236;242;262;261;279;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;71;-2131.891,379.6392;Float;False;1268.338;563.6168;Dissolve;11;120;6;28;27;16;15;8;1;258;259;260;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;162;-1540.383,-532.3555;Float;False;Property;_GlowDistribution;Glow Distribution;20;0;Create;True;0;0;False;0;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;1;-2096.064,642.725;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;8;-2097.339,490.3311;Float;False;Property;_DissolveSpeed;Dissolve Speed;10;0;Create;True;0;0;False;0;0.19,0;0.1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TimeNode;243;-1507.947,133.653;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;152;-840.8439,434.1111;Float;False;995.26;443.9333;Length from point to dissolve and glow by world pos;10;147;135;134;143;65;288;289;291;290;294;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;244;-1509.222,-18.74087;Float;False;Property;_GlowSpeed;Glow Speed;13;0;Create;True;0;0;False;0;0.19,0;0.19,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;15;-1873.951,548.9221;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;279;-1238.251,-527.8315;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;146;-303.8486,335.9421;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;65;-835.1949,696.0688;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;143;-826.011,545.347;Float;False;Property;_WorldPos;World Pos;21;0;Create;True;0;0;False;0;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;16;-1676.499,505.62;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;260;-1687.626,639.1421;Float;False;Property;_ScaleDissolveTex;Scale Dissolve Tex;9;0;Create;True;0;0;False;0;1;2;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;245;-1259.068,-19.40447;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;187;-1030.728,-528.7416;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;288;-619.5386,640.131;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;289;-621.5386,754.069;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;72;-1553.69,-1079.764;Float;False;497.2284;451.5944;Emission;3;158;154;157;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;247;-1071.497,91.41237;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;262;-1085.293,214.4002;Float;False;Property;_ScaleGlowTex;Scale Glow Tex;12;0;Create;True;0;0;False;0;1;4.1;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;171;-875.3428,-531.549;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;259;-1386.126,515.542;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-2101.626,819.0994;Float;False;Property;_Dissolve;Dissolve;16;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;134;-463.6087,676.3849;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;261;-763.2472,47.58806;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;169;-736.6902,-529.8808;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;154;-1524.936,-1025.039;Float;True;Property;_EmissionTexture;Emission Texture;6;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;6;-1170.175,436.5591;Float;True;Property;_DissolveTexture;Dissolve Texture;8;0;Create;True;0;0;False;0;None;17bda244e2dfc6d4287c29af66943857;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;157;-1510.803,-817.0695;Float;False;Property;_Emission;Emission;7;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;237;-551.6085,-325.0674;Float;False;Property;_GlowDistributionColor;Glow Distribution Color;15;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LengthOpNode;135;-314.643,683.1033;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GlobalArrayNode;291;-444.3274,457.7621;Float;False;DissolveMaxs;0;5;0;False;False;0;1;False;Object;-1;4;0;INT;0;False;2;INT;0;False;1;INT;0;False;3;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GlobalArrayNode;290;-447.4998,551.0628;Float;False;DissolveMins;0;5;0;False;False;0;1;False;Object;-1;4;0;INT;0;False;2;INT;0;False;1;INT;0;False;3;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;28;-1804.956,822.7153;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;168;-561.0245,-532.0078;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;158;-1202.753,-1021.278;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;258;-977.5259,724.4421;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;235;-477.6174,20.49034;Float;True;Property;_GlowDistributionTex;Glow Distribution Tex;11;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;295;862.7374,138.4148;Float;False;Property;_Opacity_Offset;Opacity_Offset;22;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;294;146.274,480.8931;Float;False;float output = 0@$$for(int i = 0@ i < 5@ i++)${$  float min = DissolveMins[i]@$  float max = DissolveMaxs[i]@$$  if(length < max && length > min)$  {$     output = 1@$  }$}$return output@$;1;False;3;True;MinArray;FLOAT;0;In;;Float;True;MaxArray;FLOAT;0;In;;Float;True;length;FLOAT;0;In;;Float;WaveLoop;True;False;0;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;120;-1445.26,791.3853;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;236;-374.142,-532.3733;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;238;-225.6248,-160.9512;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;147;-27.56802,780.2377;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;439.4335,-103.8304;Float;False;Property;_Smoothness;Smoothness;4;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;296;1067.643,193.4004;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;43;-115.9648,155.7087;Float;False;Property;_DissolveColor;Dissolve Color;14;1;[HDR];Create;True;0;0;False;0;0,0,0,0;1,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;22;414.2254,-371.2137;Float;True;Property;_MetallicTex;Metallic Tex;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;242;-21.0689,-348.6241;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;184;-1536.681,-456.5076;Float;False;Property;_GlowDistance;Glow Distance;19;0;Create;True;0;0;False;0;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;17;420.5164,-596.4033;Float;True;Property;_Albedo;Albedo;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;24;444.9286,-179.131;Float;False;Property;_Metallic;Metallic;3;0;Create;True;0;0;False;0;0;0.75;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;18;429.2847,-775.8116;Float;False;Property;_AlbedoColor;Albedo Color;1;0;Create;True;0;0;False;0;0,0,0,0;1,0,0,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCCompareWithRange;284;222.0854,612.9291;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;4;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;145;-127.3822,358.4645;Float;False;Property;_DissolveMax;Dissolve Max;18;0;Create;True;0;0;False;0;50;69;0;1000;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;281;157.2672,355.4703;Float;False;Property;_DissolveMin;Dissolve Min;17;0;Create;True;0;0;False;0;0;1;0;1000;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;782.4095,-174.353;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;225;993.8815,-622.0398;Float;True;Property;_NormalMap;Normal Map;5;1;[Normal];Create;True;0;0;False;0;None;None;True;0;True;bump;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;718.3875,-670.82;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;297;1254.991,177.3427;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCCompareLowerEqual;280;473.8087,82.15887;Float;False;4;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;764.4099,-324.1341;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1534.063,-40.20713;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Team5Shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;6.91;1,0.3529412,0.4734279,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;15;2;8;0
WireConnection;15;1;1;2
WireConnection;279;0;162;0
WireConnection;16;1;15;0
WireConnection;245;2;244;0
WireConnection;245;1;243;2
WireConnection;187;0;279;0
WireConnection;288;0;143;1
WireConnection;288;1;143;3
WireConnection;289;0;65;1
WireConnection;289;1;65;3
WireConnection;247;1;245;0
WireConnection;171;0;187;0
WireConnection;171;1;146;0
WireConnection;259;0;16;0
WireConnection;259;1;260;0
WireConnection;134;0;288;0
WireConnection;134;1;289;0
WireConnection;261;0;247;0
WireConnection;261;1;262;0
WireConnection;169;0;171;0
WireConnection;6;1;259;0
WireConnection;135;0;134;0
WireConnection;28;0;27;0
WireConnection;168;0;169;0
WireConnection;158;0;154;0
WireConnection;158;1;157;0
WireConnection;258;0;6;1
WireConnection;235;1;261;0
WireConnection;294;0;291;0
WireConnection;294;1;290;0
WireConnection;294;2;135;0
WireConnection;120;0;258;0
WireConnection;120;1;28;0
WireConnection;236;0;158;0
WireConnection;236;1;168;0
WireConnection;238;0;237;0
WireConnection;238;1;235;0
WireConnection;147;0;135;0
WireConnection;147;1;120;0
WireConnection;296;0;295;0
WireConnection;296;1;294;0
WireConnection;242;0;236;0
WireConnection;242;1;238;0
WireConnection;284;0;135;0
WireConnection;284;1;290;0
WireConnection;284;2;291;0
WireConnection;45;0;22;4
WireConnection;45;1;20;0
WireConnection;19;0;18;0
WireConnection;19;1;17;0
WireConnection;297;0;296;0
WireConnection;280;0;147;0
WireConnection;280;1;184;0
WireConnection;280;2;43;0
WireConnection;280;3;242;0
WireConnection;25;0;22;1
WireConnection;25;1;24;0
WireConnection;0;0;19;0
WireConnection;0;2;280;0
WireConnection;0;3;25;0
WireConnection;0;4;45;0
WireConnection;0;9;297;0
ASEEND*/
//CHKSM=CA989D12F9C5C4D38AFE9ADA3DFE2AE0B094B0B5
