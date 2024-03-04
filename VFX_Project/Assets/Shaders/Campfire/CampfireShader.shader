// Made with Amplify Shader Editor v1.9.2.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "CampfireShader"
{
	Properties
	{
		_CausticTexture("Caustic Texture", 2D) = "white" {}
		_VerticalTiling("VerticalTiling", Float) = 0.4
		_HorizontalTiling("HorizontalTiling", Float) = 0.6
		_VerticalSpeed("VerticalSpeed", Float) = 0.6
		_HorizontalSpeed("HorizontalSpeed", Float) = 0.5
		[HDR]_OriginZoneColor("OriginZoneColor", Color) = (4.541206,2.419898,0.3224255,0)
		[HDR]_MidFlamesColor("MidFlamesColor", Color) = (1.498039,0.4171922,0.06441575,0)
		_ShapeTextureInfluence("Shape Texture Influence", Range( 0 , 1)) = 0.3
		_ColorTextureInfluence("Color Texture Influence", Range( 0 , 1)) = 0.2
		_ThresholdAlpha("Threshold Alpha", Float) = 0
		_SmoothnessAlpha("Smoothness Alpha", Float) = 1.12
		_ThresholdColor("Threshold Color", Float) = 0.09
		_SmoothnessColor("Smoothness Color", Float) = 1.26
		_SmoothnessEdge("Smoothness Edge", Float) = 0.79
		_ThresholdEdge("Threshold Edge", Float) = 0
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
			float4 vertexColor : COLOR;
		};

		uniform float4 _MidFlamesColor;
		uniform float4 _OriginZoneColor;
		uniform float _ThresholdColor;
		uniform float _SmoothnessColor;
		uniform sampler2D _CausticTexture;
		uniform float _HorizontalTiling;
		uniform float _VerticalTiling;
		uniform float _HorizontalSpeed;
		uniform float _VerticalSpeed;
		uniform float _ColorTextureInfluence;
		uniform float _ThresholdEdge;
		uniform float _SmoothnessEdge;
		uniform float _ThresholdAlpha;
		uniform float _SmoothnessAlpha;
		uniform float _ShapeTextureInfluence;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float temp_output_16_0 = ( 1.0 - i.uv_texcoord.y );
			float2 uv_TexCoord22 = i.uv_texcoord * ( ( _HorizontalTiling * float2( 1,0 ) ) + ( _VerticalTiling * float2( 0,1 ) ) ) + ( 1.0 - ( ( ( ( _HorizontalSpeed * _Time.y ) * float2( 1,0 ) ) + ( ( _VerticalSpeed * _Time.y ) * float2( 0,1 ) ) ) % float2( 1,1 ) ) );
			float4 tex2DNode148 = tex2D( _CausticTexture, uv_TexCoord22 );
			float lerpResult89 = lerp( temp_output_16_0 , tex2DNode148.r , _ColorTextureInfluence);
			float smoothstepResult165 = smoothstep( _ThresholdColor , ( _ThresholdColor + _SmoothnessColor ) , lerpResult89);
			float4 lerpResult172 = lerp( _MidFlamesColor , _OriginZoneColor , smoothstepResult165);
			o.Emission = lerpResult172.rgb;
			float smoothstepResult226 = smoothstep( _ThresholdEdge , ( _ThresholdEdge + _SmoothnessEdge ) , i.vertexColor.r);
			float lerpResult11 = lerp( temp_output_16_0 , tex2DNode148.r , _ShapeTextureInfluence);
			float smoothstepResult19 = smoothstep( _ThresholdAlpha , ( _ThresholdAlpha + _SmoothnessAlpha ) , lerpResult11);
			o.Alpha = ( smoothstepResult226 * smoothstepResult19 );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows exclude_path:deferred 

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
				half4 color : COLOR0;
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
				o.color = v.color;
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
				surfIN.vertexColor = IN.color;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
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
Node;AmplifyShaderEditor.CommentaryNode;171;-851.7374,-947.4621;Inherit;False;1518.539;857.3932;Color management;9;91;198;197;199;165;172;164;17;89;;1,1,1,1;0;0
Node;AmplifyShaderEditor.FunctionNode;184;-1856.615,382.4065;Inherit;False;BuildVector2;-1;;2;fd1658ce95754324891cc2cf05e64ec3;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleRemainderNode;186;-1667.615,381.4065;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;1,1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;188;-1492.045,380.9751;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;112;-2275.925,329.7293;Inherit;False;Property;_HorizontalSpeed;HorizontalSpeed;4;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;-2032.395,331.6165;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;111;-2033.833,450.856;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;106;-2237.815,450.1732;Inherit;False;Property;_VerticalSpeed;VerticalSpeed;3;0;Create;True;0;0;0;False;0;False;0.6;0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;23;-2507.934,357.2055;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;189;-1525.699,226.5947;Inherit;False;BuildVector2;-1;;3;fd1658ce95754324891cc2cf05e64ec3;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;22;-1273.683,270.0873;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;16;-825.4786,79.24251;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;15;-1088.797,29.76336;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;128;-1769.528,85.62927;Inherit;False;Property;_HorizontalTiling;HorizontalTiling;2;0;Create;True;0;0;0;False;0;False;0.6;0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;191;-1770.499,208.1614;Inherit;False;Property;_VerticalTiling;VerticalTiling;1;0;Create;True;0;0;0;False;0;False;0.4;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;148;-929.1707,248.2846;Inherit;True;Property;_T_Caustics;T_Caustics;2;0;Create;True;0;0;0;False;0;False;-1;None;d7be84cbf4e328a4fb89ee5db3add904;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;182;-1283.733,444.6929;Inherit;True;Property;_CausticTexture;Caustic Texture;0;0;Create;True;0;0;0;False;0;False;d7be84cbf4e328a4fb89ee5db3add904;d7be84cbf4e328a4fb89ee5db3add904;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.LerpOp;89;-458.9578,-367.0691;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;17;-15.4397,-858.5276;Inherit;False;Property;_MidFlamesColor;MidFlamesColor;6;1;[HDR];Create;True;0;0;0;False;0;False;1.498039,0.4171922,0.06441575,0;1,0.8348083,0.07800001,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;164;-16.9184,-667.9318;Inherit;False;Property;_OriginZoneColor;OriginZoneColor;5;1;[HDR];Create;True;0;0;0;False;0;False;4.541206,2.419898,0.3224255,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;172;366.7632,-690.1913;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;165;193.3727,-369.6071;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.65;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;199;57.96035,-216.536;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;197;-165.8611,-270.4448;Inherit;False;Property;_ThresholdColor;Threshold Color;11;0;Create;True;0;0;0;False;0;False;0.09;0.09;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;198;-200.0415,-192.7594;Inherit;False;Property;_SmoothnessColor;Smoothness Color;12;0;Create;True;0;0;0;False;0;False;1.26;1.26;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;91;-801.5918,-317.5912;Inherit;False;Property;_ColorTextureInfluence;Color Texture Influence;8;0;Create;True;0;0;0;False;0;False;0.2;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-942.6115,450.9158;Inherit;False;Property;_ShapeTextureInfluence;Shape Texture Influence;7;0;Create;True;0;0;0;False;0;False;0.3;0.3;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;19;351.9927,247.6972;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.25;False;2;FLOAT;0.7;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;11;-431.5249,253.3101;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;222;693.0174,444.9726;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;201;183.6282,425.7818;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;202;-43.51083,373.19;Inherit;False;Property;_ThresholdAlpha;Threshold Alpha;9;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;200;-74.37457,449.5584;Inherit;False;Property;_SmoothnessAlpha;Smoothness Alpha;10;0;Create;True;0;0;0;False;0;False;1.12;1.12;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;174;949.6211,-30.11382;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;CampfireShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SmoothstepOpNode;226;468.9186,574.7552;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;216;128.5374,752.1345;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;227;11.46166,676.9011;Inherit;False;Property;_SmoothnessEdge;Smoothness Edge;13;0;Create;True;0;0;0;False;0;False;0.79;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;229;270.3272,658.4578;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;228;49.32719,596.4578;Inherit;False;Property;_ThresholdEdge;Threshold Edge;14;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
WireConnection;184;1;113;0
WireConnection;184;2;111;0
WireConnection;186;0;184;0
WireConnection;188;0;186;0
WireConnection;113;0;112;0
WireConnection;113;1;23;0
WireConnection;111;0;106;0
WireConnection;111;1;23;0
WireConnection;189;1;128;0
WireConnection;189;2;191;0
WireConnection;22;0;189;0
WireConnection;22;1;188;0
WireConnection;16;0;15;2
WireConnection;148;0;182;0
WireConnection;148;1;22;0
WireConnection;89;0;16;0
WireConnection;89;1;148;1
WireConnection;89;2;91;0
WireConnection;172;0;17;0
WireConnection;172;1;164;0
WireConnection;172;2;165;0
WireConnection;165;0;89;0
WireConnection;165;1;197;0
WireConnection;165;2;199;0
WireConnection;199;0;197;0
WireConnection;199;1;198;0
WireConnection;19;0;11;0
WireConnection;19;1;202;0
WireConnection;19;2;201;0
WireConnection;11;0;16;0
WireConnection;11;1;148;1
WireConnection;11;2;20;0
WireConnection;222;0;226;0
WireConnection;222;1;19;0
WireConnection;201;0;202;0
WireConnection;201;1;200;0
WireConnection;174;2;172;0
WireConnection;174;9;222;0
WireConnection;226;0;216;1
WireConnection;226;1;228;0
WireConnection;226;2;229;0
WireConnection;229;0;228;0
WireConnection;229;1;227;0
ASEEND*/
//CHKSM=A805A6C7EAD85F964C3896091552A123237AD945