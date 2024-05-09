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
		_HorizontalWindSpeed("HorizontalWindSpeed", Range( 0 , 0.3)) = 0.8514508
		_horizontalWindStrength("horizontalWindStrength", Range( 0 , 5)) = 5.576886
		_HorizontalNoise("HorizontalNoise", 2D) = "white" {}
		_FrontalWindSpeed("FrontalWindSpeed", Range( 0 , 0.3)) = 0.8514508
		_FrontalWindStrength("FrontalWindStrength", Range( 1 , 5)) = 0
		_FrontalNoise("FrontalNoise", 2D) = "white" {}
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

		uniform sampler2D _FrontalNoise;
		uniform float4 _ST;
		uniform float _FrontalWindSpeed;
		uniform float _FrontalWindStrength;
		uniform sampler2D _HorizontalNoise;
		uniform float _HorizontalWindSpeed;
		uniform float _horizontalWindStrength;
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
		uniform float _ThresholdAlpha;
		uniform float _SmoothnessAlpha;
		uniform float _ShapeTextureInfluence;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 temp_cast_0 = (( _FrontalWindSpeed * _Time.y )).xx;
			float2 uv_TexCoord438 = v.texcoord.xy * _ST.xy + temp_cast_0;
			float2 panner439 = ( 1.0 * _Time.y * _ST.zw + uv_TexCoord438);
			float4 temp_cast_1 = (1.0).xxxx;
			float temp_output_2_0_g6 = v.texcoord.xy.y;
			float3 ase_vertexNormal = v.normal.xyz;
			float2 temp_cast_2 = (( _HorizontalWindSpeed * _Time.y )).xx;
			float2 uv_TexCoord471 = v.texcoord.xy * _ST.xy + temp_cast_2;
			float2 panner469 = ( 1.0 * _Time.y * _ST.zw + uv_TexCoord471);
			float4 temp_cast_3 = (0.5).xxxx;
			float temp_output_2_0_g7 = v.texcoord.xy.y;
			float4 ase_vertexTangent = v.tangent;
			v.vertex.xyz += ( ( ( ( ( tex2Dlod( _FrontalNoise, float4( panner439, 0, 0.0) ) - temp_cast_1 ) * ( temp_output_2_0_g6 * temp_output_2_0_g6 ) ).r * _FrontalWindStrength ) * ase_vertexNormal ) + ( ( ( ( tex2Dlod( _HorizontalNoise, float4( panner469, 0, 0.0) ) - temp_cast_3 ) * ( temp_output_2_0_g7 * temp_output_2_0_g7 ) ).g * _horizontalWindStrength ) * ase_vertexTangent.xyz ) );
			v.vertex.w = 1;
		}

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
			float lerpResult11 = lerp( ( temp_output_16_0 * i.vertexColor.r ) , tex2DNode148.r , _ShapeTextureInfluence);
			float smoothstepResult19 = smoothstep( _ThresholdAlpha , ( _ThresholdAlpha + _SmoothnessAlpha ) , lerpResult11);
			o.Alpha = smoothstepResult19;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 

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
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
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
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
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
Node;AmplifyShaderEditor.CommentaryNode;435;-2920.445,1281.917;Inherit;False;2006.4;562.0096;Caustic randomizer;13;454;376;387;442;441;438;440;439;437;458;453;456;455;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;230;-2557.934,35.62927;Inherit;False;1243.889;552.2267;Panning parameters;11;184;186;188;112;113;111;106;23;189;128;191;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;171;-851.7374,-947.4621;Inherit;False;1518.539;857.3932;Color management;9;91;198;197;199;165;172;164;17;89;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;22;-1273.683,270.0873;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;15;-1088.797,29.76336;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;182;-1283.733,444.6929;Inherit;True;Property;_CausticTexture;Caustic Texture;0;0;Create;True;0;0;0;False;0;False;d7be84cbf4e328a4fb89ee5db3add904;d7be84cbf4e328a4fb89ee5db3add904;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.LerpOp;89;-458.9578,-367.0691;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;17;-15.4397,-858.5276;Inherit;False;Property;_MidFlamesColor;MidFlamesColor;6;1;[HDR];Create;True;0;0;0;False;0;False;1.498039,0.4171922,0.06441575,0;0.572549,0.0520649,0.03664314,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;164;-16.9184,-667.9318;Inherit;False;Property;_OriginZoneColor;OriginZoneColor;5;1;[HDR];Create;True;0;0;0;False;0;False;4.541206,2.419898,0.3224255,0;3.44159,2.173364,0.9051382,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;172;366.7632,-690.1913;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;91;-801.5918,-317.5912;Inherit;False;Property;_ColorTextureInfluence;Color Texture Influence;8;0;Create;True;0;0;0;False;0;False;0.2;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-942.6115,450.9158;Inherit;False;Property;_ShapeTextureInfluence;Shape Texture Influence;7;0;Create;True;0;0;0;False;0;False;0.3;0.362;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;11;-431.5249,253.3101;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;228;-478.3546,527.5332;Inherit;False;Property;_ThresholdEdge;Threshold Edge;14;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;226;-127.5732,507.981;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;184;-1856.615,382.4065;Inherit;False;BuildVector2;-1;;2;fd1658ce95754324891cc2cf05e64ec3;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleRemainderNode;186;-1667.615,381.4065;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;1,1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;188;-1492.045,380.9751;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;112;-2275.925,329.7293;Inherit;False;Property;_HorizontalSpeed;HorizontalSpeed;4;0;Create;True;0;0;0;False;0;False;0.5;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;-2032.395,331.6165;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;111;-2033.833,450.856;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;106;-2237.815,450.1732;Inherit;False;Property;_VerticalSpeed;VerticalSpeed;3;0;Create;True;0;0;0;False;0;False;0.6;0.65;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;23;-2507.934,357.2055;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;128;-1769.528,85.62927;Inherit;False;Property;_HorizontalTiling;HorizontalTiling;2;0;Create;True;0;0;0;False;0;False;0.6;0.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;191;-1770.499,208.1614;Inherit;False;Property;_VerticalTiling;VerticalTiling;1;0;Create;True;0;0;0;False;0;False;0.4;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;19;449.2983,228.2361;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.25;False;2;FLOAT;0.7;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;201;299.7787,60.1892;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;202;51.52268,57.75018;Inherit;False;Property;_ThresholdAlpha;Threshold Alpha;9;0;Create;True;0;0;0;False;0;False;0;0.14;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;200;20.65895,134.1185;Inherit;False;Property;_SmoothnessAlpha;Smoothness Alpha;10;0;Create;True;0;0;0;False;0;False;1.12;0.12;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;189;-1525.699,226.5947;Inherit;False;BuildVector2;-1;;3;fd1658ce95754324891cc2cf05e64ec3;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;174;796.1987,36.17974;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;CampfireShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.RangedFloatNode;227;-507.2201,607.9765;Inherit;False;Property;_SmoothnessEdge;Smoothness Edge;13;0;Create;True;0;0;0;False;0;False;0.79;0.22;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;229;-257.3545,589.5332;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;148;-929.1707,248.2846;Inherit;True;Property;_T_Caustics;T_Caustics;2;0;Create;True;0;0;0;False;0;False;-1;None;d7be84cbf4e328a4fb89ee5db3add904;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;165;193.3727,-369.6071;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.65;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;199;57.96035,-216.536;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;197;-165.8611,-270.4448;Inherit;False;Property;_ThresholdColor;Threshold Color;11;0;Create;True;0;0;0;False;0;False;0.09;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;198;-200.0415,-192.7594;Inherit;False;Property;_SmoothnessColor;Smoothness Color;12;0;Create;True;0;0;0;False;0;False;1.26;0.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;16;-834.197,31.29226;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;216;-839.6686,543.8118;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;436;-595.2811,72.47856;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;222;64.43715,377.7492;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;460;-2895.665,2002.071;Inherit;False;2006.4;562.0096;Caustic randomizer;13;473;472;471;470;469;468;467;466;465;464;463;462;461;;1,1,1,1;0;0
Node;AmplifyShaderEditor.BreakToComponentsNode;453;-1053.135,1500.871;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;454;-1226.407,1499.525;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;441;-1402.359,1499.117;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;439;-1921.716,1454.161;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;455;-1792.527,1695.967;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;469;-1896.935,2192.262;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;464;-1607.975,2412.233;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;466;-1566.391,2317.823;Inherit;False;Constant;_Float2;Float 1;21;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;465;-1392.578,2203.273;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;461;-1005.351,2205.027;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.TextureCoordinatesNode;471;-2142.228,2085.049;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;470;-1700.02,2126.042;Inherit;True;Property;_HorizontalNoise;HorizontalNoise;17;0;Create;True;0;0;0;False;0;False;-1;20523dce59b62b6469b86087d24b7f6a;20523dce59b62b6469b86087d24b7f6a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;423;-855.8809,2348.465;Inherit;False;Property;_horizontalWindStrength;horizontalWindStrength;16;0;Create;True;0;0;0;False;0;False;5.576886;1.34;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;452;-516.0569,1603.419;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;475;-621.4337,1497.844;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;474;-873.6218,1640.776;Inherit;False;Property;_FrontalWindStrength;FrontalWindStrength;19;0;Create;True;0;0;0;False;0;False;0;2.14;1;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;451;-323.8257,1497.636;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;414;151.5702,1839.181;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureTransformNode;437;-2422.104,1454.517;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;438;-2161.299,1358.725;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;456;-1545.956,1744.12;Inherit;False;Square;-1;;6;fea980a1f68019543b2cd91d506986e8;0;1;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;442;-1576.172,1616.667;Inherit;False;Constant;_Float1;Float 1;21;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;440;-1681.014,1429.281;Inherit;True;Property;_FrontalNoise;FrontalNoise;20;0;Create;True;0;0;0;False;0;False;-1;20523dce59b62b6469b86087d24b7f6a;20523dce59b62b6469b86087d24b7f6a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;463;-1358.322,2458.845;Inherit;False;Square;-1;;7;fea980a1f68019543b2cd91d506986e8;0;1;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;462;-1198.624,2205.681;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;457;-553.6038,2229.138;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TangentVertexDataNode;419;-348.6342,2340.137;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;417;-160.7713,2231.293;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleTimeNode;376;-2810.448,1430.009;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;387;-2614.928,1404.822;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;458;-2893.738,1324.589;Inherit;False;Property;_FrontalWindSpeed;FrontalWindSpeed;18;0;Create;True;0;0;0;False;0;False;0.8514508;0.045;0;0.3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;472;-2764.178,2157.407;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;467;-2849.468,2050.986;Inherit;False;Property;_HorizontalWindSpeed;HorizontalWindSpeed;15;0;Create;True;0;0;0;False;0;False;0.8514508;0.005207697;0;0.3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;473;-2573.657,2133.219;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureTransformNode;468;-2388.938,2238.26;Inherit;False;-1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
WireConnection;22;0;189;0
WireConnection;22;1;188;0
WireConnection;89;0;16;0
WireConnection;89;1;148;1
WireConnection;89;2;91;0
WireConnection;172;0;17;0
WireConnection;172;1;164;0
WireConnection;172;2;165;0
WireConnection;11;0;436;0
WireConnection;11;1;148;1
WireConnection;11;2;20;0
WireConnection;226;0;216;1
WireConnection;226;1;228;0
WireConnection;226;2;229;0
WireConnection;184;1;113;0
WireConnection;184;2;111;0
WireConnection;186;0;184;0
WireConnection;188;0;186;0
WireConnection;113;0;112;0
WireConnection;113;1;23;0
WireConnection;111;0;106;0
WireConnection;111;1;23;0
WireConnection;19;0;11;0
WireConnection;19;1;202;0
WireConnection;19;2;201;0
WireConnection;201;0;202;0
WireConnection;201;1;200;0
WireConnection;189;1;128;0
WireConnection;189;2;191;0
WireConnection;174;2;172;0
WireConnection;174;9;19;0
WireConnection;174;11;414;0
WireConnection;229;0;228;0
WireConnection;229;1;227;0
WireConnection;148;0;182;0
WireConnection;148;1;22;0
WireConnection;165;0;89;0
WireConnection;165;1;197;0
WireConnection;165;2;199;0
WireConnection;199;0;197;0
WireConnection;199;1;198;0
WireConnection;16;0;15;2
WireConnection;436;0;16;0
WireConnection;436;1;216;1
WireConnection;222;0;226;0
WireConnection;222;1;11;0
WireConnection;453;0;454;0
WireConnection;454;0;441;0
WireConnection;454;1;456;0
WireConnection;441;0;440;0
WireConnection;441;1;442;0
WireConnection;439;0;438;0
WireConnection;439;2;437;1
WireConnection;469;0;471;0
WireConnection;469;2;468;1
WireConnection;465;0;470;0
WireConnection;465;1;466;0
WireConnection;461;0;462;0
WireConnection;471;0;468;0
WireConnection;471;1;473;0
WireConnection;470;1;469;0
WireConnection;475;0;453;0
WireConnection;475;1;474;0
WireConnection;451;0;475;0
WireConnection;451;1;452;0
WireConnection;414;0;451;0
WireConnection;414;1;417;0
WireConnection;438;0;437;0
WireConnection;438;1;387;0
WireConnection;456;2;455;2
WireConnection;440;1;439;0
WireConnection;463;2;464;2
WireConnection;462;0;465;0
WireConnection;462;1;463;0
WireConnection;457;0;461;1
WireConnection;457;1;423;0
WireConnection;417;0;457;0
WireConnection;417;1;419;0
WireConnection;387;0;458;0
WireConnection;387;1;376;0
WireConnection;473;0;467;0
WireConnection;473;1;472;0
ASEEND*/
//CHKSM=9BA125160882B2C548AD6A60B9CDACB368DA68A0