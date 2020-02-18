// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Stylised_Campfire"
{
	Properties
	{
		_Noise_1("Noise_1", 2D) = "white" {}
		_Scale_Noise_1("Scale_Noise_1", Float) = 1
		_Speed_Noise_1("Speed_Noise_1", Float) = -1.5
		_Noise_2("Noise_2", 2D) = "white" {}
		_Scale_Noise_2("Scale_Noise_2", Float) = 0.5
		_Speed_Noise_2("Speed_Noise_2", Float) = -1
		_Noise_Intensity("Noise_Intensity", Float) = 1
		_Shape("Shape", 2D) = "white" {}
		_Intensity_Step_1("Intensity_Step_1", Range( 0 , 1)) = 0.155304
		_Intensity_Step_2("Intensity_Step_2", Range( 0 , 1)) = 0.09487711
		_Intensity_Step_3("Intensity_Step_3", Range( 0 , 1)) = 0.155304
		[HDR]_Color_1("Color_1", Color) = (1.584906,0.8370304,0.1719473,0)
		[HDR]_Color_2("Color_2", Color) = (1.698113,0.9392148,0.264329,0)
		[HDR]_Color_3("Color_3", Color) = (0,0,0,0)
		[HDR]_Top_Color("Top_Color", Color) = (0.3475208,0.7428775,1.701961,0)
		_Top_Color_Blend("Top_Color_Blend", Range( 0 , 1)) = 0.9778624
		_Final_Power("Final_Power", Float) = 1
		_Vertex_Offset("Vertex_Offset", Float) = 0
		_Burn_Intensity("Burn_Intensity", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend One One
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _Noise_Intensity;
		uniform sampler2D _Shape;
		uniform float4 _Shape_ST;
		uniform sampler2D _Noise_1;
		uniform float _Speed_Noise_1;
		uniform float _Scale_Noise_1;
		uniform sampler2D _Noise_2;
		uniform float _Speed_Noise_2;
		uniform float _Scale_Noise_2;
		uniform float _Vertex_Offset;
		uniform float _Final_Power;
		uniform float4 _Color_1;
		uniform float _Intensity_Step_1;
		uniform float _Intensity_Step_2;
		uniform float4 _Color_2;
		uniform float _Top_Color_Blend;
		uniform float4 _Top_Color;
		uniform float _Intensity_Step_3;
		uniform float4 _Color_3;
		uniform float _Burn_Intensity;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 uv_Shape = v.texcoord * _Shape_ST.xy + _Shape_ST.zw;
			float4 tex2DNode20 = tex2Dlod( _Shape, float4( uv_Shape, 0, 0.0) );
			float2 appendResult7 = (float2(0.0 , _Speed_Noise_1));
			float2 panner10 = ( 1.0 * _Time.y * appendResult7 + ( _Scale_Noise_1 * v.texcoord.xy ));
			float2 appendResult6 = (float2(0.0 , _Speed_Noise_2));
			float2 panner11 = ( 1.0 * _Time.y * appendResult6 + ( v.texcoord.xy * _Scale_Noise_2 ));
			float Shape30 = ( _Noise_Intensity * ( tex2DNode20.r * ( tex2DNode20.r + ( tex2Dlod( _Noise_1, float4( panner10, 0, 0.0) ).r * tex2Dlod( _Noise_2, float4( panner11, 0, 0.0) ).r ) ) ) );
			float3 ase_vertex3Pos = v.vertex.xyz;
			v.vertex.xyz += ( Shape30 * ( ase_vertex3Pos * _Vertex_Offset ) );
			//Calculate new billboard vertex position and normal;
			float3 upCamVec = float3( 0, 1, 0 );
			float3 forwardCamVec = -normalize ( UNITY_MATRIX_V._m20_m21_m22 );
			float3 rightCamVec = normalize( UNITY_MATRIX_V._m00_m01_m02 );
			float4x4 rotationCamMatrix = float4x4( rightCamVec, 0, upCamVec, 0, forwardCamVec, 0, 0, 0, 0, 1 );
			v.normal = normalize( mul( float4( v.normal , 0 ), rotationCamMatrix ));
			//This unfortunately must be made to take non-uniform scaling into account;
			//Transform to world coords, apply rotation and transform back to local;
			v.vertex = mul( v.vertex , unity_ObjectToWorld );
			v.vertex = mul( v.vertex , rotationCamMatrix );
			v.vertex = mul( v.vertex , unity_WorldToObject );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Shape = i.uv_texcoord * _Shape_ST.xy + _Shape_ST.zw;
			float4 tex2DNode20 = tex2D( _Shape, uv_Shape );
			float2 appendResult7 = (float2(0.0 , _Speed_Noise_1));
			float2 panner10 = ( 1.0 * _Time.y * appendResult7 + ( _Scale_Noise_1 * i.uv_texcoord ));
			float2 appendResult6 = (float2(0.0 , _Speed_Noise_2));
			float2 panner11 = ( 1.0 * _Time.y * appendResult6 + ( i.uv_texcoord * _Scale_Noise_2 ));
			float Shape30 = ( _Noise_Intensity * ( tex2DNode20.r * ( tex2DNode20.r + ( tex2D( _Noise_1, panner10 ).r * tex2D( _Noise_2, panner11 ).r ) ) ) );
			float temp_output_32_0 = step( _Intensity_Step_1 , Shape30 );
			float smoothstepResult46 = smoothstep( 0.0 , _Top_Color_Blend , i.uv_texcoord.y);
			float4 temp_cast_0 = (_Burn_Intensity).xxxx;
			o.Emission = ( _Final_Power * pow( ( ( _Color_1 * temp_output_32_0 ) + ( ( step( _Intensity_Step_2 , Shape30 ) - temp_output_32_0 ) * ( ( _Color_2 * ( 1.0 - smoothstepResult46 ) ) + ( smoothstepResult46 * _Top_Color ) ) ) + ( step( _Intensity_Step_3 , Shape30 ) * _Color_3 ) ) , temp_cast_0 ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
328;437;1188;494;-2279.505;-157.0916;2.0875;False;False
Node;AmplifyShaderEditor.RangedFloatNode;1;-689.6763,-47.17612;Float;False;Property;_Speed_Noise_1;Speed_Noise_1;2;0;Create;True;0;0;False;0;-1.5;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-691.1401,49.43884;Float;False;Property;_Scale_Noise_1;Scale_Noise_1;1;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-857.1489,179.6294;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;-705.4239,331.2844;Float;False;Property;_Scale_Noise_2;Scale_Noise_2;4;0;Create;True;0;0;False;0;0.5;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-520.1755,449.489;Float;False;Property;_Speed_Noise_2;Speed_Noise_2;5;0;Create;True;0;0;False;0;-1;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-424.2896,112.1569;Float;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;7;-428.0283,-71.0906;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-420.1207,281.0903;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;6;-242.0753,375.7173;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;11;-55.88973,302.3326;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;13;-170.135,116.5805;Float;True;Property;_Noise_1;Noise_1;0;0;Create;True;0;0;False;0;7009da5090971f84cb0c36a27b682288;7009da5090971f84cb0c36a27b682288;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.PannerNode;10;-151.5483,-86.49026;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;55;74.08569,533.8571;Float;True;Property;_Noise_2;Noise_2;3;0;Create;True;0;0;False;0;None;503139e193fb16448a7dcfc08dc2d91e;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;14;171.6523,200.0883;Float;True;Property;_TextureSample0;Texture Sample 0;4;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;18;340.4272,-300.2457;Float;True;Property;_Shape;Shape;8;0;Create;True;0;0;False;0;9c2f856ea91d0ac4b94e933c5e6924d0;9c2f856ea91d0ac4b94e933c5e6924d0;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;12;118.5389,-37.62054;Float;True;Property;_Tex;Tex;4;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;511.8475,93.22032;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;20;671.0673,-215.4758;Float;True;Property;_TextureSample1;Texture Sample 1;7;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;19;819.8883,46.63663;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;991.0833,-316.2557;Float;False;Property;_Noise_Intensity;Noise_Intensity;6;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;1080.741,-2.91314;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;1304.96,-3.216441;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;1238.863,1075.911;Float;False;Property;_Top_Color_Blend;Top_Color_Blend;16;0;Create;True;0;0;False;0;0.9778624;0.988;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;45;1254.493,810.0352;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;30;1585.565,-0.6921717;Float;False;Shape;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;46;1739.698,1091.821;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;2000.969,214.2449;Float;False;Property;_Intensity_Step_2;Intensity_Step_2;10;0;Create;True;0;0;False;0;0.09487711;0.052;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;42;1333.149,1318.609;Float;False;Property;_Top_Color;Top_Color;15;1;[HDR];Create;True;0;0;False;0;0.3475208,0.7428775,1.701961,0;0.06237553,0.2227698,1.719783,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;48;2059.833,975.1042;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;2005.086,-224.1235;Float;False;Property;_Intensity_Step_1;Intensity_Step_1;9;0;Create;True;0;0;False;0;0.155304;0.303;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;38;1749.762,873.1665;Float;False;Property;_Color_2;Color_2;13;1;[HDR];Create;True;0;0;False;0;1.698113,0.9392148,0.264329,0;3.30732,0.8357206,0.1422503,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;29;1952.308,6.885039;Float;False;30;Shape;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;33;2343.029,151.1464;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;56;1872.689,452.1563;Float;False;Property;_Intensity_Step_3;Intensity_Step_3;11;0;Create;True;0;0;False;0;0.155304;0.162;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;2051.999,1201.232;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;32;2326.424,-119.5129;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;2364.64,991.7634;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;37;2793.24,-298.0522;Float;False;Property;_Color_1;Color_1;12;1;[HDR];Create;True;0;0;False;0;1.584906,0.8370304,0.1719473,0;1.019608,0.01568628,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;57;2412.529,459.0971;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;58;2192.861,696.6627;Float;False;Property;_Color_3;Color_3;14;1;[HDR];Create;True;0;0;False;0;0,0,0,0;1.058824,0.09411765,0.03137255,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;52;2624.334,1141.284;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;36;2625.385,151.1464;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;3101.093,299.9883;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;2722.714,455.0497;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;2995.111,-43.1911;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;41;3352.261,99.13935;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;61;3350.64,599.1024;Float;False;Property;_Vertex_Offset;Vertex_Offset;18;0;Create;True;0;0;False;0;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;69;3528.874,271.9043;Float;False;Property;_Burn_Intensity;Burn_Intensity;19;0;Create;True;0;0;False;0;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;67;3411.348,768.8728;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;3744.127,639.6641;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;60;3492.316,478.2051;Float;False;30;Shape;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;3828.135,-177.5167;Float;False;Property;_Final_Power;Final_Power;17;0;Create;True;0;0;False;0;1;0.75;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;68;3693.785,84.02908;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;2;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;3978.99,499.789;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;4005.645,64.96503;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;28;4436.949,-7.063921;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;Stylised_Campfire;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;4;1;False;-1;1;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;True;Cylindrical;False;Relative;0;;7;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;8;0;2;0
WireConnection;8;1;5;0
WireConnection;7;1;1;0
WireConnection;9;0;5;0
WireConnection;9;1;4;0
WireConnection;6;1;3;0
WireConnection;11;0;9;0
WireConnection;11;2;6;0
WireConnection;10;0;8;0
WireConnection;10;2;7;0
WireConnection;14;0;55;0
WireConnection;14;1;11;0
WireConnection;12;0;13;0
WireConnection;12;1;10;0
WireConnection;15;0;12;1
WireConnection;15;1;14;1
WireConnection;20;0;18;0
WireConnection;19;0;20;1
WireConnection;19;1;15;0
WireConnection;21;0;20;1
WireConnection;21;1;19;0
WireConnection;16;0;17;0
WireConnection;16;1;21;0
WireConnection;30;0;16;0
WireConnection;46;0;45;2
WireConnection;46;2;43;0
WireConnection;48;0;46;0
WireConnection;33;0;35;0
WireConnection;33;1;29;0
WireConnection;47;0;46;0
WireConnection;47;1;42;0
WireConnection;32;0;34;0
WireConnection;32;1;29;0
WireConnection;51;0;38;0
WireConnection;51;1;48;0
WireConnection;57;0;56;0
WireConnection;57;1;29;0
WireConnection;52;0;51;0
WireConnection;52;1;47;0
WireConnection;36;0;33;0
WireConnection;36;1;32;0
WireConnection;40;0;36;0
WireConnection;40;1;52;0
WireConnection;59;0;57;0
WireConnection;59;1;58;0
WireConnection;39;0;37;0
WireConnection;39;1;32;0
WireConnection;41;0;39;0
WireConnection;41;1;40;0
WireConnection;41;2;59;0
WireConnection;65;0;67;0
WireConnection;65;1;61;0
WireConnection;68;0;41;0
WireConnection;68;1;69;0
WireConnection;66;0;60;0
WireConnection;66;1;65;0
WireConnection;53;0;54;0
WireConnection;53;1;68;0
WireConnection;28;2;53;0
WireConnection;28;11;66;0
ASEEND*/
//CHKSM=A1D6E4DCBDD5D2BEA98E7C9D8F8DEE6B37F8A193