// Made with Amplify Shader Editor v1.9.2.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "TextureSlideShader"
{
	Properties
	{
		_TextureHeight("TextureHeight", Range( 0 , 10)) = 0.31
		_TextureWidth("TextureWidth", Range( 0 , 10)) = 0.4
		_StartingOffset("StartingOffset", Range( -5 , 1)) = 0
		_Arrowtexture("Arrowtexture", 2D) = "white" {}
		_T_Caustics("T_Caustics", 2D) = "white" {}
		_MainColor("MainColor", Color) = (0.0518868,0.1089666,1,0)
		_EdgesColor("EdgesColor", Color) = (1,0,0,0)
		_CausticInfluence("CausticInfluence", Range( 0 , 1)) = 0.1831616
		_ColorCausticInfluence("ColorCausticInfluence", Range( 0 , 1)) = 0.1831616
		_ShapeSmoothness("ShapeSmoothness", Range( 0 , 1)) = 0.5070589
		_ColorShapeSmoothness("ColorShapeSmoothness", Range( 0 , 1)) = 0.5070589
		_ShapeThreshold("ShapeThreshold", Range( 0 , 1)) = 0.134336
		_ColorShapeThreshold("ColorShapeThreshold", Range( 0 , 1)) = 0.134336
		_CausticTiling("CausticTiling", Vector) = (0,0,0,0)
		_CausticSpeed("CausticSpeed", Range( 0 , 2)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit alpha:fade keepalpha noshadow exclude_path:deferred 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 uv_texcoord;
		};

		uniform float4 _EdgesColor;
		uniform float4 _MainColor;
		uniform float _ColorShapeThreshold;
		uniform float _ColorShapeSmoothness;
		uniform sampler2D _Arrowtexture;
		uniform float _TextureWidth;
		uniform float _TextureHeight;
		uniform float _StartingOffset;
		uniform sampler2D _T_Caustics;
		uniform float2 _CausticTiling;
		uniform float _CausticSpeed;
		uniform float _ColorCausticInfluence;
		uniform float _ShapeThreshold;
		uniform float _ShapeSmoothness;
		uniform float _CausticInfluence;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float temp_output_72_0 = ( 1.0 / _TextureHeight );
			float4 appendResult73 = (float4(( 1.0 / _TextureWidth ) , temp_output_72_0 , 0.0 , 0.0));
			float temp_output_144_0 = ( _StartingOffset * -1.0 );
			float4 appendResult55 = (float4(( ( ( i.uv_texcoord.z * -1.0 ) * ( temp_output_144_0 + 1.0 ) ) + temp_output_144_0 ) , ( ( 1.0 - temp_output_72_0 ) / ( temp_output_72_0 * 2.0 ) ) , 0.0 , 0.0));
			float2 uvs_TexCoord56 = i.uv_texcoord;
			uvs_TexCoord56.xy = i.uv_texcoord.xy + appendResult55.xy;
			float4 tex2DNode83 = tex2D( _Arrowtexture, ( appendResult73 * float4( uvs_TexCoord56.xy, 0.0 , 0.0 ) ).xy );
			float2 appendResult93 = (float2(0.0 , ( ( 1.0 - _Time.y ) * _CausticSpeed )));
			float2 uvs_TexCoord91 = i.uv_texcoord;
			uvs_TexCoord91.xy = i.uv_texcoord.xy * _CausticTiling + appendResult93;
			float4 tex2DNode90 = tex2D( _T_Caustics, uvs_TexCoord91.xy );
			float lerpResult150 = lerp( tex2DNode83.r , tex2DNode90.r , _ColorCausticInfluence);
			float smoothstepResult148 = smoothstep( _ColorShapeThreshold , ( _ColorShapeThreshold + _ColorShapeSmoothness ) , lerpResult150);
			float4 lerpResult129 = lerp( _EdgesColor , _MainColor , smoothstepResult148);
			o.Emission = lerpResult129.rgb;
			float lerpResult96 = lerp( tex2DNode83.r , tex2DNode90.r , _CausticInfluence);
			float smoothstepResult98 = smoothstep( _ShapeThreshold , ( _ShapeThreshold + _ShapeSmoothness ) , lerpResult96);
			o.Alpha = smoothstepResult98;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19201
Node;AmplifyShaderEditor.CommentaryNode;149;38.40616,173.9754;Inherit;False;1328.625;304;Alpha;6;96;98;100;99;101;97;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;143;-1942.54,1021.981;Inherit;False;1015.654;299.5461;To adjust starting point;5;142;134;135;141;144;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;132;21.35443,-373.1672;Inherit;False;1818.479;430.895;Color;9;151;150;147;146;145;148;129;127;125;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;131;-1974.71,209.4337;Inherit;False;1978.235;738.8478;Texture position;11;88;82;64;71;69;28;83;73;72;70;56;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;130;-1747.075,-354.6379;Inherit;False;1571.034;498.3452;Caustic pan;8;92;94;93;91;90;173;174;175;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;88;-1889.756,687.5527;Inherit;False;388;251;Custom channels (W = texture progress along mesh);1;87;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;82;-1482.174,760.5792;Inherit;False;228;187;Inverse to move toward right side;1;80;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;64;-1426.3,446.3667;Inherit;False;594.0923;299.231;Offset to always centralize the tiled texture;4;55;62;61;63;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;71;-1653.501,260.7626;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;55;-1010.208,496.3667;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;61;-1180.235,519.6339;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-1355.508,608.5967;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;62;-1363.398,522.383;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-474.0418,428.8912;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;83;-308.4705,405.8524;Inherit;True;Property;_Arrowtexture;Arrowtexture;3;0;Create;True;0;0;0;False;0;False;-1;474d7a3eb26e4c14e930390837517da4;4feb7ebdc77c55a4696ff00935bb6dc7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;73;-1200.976,259.4337;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;72;-1658.165,409.334;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;56;-781.6082,453.3016;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;-1432.174,810.5792;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;87;-1810.372,739.2809;Inherit;False;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;142;-1379.848,1184.528;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;135;-1072.885,1071.981;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;141;-1240.57,1072.765;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;144;-1594.315,1182.596;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;134;-1892.54,1182.749;Inherit;False;Property;_StartingOffset;StartingOffset;2;0;Create;True;0;0;0;False;0;False;0;-0.5;-5;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;70;-1923.515,430.8647;Inherit;False;Property;_TextureHeight;TextureHeight;0;0;Create;True;0;0;0;False;0;False;0.31;3.7;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;69;-1924.708,285.1829;Inherit;False;Property;_TextureWidth;TextureWidth;1;0;Create;True;0;0;0;False;0;False;0.4;1.5;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;118;1996.487,-51.64023;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;TextureSlideShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SmoothstepOpNode;98;1124.142,226.2515;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;96;397.1211,218.1895;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;97;70.1044,342.1109;Inherit;False;Property;_CausticInfluence;CausticInfluence;8;0;Create;True;0;0;0;False;0;False;0.1831616;0.38;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;125;1282.404,-307.5855;Inherit;False;Property;_EdgesColor;EdgesColor;7;0;Create;True;0;0;0;False;0;False;1,0,0,0;0.7372549,0.454902,0.7372549,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;127;1282.815,-136.1571;Inherit;False;Property;_MainColor;MainColor;6;0;Create;True;0;0;0;False;0;False;0.0518868,0.1089666,1,0;1,0.9215687,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;129;1585.879,-306.2324;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;148;1055.2,-267.8699;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;145;935.0175,-219.0092;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;146;627.4011,-248.8925;Inherit;False;Property;_ColorShapeThreshold;ColorShapeThreshold;13;0;Create;True;0;0;0;False;0;False;0.134336;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;147;629.106,-164.8989;Inherit;False;Property;_ColorShapeSmoothness;ColorShapeSmoothness;11;0;Create;True;0;0;0;False;0;False;0.5070589;0.54;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;150;342.0204,-270.091;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;151;34.57471,-218.0213;Inherit;False;Property;_ColorCausticInfluence;ColorCausticInfluence;9;0;Create;True;0;0;0;False;0;False;0.1831616;0.15;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;90;-592,-288;Inherit;True;Property;_T_Caustics;T_Caustics;5;0;Create;True;0;0;0;False;0;False;-1;d7be84cbf4e328a4fb89ee5db3add904;d7be84cbf4e328a4fb89ee5db3add904;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;91;-817.8897,-265.6572;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;93;-1010.087,-142.6689;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;94;-1524.87,-118.0999;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;92;-1720.785,-119.7132;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;165;1375.484,762.8726;Inherit;True;Property;_T_Caustics1;T_Caustics;4;0;Create;True;0;0;0;False;0;False;-1;d7be84cbf4e328a4fb89ee5db3add904;d7be84cbf4e328a4fb89ee5db3add904;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;166;415.4837,1066.873;Inherit;False;Property;_CausticScrollingSpeed1;CausticScrollingSpeed;15;0;Create;True;0;0;0;False;0;False;1;0.15;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;167;719.4835,922.8726;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;168;925.9701,741.6616;Inherit;False;Property;_CausticTiling1;CausticTiling;14;0;Create;True;0;0;0;False;0;False;0,0;0.1,1.44;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;169;1159.648,778.539;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;170;967.4501,901.5272;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;171;452.6669,926.0961;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;172;256.7525,924.4828;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;161;1764.215,784.7616;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;0.15;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;160;1965.43,573.6747;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;101;958.0463,332.4391;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;99;650.4258,302.5558;Inherit;False;Property;_ShapeThreshold;ShapeThreshold;12;0;Create;True;0;0;0;False;0;False;0.134336;0.54;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;100;652.1307,386.5501;Inherit;False;Property;_ShapeSmoothness;ShapeSmoothness;10;0;Create;True;0;0;0;False;0;False;0.5070589;0.02;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;173;-1023.052,-295.1472;Inherit;False;Property;_CausticTiling;CausticTiling;18;0;Create;True;0;0;0;False;0;False;0,0;0.31,0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;175;-1240.957,-130.3899;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;174;-1462.404,25.50919;Inherit;False;Property;_CausticSpeed;CausticSpeed;19;0;Create;True;0;0;0;False;0;False;0;0.1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;162;1247.484,1082.873;Inherit;False;Property;_CausticSmoothness1;CausticSmoothness;17;0;Create;True;0;0;0;False;0;False;0;0.05;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;163;1535.484,1066.873;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;164;1247.484,1002.873;Inherit;False;Property;_CausticThreshold1;CausticThreshold;16;0;Create;True;0;0;0;False;0;False;0;0.04;0;1;0;1;FLOAT;0
WireConnection;71;1;69;0
WireConnection;55;0;135;0
WireConnection;55;1;61;0
WireConnection;61;0;62;0
WireConnection;61;1;63;0
WireConnection;63;0;72;0
WireConnection;62;0;72;0
WireConnection;28;0;73;0
WireConnection;28;1;56;0
WireConnection;83;1;28;0
WireConnection;73;0;71;0
WireConnection;73;1;72;0
WireConnection;72;1;70;0
WireConnection;56;1;55;0
WireConnection;80;0;87;3
WireConnection;142;0;144;0
WireConnection;135;0;141;0
WireConnection;135;1;144;0
WireConnection;141;0;80;0
WireConnection;141;1;142;0
WireConnection;144;0;134;0
WireConnection;118;2;129;0
WireConnection;118;9;98;0
WireConnection;98;0;96;0
WireConnection;98;1;99;0
WireConnection;98;2;101;0
WireConnection;96;0;83;1
WireConnection;96;1;90;1
WireConnection;96;2;97;0
WireConnection;129;0;125;0
WireConnection;129;1;127;0
WireConnection;129;2;148;0
WireConnection;148;0;150;0
WireConnection;148;1;146;0
WireConnection;148;2;145;0
WireConnection;145;0;146;0
WireConnection;145;1;147;0
WireConnection;150;0;83;1
WireConnection;150;1;90;1
WireConnection;150;2;151;0
WireConnection;90;1;91;0
WireConnection;91;0;173;0
WireConnection;91;1;93;0
WireConnection;93;1;175;0
WireConnection;94;0;92;0
WireConnection;165;1;169;0
WireConnection;167;0;171;0
WireConnection;167;1;166;0
WireConnection;169;0;168;0
WireConnection;169;1;170;0
WireConnection;170;0;167;0
WireConnection;171;0;172;0
WireConnection;161;0;165;1
WireConnection;161;1;164;0
WireConnection;161;2;163;0
WireConnection;160;0;161;0
WireConnection;160;1;98;0
WireConnection;101;0;99;0
WireConnection;101;1;100;0
WireConnection;175;0;94;0
WireConnection;175;1;174;0
WireConnection;163;0;164;0
WireConnection;163;1;162;0
ASEEND*/
//CHKSM=D44A3990E454967A2C37D3C3AD47767F61F9C342