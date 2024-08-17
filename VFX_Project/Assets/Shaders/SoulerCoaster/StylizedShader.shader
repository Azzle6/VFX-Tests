// Made with Amplify Shader Editor v1.9.2.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "StylizedShader"
{
	Properties
	{
		_TopColor("TopColor", Color) = (0.509434,0.08891065,0.08891065,0)
		_BottomColor("BottomColor", Color) = (0.3090605,0.06207725,0.4245283,0)
		_HeightColorsSmoothness("HeightColorsSmoothness", Range( 0 , 2)) = 3.446382
		_EdgesColor("EdgesColor", Color) = (0.6636297,0,0.8396226,0)
		_EdgeWidth("EdgeWidth", Range( 0.01 , 1)) = 0.2585194
		_EdgeSharpness("EdgeSharpness", Range( 0 , 0.99)) = 0
		_SpecularColor("SpecularColor", Color) = (0.772549,0.7547418,0.4164039,0)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			float3 viewDir;
			float3 worldRefl;
			INTERNAL_DATA
		};

		uniform float4 _TopColor;
		uniform float4 _BottomColor;
		uniform float _HeightColorsSmoothness;
		uniform float _EdgeWidth;
		uniform float _EdgeSharpness;
		uniform float4 _EdgesColor;
		uniform float4 _SpecularColor;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float smoothstepResult58 = smoothstep( _HeightColorsSmoothness , ( _HeightColorsSmoothness * -1.0 ) , ase_vertex3Pos.y);
			float4 lerpResult54 = lerp( _TopColor , _BottomColor , smoothstepResult58);
			float3 ase_worldNormal = i.worldNormal;
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float dotResult8 = dot( ase_normWorldNormal , i.viewDir );
			float smoothstepResult66 = smoothstep( _EdgeWidth , ( _EdgeWidth * _EdgeSharpness ) , dotResult8);
			float4 temp_output_14_0 = ( smoothstepResult66 * _EdgesColor );
			float3 ase_worldReflection = normalize( i.worldRefl );
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult17 = dot( ase_worldReflection , ase_worldlightDir );
			float smoothstepResult26 = smoothstep( 0.7 , 0.8 , dotResult17);
			float4 temp_output_57_0 = ( smoothstepResult26 * _SpecularColor );
			float dotResult35 = dot( ase_worldNormal , i.viewDir );
			float4 color45 = IsGammaSpace() ? float4(0.5149608,0.2172549,0.7843137,0) : float4(0.2281509,0.03873786,0.5775805,0);
			float4 temp_output_37_0 = ( ( 1.0 - dotResult35 ) * color45 );
			o.Emission = ( lerpResult54 + temp_output_14_0 + temp_output_57_0 + temp_output_37_0 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit keepalpha fullforwardshadows 

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
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float4 tSpace0 : TEXCOORD1;
				float4 tSpace1 : TEXCOORD2;
				float4 tSpace2 : TEXCOORD3;
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
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
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
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = worldViewDir;
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.worldRefl = -worldViewDir;
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
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
Node;AmplifyShaderEditor.CommentaryNode;56;-1596.981,-610.8285;Inherit;False;1075.666;658.7481;height related color;7;61;58;54;51;55;53;59;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;46;-1475.334,1209.521;Inherit;False;886.2387;503.142;Basic fresnel;6;34;35;36;37;45;47;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;28;-2318.26,123.3562;Inherit;False;1601.216;425.4492;Edges Fresnel;9;32;8;10;9;14;66;69;70;74;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;25;-1816.064,618.2645;Inherit;False;1137.301;455.9659;Specular;6;44;26;17;11;16;57;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;16;-1761.249,831.4385;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldReflectionVector;11;-1766.064,668.2645;Inherit;False;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SmoothstepOpNode;26;-1362.295,733.4879;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.7;False;2;FLOAT;0.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;34;-1425.334,1260.249;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;36;-1425.334,1456.39;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.OneMinusNode;47;-1077.255,1261.828;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-777.4949,1264.037;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DotProductOpNode;35;-1216.675,1263.225;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;17;-1496.569,733.0319;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;45;-1024.986,1427.138;Inherit;False;Constant;_FresnelColor;FresnelColor;3;0;Create;True;0;0;0;False;0;False;0.5149608,0.2172549,0.7843137,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;44;-1157.23,881.1934;Inherit;False;Property;_SpecularColor;SpecularColor;6;0;Create;True;0;0;0;False;0;False;0.772549,0.7547418,0.4164039,0;0.772549,0.7547418,0.4164039,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-879.4777,731.3804;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;53;-1456.861,-565.6998;Inherit;False;Property;_TopColor;TopColor;0;0;Create;True;0;0;0;False;0;False;0.509434,0.08891065,0.08891065,0;0.5301,0.2084154,0.589,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;55;-1455.7,-396.9531;Inherit;False;Property;_BottomColor;BottomColor;1;0;Create;True;0;0;0;False;0;False;0.3090605,0.06207725,0.4245283,0;0.1345926,0.02725925,0.184,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;51;-1462.405,-227.292;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;58;-1043.97,-174.7331;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-1209.822,-82.63537;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-1554.318,-85.65861;Inherit;False;Property;_HeightColorsSmoothness;HeightColorsSmoothness;2;0;Create;True;0;0;0;False;0;False;3.446382;0.378;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;54;-792.9464,-389.273;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DotProductOpNode;8;-1781.467,197.108;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;9;-2008.782,194.1325;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;10;-1995.661,392.4785;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;-1498.858,380.0355;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;66;-1363.978,197.3829;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;32;-1153.062,382.0312;Inherit;False;Property;_EdgesColor;EdgesColor;3;0;Create;True;0;0;0;False;0;False;0.6636297,0,0.8396226,0;0.1407001,0,0.603,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;70;-1779.952,320.0449;Inherit;False;Property;_EdgeWidth;EdgeWidth;4;0;Create;True;0;0;0;False;0;False;0.2585194;0.382;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;69;-1777.894,406.3156;Inherit;False;Property;_EdgeSharpness;EdgeSharpness;5;0;Create;True;0;0;0;False;0;False;0;0.843;0;0.99;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;1;179.5762,6.650966;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;StylizedShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;227.8643,-700.3336;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;76;430.877,-699.0248;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;6;20.19518,-699.7541;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;77;-355.7122,159.6119;Inherit;True;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-925.3704,209.443;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;75;37.32749,-480.2087;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
WireConnection;26;0;17;0
WireConnection;47;0;35;0
WireConnection;37;0;47;0
WireConnection;37;1;45;0
WireConnection;35;0;34;0
WireConnection;35;1;36;0
WireConnection;17;0;11;0
WireConnection;17;1;16;0
WireConnection;57;0;26;0
WireConnection;57;1;44;0
WireConnection;58;0;51;2
WireConnection;58;1;59;0
WireConnection;58;2;61;0
WireConnection;61;0;59;0
WireConnection;54;0;53;0
WireConnection;54;1;55;0
WireConnection;54;2;58;0
WireConnection;8;0;9;0
WireConnection;8;1;10;0
WireConnection;74;0;70;0
WireConnection;74;1;69;0
WireConnection;66;0;8;0
WireConnection;66;1;70;0
WireConnection;66;2;74;0
WireConnection;1;2;77;0
WireConnection;63;0;6;0
WireConnection;63;1;75;0
WireConnection;76;0;63;0
WireConnection;76;1;14;0
WireConnection;6;0;54;0
WireConnection;6;1;57;0
WireConnection;6;2;37;0
WireConnection;77;0;54;0
WireConnection;77;1;14;0
WireConnection;77;2;57;0
WireConnection;77;3;37;0
WireConnection;14;0;66;0
WireConnection;14;1;32;0
WireConnection;75;0;66;0
ASEEND*/
//CHKSM=1628AA591358326A82662AF20F3D3D30DA8D4B4F