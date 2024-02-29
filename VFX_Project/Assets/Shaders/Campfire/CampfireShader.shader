// Made with Amplify Shader Editor v1.9.2.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "CampfireShader"
{
	Properties
	{
		_VerticalSpeed("VerticalSpeed", Float) = 1.5
		_HorizontalSpeed("HorizontalSpeed", Float) = 0.3
		_HorizontalTiling("HorizontalTiling", Float) = 1
		_OriginZoneColor("OriginZoneColor", Color) = (1,1,1,0)
		_MidFlamesColor("MidFlamesColor", Color) = (1,0.6513295,0.199,0)
		_SurroudingZoneColor("SurroudingZoneColor", Color) = (0.965,0,0,0)
		_ShapeTextureInfluence("Shape Texture Influence", Float) = 0.3
		_ColorTextureInfluence("Color Texture Influence", Float) = 0.2
		_Texture0("Texture 0", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Texture0;
		uniform float _HorizontalTiling;
		uniform float _VerticalSpeed;
		uniform float _HorizontalSpeed;
		uniform float _ShapeTextureInfluence;
		uniform float4 _SurroudingZoneColor;
		uniform float4 _MidFlamesColor;
		uniform float4 _OriginZoneColor;
		uniform float _ColorTextureInfluence;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float temp_output_16_0 = ( 1.0 - i.uv_texcoord.y );
			float2 uv_TexCoord22 = i.uv_texcoord * ( ( _HorizontalTiling * float2( 1,0 ) ) + float2( 0,1 ) ) + ( ( ( ( _VerticalSpeed * _Time.y ) % 1.0 ) * float2( 0,-1 ) ) + ( ( ( _HorizontalSpeed * _Time.y ) % 1.0 ) * float2( -1,0 ) ) );
			float4 tex2DNode148 = tex2D( _Texture0, uv_TexCoord22 );
			float lerpResult11 = lerp( temp_output_16_0 , tex2DNode148.r , _ShapeTextureInfluence);
			float smoothstepResult19 = smoothstep( 0.3 , 0.6 , lerpResult11);
			float lerpResult89 = lerp( temp_output_16_0 , tex2DNode148.r , _ColorTextureInfluence);
			float smoothstepResult90 = smoothstep( 0.3 , 0.9 , lerpResult89);
			float smoothstepResult165 = smoothstep( 0.86 , 1.2 , smoothstepResult90);
			float4 lerpResult172 = lerp( _MidFlamesColor , _OriginZoneColor , smoothstepResult165);
			float4 lerpResult13 = lerp( _SurroudingZoneColor , lerpResult172 , smoothstepResult90);
			o.Emission = ( smoothstepResult19 * lerpResult13 ).rgb;
			o.Alpha = smoothstepResult19;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows exclude_path:deferred 

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
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
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
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
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
Version=19201
Node;AmplifyShaderEditor.CommentaryNode;171;-1496.427,-1117.16;Inherit;False;1734.221;858.5688;Color management;9;17;164;14;13;172;165;90;91;89;;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;16;-1501.98,16.77113;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;15;-1772.022,-166.39;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;107;-1987.165,302.7169;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleRemainderNode;24;-2395.606,70.80193;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-2198.296,175.7344;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;25;-2393.485,198.8019;Inherit;False;Constant;_Vector0;Vector 0;1;0;Create;True;0;0;0;False;0;False;0,-1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;111;-2542.165,-7.283142;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleRemainderNode;108;-2348.214,441.2751;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;-2150.904,546.2076;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;110;-2346.093,569.2751;Inherit;False;Constant;_Vector1;Vector 0;1;0;Create;True;0;0;0;False;0;False;-1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;-2534.878,440.7972;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;132;-1930.538,107.8639;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;129;-2068.285,-124.0638;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;131;-2231.538,-46.13614;Inherit;False;Constant;_Vector2;Vector 2;3;0;Create;True;0;0;0;False;0;False;1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;112;-2778.408,438.91;Inherit;False;Property;_HorizontalSpeed;HorizontalSpeed;1;0;Create;True;0;0;0;False;0;False;0.3;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;23;-2879.406,179.8021;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;106;-2794.165,-64.28314;Inherit;False;Property;_VerticalSpeed;VerticalSpeed;0;0;Create;True;0;0;0;False;0;False;1.5;1.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;89;-1181.918,-536.766;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;13;-38.30963,-884.1242;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;90;-909.9154,-536.766;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.3;False;2;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;17;-932.0988,-1046.084;Inherit;False;Property;_MidFlamesColor;MidFlamesColor;4;0;Create;True;0;0;0;False;0;False;1,0.6513295,0.199,0;1,0.8348083,0.07800001,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;164;-933.5774,-855.4881;Inherit;False;Property;_OriginZoneColor;OriginZoneColor;3;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;14;-374.4196,-1041.517;Inherit;False;Property;_SurroudingZoneColor;SurroudingZoneColor;5;0;Create;True;0;0;0;False;0;False;0.965,0,0,0;1,0.2138127,0.0235849,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;174;716.1114,-30.11382;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;CampfireShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.RangedFloatNode;91;-1453.918,-487.2881;Inherit;False;Property;_ColorTextureInfluence;Color Texture Influence;8;0;Create;True;0;0;0;False;0;False;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;353.2685,-33.09702;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;22;-1783.184,257.6159;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;179;-1560.784,717.3226;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.2,0.2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;182;-1820.937,698.5983;Inherit;True;Property;_Texture0;Texture 0;9;0;Create;True;0;0;0;False;0;False;d7be84cbf4e328a4fb89ee5db3add904;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;175;-1322.881,936.9979;Inherit;False;Property;_ShapeTextureInfluence1;Shape Texture Influence;7;0;Create;True;0;0;0;False;0;False;0.5;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;181;-1425.797,695.7092;Inherit;True;Property;_TextureSample0;Texture Sample 0;10;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;20;-1324.701,491.8973;Inherit;False;Property;_ShapeTextureInfluence;Shape Texture Influence;6;0;Create;True;0;0;0;False;0;False;0.3;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;11;-1049.393,254.1975;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;148;-1438.672,235.8132;Inherit;True;Property;_T_Caustics;T_Caustics;2;0;Create;True;0;0;0;False;0;False;-1;None;d7be84cbf4e328a4fb89ee5db3add904;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;176;-1047.573,699.2981;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;178;-774.1599,696.1892;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.3;False;2;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;172;-356.1986,-859.8892;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;165;-614.6064,-541.475;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.86;False;2;FLOAT;1.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;180;-441.8635,486.0417;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;19;-775.9799,251.0886;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.3;False;2;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;128;-2264.285,-124.0638;Inherit;False;Property;_HorizontalTiling;HorizontalTiling;2;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
WireConnection;16;0;15;2
WireConnection;107;0;26;0
WireConnection;107;1;109;0
WireConnection;24;0;111;0
WireConnection;26;0;24;0
WireConnection;26;1;25;0
WireConnection;111;0;106;0
WireConnection;111;1;23;0
WireConnection;108;0;113;0
WireConnection;109;0;108;0
WireConnection;109;1;110;0
WireConnection;113;0;112;0
WireConnection;113;1;23;0
WireConnection;132;0;129;0
WireConnection;129;0;128;0
WireConnection;129;1;131;0
WireConnection;89;0;16;0
WireConnection;89;1;148;1
WireConnection;89;2;91;0
WireConnection;13;0;14;0
WireConnection;13;1;172;0
WireConnection;13;2;90;0
WireConnection;90;0;89;0
WireConnection;174;2;12;0
WireConnection;174;9;19;0
WireConnection;12;0;19;0
WireConnection;12;1;13;0
WireConnection;22;0;132;0
WireConnection;22;1;107;0
WireConnection;179;0;22;0
WireConnection;181;0;182;0
WireConnection;181;1;179;0
WireConnection;11;0;16;0
WireConnection;11;1;148;1
WireConnection;11;2;20;0
WireConnection;148;0;182;0
WireConnection;148;1;22;0
WireConnection;176;0;16;0
WireConnection;176;1;181;1
WireConnection;176;2;175;0
WireConnection;178;0;176;0
WireConnection;172;0;17;0
WireConnection;172;1;164;0
WireConnection;172;2;165;0
WireConnection;165;0;90;0
WireConnection;180;0;178;0
WireConnection;180;1;19;0
WireConnection;19;0;11;0
ASEEND*/
//CHKSM=C80AD84EC7F27E6A36D06041244A1F62F58BEB93