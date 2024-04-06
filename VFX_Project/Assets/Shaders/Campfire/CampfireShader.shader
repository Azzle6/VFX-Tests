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
		_FaceWindVariationSpeed("FaceWindVariationSpeed", Range( 0 , 10)) = 1
		_WindStretchStrength("WindStretchStrength", Range( 0 , 30)) = 3
		_Oscillation("Oscillation", Range( 0 , 1)) = 1
		_horizontalWind("horizontalWind", Range( -10 , 10)) = 5.576886
		_BendingStrength("BendingStrength", Float) = 0
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

		uniform float _FaceWindVariationSpeed;
		uniform float _Oscillation;
		uniform float _BendingStrength;
		uniform float _WindStretchStrength;
		uniform float _horizontalWind;
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
		uniform float _ThresholdEdge;
		uniform float _SmoothnessEdge;
		uniform float _ShapeTextureInfluence;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float temp_output_429_0 = ( ase_vertex3Pos.y * _BendingStrength * ase_vertex3Pos.y );
			float temp_output_372_0 = ( ( 1.0 - ( ( ( sin( ( _FaceWindVariationSpeed * _Time.y ) ) + 1.0 ) / 2.0 ) * _Oscillation ) ) * temp_output_429_0 );
			float3 ase_vertexNormal = v.normal.xyz;
			float4 ase_vertexTangent = v.tangent;
			float mulTime424 = _Time.y * 4.0;
			v.vertex.xyz += ( ( temp_output_372_0 * ase_vertexNormal * -1.0 * _WindStretchStrength ) + ( ase_vertexTangent.xyz * temp_output_372_0 * ( temp_output_429_0 * sin( mulTime424 ) * _horizontalWind ) ) );
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
			float smoothstepResult226 = smoothstep( _ThresholdEdge , ( _ThresholdEdge + _SmoothnessEdge ) , i.vertexColor.r);
			float lerpResult11 = lerp( temp_output_16_0 , tex2DNode148.r , _ShapeTextureInfluence);
			float smoothstepResult19 = smoothstep( _ThresholdAlpha , ( _ThresholdAlpha + _SmoothnessAlpha ) , ( smoothstepResult226 * lerpResult11 ));
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
Node;AmplifyShaderEditor.CommentaryNode;435;-38.78122,1128.19;Inherit;False;840.6478;427.338;Fontal wind;5;372;396;382;385;395;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;434;-407.4485,1614.176;Inherit;False;1225.404;431.4907;Horizontal wind;6;433;432;423;424;417;419;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;315;-121.467,2617.304;Inherit;False;1123.998;1029.61;First attempt;6;301;300;299;282;283;281;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;301;255.2472,2887.724;Inherit;False;258;204.9999;Scale movement with height value;1;297;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;300;133.6859,3098.047;Inherit;False;647.8359;176.9541;Moves in a sinusoidal way vertically;4;295;296;293;294;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;299;241.2367,3411.914;Inherit;False;287;230;Makes vertex move in opposite way;1;298;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;230;-2557.934,35.62927;Inherit;False;1243.889;552.2267;Panning parameters;11;184;186;188;112;113;111;106;23;189;128;191;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;171;-851.7374,-947.4621;Inherit;False;1518.539;857.3932;Color management;9;91;198;197;199;165;172;164;17;89;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;22;-1273.683,270.0873;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;16;-825.4786,79.24251;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;15;-1088.797,29.76336;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;182;-1283.733,444.6929;Inherit;True;Property;_CausticTexture;Caustic Texture;0;0;Create;True;0;0;0;False;0;False;d7be84cbf4e328a4fb89ee5db3add904;d7be84cbf4e328a4fb89ee5db3add904;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.LerpOp;89;-458.9578,-367.0691;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;17;-15.4397,-858.5276;Inherit;False;Property;_MidFlamesColor;MidFlamesColor;6;1;[HDR];Create;True;0;0;0;False;0;False;1.498039,0.4171922,0.06441575,0;0.572549,0.0520649,0.03664314,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;164;-16.9184,-667.9318;Inherit;False;Property;_OriginZoneColor;OriginZoneColor;5;1;[HDR];Create;True;0;0;0;False;0;False;4.541206,2.419898,0.3224255,0;3.44159,2.173364,0.9051382,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;172;366.7632,-690.1913;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;91;-801.5918,-317.5912;Inherit;False;Property;_ColorTextureInfluence;Color Texture Influence;8;0;Create;True;0;0;0;False;0;False;0.2;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-942.6115,450.9158;Inherit;False;Property;_ShapeTextureInfluence;Shape Texture Influence;7;0;Create;True;0;0;0;False;0;False;0.3;0.3;0;1;0;1;FLOAT;0
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
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;222;57.17196,232.4456;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;201;299.7787,60.1892;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;202;51.52268,57.75018;Inherit;False;Property;_ThresholdAlpha;Threshold Alpha;9;0;Create;True;0;0;0;False;0;False;0;0.32;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;200;20.65895,134.1185;Inherit;False;Property;_SmoothnessAlpha;Smoothness Alpha;10;0;Create;True;0;0;0;False;0;False;1.12;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;189;-1525.699,226.5947;Inherit;False;BuildVector2;-1;;3;fd1658ce95754324891cc2cf05e64ec3;0;2;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;174;796.1987,36.17974;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;CampfireShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.RangedFloatNode;227;-507.2201,607.9765;Inherit;False;Property;_SmoothnessEdge;Smoothness Edge;13;0;Create;True;0;0;0;False;0;False;0.79;0.56;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;229;-257.3545,589.5332;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;216;-469.1443,686.2099;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Compare;298;291.2367,3461.915;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;-1;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;297;305.2473,2937.725;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;283;-71.4671,3289.083;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;281;362.8358,2667.304;Inherit;False;Constant;_MovementScaler;MovementScaler;15;0;Create;True;0;0;0;False;0;False;0.1,0.1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;294;186.2497,3148.235;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;6;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;293;341.1371,3149.133;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;296;623.1364,3145.047;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;295;486.299,3147.265;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;282;768.5311,2667.677;Inherit;True;5;5;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;148;-929.1707,248.2846;Inherit;True;Property;_T_Caustics;T_Caustics;2;0;Create;True;0;0;0;False;0;False;-1;None;d7be84cbf4e328a4fb89ee5db3add904;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinOpNode;288;-419.1739,2144.159;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;286;-805.6478,2146.175;Inherit;False;1;0;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;165;193.3727,-369.6071;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.65;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;199;57.96035,-216.536;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;197;-165.8611,-270.4448;Inherit;False;Property;_ThresholdColor;Threshold Color;11;0;Create;True;0;0;0;False;0;False;0.09;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;198;-200.0415,-192.7594;Inherit;False;Property;_SmoothnessColor;Smoothness Color;12;0;Create;True;0;0;0;False;0;False;1.26;0.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;414;841.4595,1489.488;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SinOpNode;433;-78.52956,1763.781;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;432;93.78258,1740.088;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;423;-240.4436,1932.666;Inherit;False;Property;_horizontalWind;horizontalWind;18;0;Create;True;0;0;0;False;0;False;5.576886;7.1;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;424;-357.4485,1761.099;Inherit;False;1;0;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;417;639.9557,1697.068;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TangentVertexDataNode;419;361.0026,1664.176;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;372;11.21879,1252.547;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;396;567.8666,1178.19;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;382;344.5396,1233.934;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;385;376.6184,1373.626;Inherit;False;Constant;_Float0;Float 0;15;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;395;242.437,1442.528;Inherit;False;Property;_WindStretchStrength;WindStretchStrength;16;0;Create;True;0;0;0;False;0;False;3;9.7;0;30;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;387;-1144.202,1070.321;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;408;-858.2728,1182.502;Inherit;False;Property;_Oscillation;Oscillation;17;0;Create;True;0;0;0;False;0;False;1;0.602;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;412;-593.7484,1070.743;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;413;-440.3858,1071.779;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;376;-1352.694,1094.211;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;386;-1450.264,1014.067;Inherit;False;Property;_FaceWindVariationSpeed;FaceWindVariationSpeed;15;0;Create;True;0;0;0;False;0;False;1;4.96;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;377;-974.8982,1072.381;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;311;-839.7699,1070.862;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;310;-714.1241,1071.312;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;428;-716.6287,1264.81;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;429;-447.708,1311.565;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0.15;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;431;-741.0205,1408.497;Inherit;False;Property;_BendingStrength;BendingStrength;19;0;Create;True;0;0;0;False;0;False;0;0.15;0;0;0;1;FLOAT;0
WireConnection;22;0;189;0
WireConnection;22;1;188;0
WireConnection;16;0;15;2
WireConnection;89;0;16;0
WireConnection;89;1;148;1
WireConnection;89;2;91;0
WireConnection;172;0;17;0
WireConnection;172;1;164;0
WireConnection;172;2;165;0
WireConnection;11;0;16;0
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
WireConnection;19;0;222;0
WireConnection;19;1;202;0
WireConnection;19;2;201;0
WireConnection;222;0;226;0
WireConnection;222;1;11;0
WireConnection;201;0;202;0
WireConnection;201;1;200;0
WireConnection;189;1;128;0
WireConnection;189;2;191;0
WireConnection;174;2;172;0
WireConnection;174;9;19;0
WireConnection;174;11;414;0
WireConnection;229;0;228;0
WireConnection;229;1;227;0
WireConnection;298;0;283;1
WireConnection;294;0;283;2
WireConnection;293;0;294;0
WireConnection;296;0;295;0
WireConnection;295;0;293;0
WireConnection;282;0;281;0
WireConnection;282;1;288;0
WireConnection;282;2;296;0
WireConnection;282;3;298;0
WireConnection;282;4;297;2
WireConnection;148;0;182;0
WireConnection;148;1;22;0
WireConnection;288;0;286;0
WireConnection;165;0;89;0
WireConnection;165;1;197;0
WireConnection;165;2;199;0
WireConnection;199;0;197;0
WireConnection;199;1;198;0
WireConnection;414;0;396;0
WireConnection;414;1;417;0
WireConnection;433;0;424;0
WireConnection;432;0;429;0
WireConnection;432;1;433;0
WireConnection;432;2;423;0
WireConnection;417;0;419;0
WireConnection;417;1;372;0
WireConnection;417;2;432;0
WireConnection;372;0;413;0
WireConnection;372;1;429;0
WireConnection;396;0;372;0
WireConnection;396;1;382;0
WireConnection;396;2;385;0
WireConnection;396;3;395;0
WireConnection;387;0;386;0
WireConnection;387;1;376;0
WireConnection;412;0;310;0
WireConnection;412;1;408;0
WireConnection;413;0;412;0
WireConnection;377;0;387;0
WireConnection;311;0;377;0
WireConnection;310;0;311;0
WireConnection;429;0;428;2
WireConnection;429;1;431;0
WireConnection;429;2;428;2
ASEEND*/
//CHKSM=AAAFBBD9C08AE804CB6D3FC9617A5ACFE13677AA