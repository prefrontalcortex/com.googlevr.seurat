// Copyright 2017 Google Inc. All Rights Reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
// of the Software, and to permit persons to whom the Software is furnished to do
// so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Shader "GoogleVR/Seurat/AlphaBlended"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		[Toggle(_CLIP_DISTANCE)]
		_ClipDistanceKeyword("Clip By Distance", Float) = 0
		_ClipDistance("Clipping Distance", Float) = 10
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" "Queue"="Transparent" }
		LOD 100
		Blend SrcAlpha OneMinusSrcAlpha
		Cull Off
		ZWrite Off
		ZTest Always
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile __ _CLIP_DISTANCE
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0_centroid;

				UNITY_VERTEX_INPUT_INSTANCE_ID //Insert
			};

			struct v2f
			{
				float2 uv : TEXCOORD0_centroid;
				float4 vertex : SV_POSITION;

				UNITY_VERTEX_OUTPUT_STEREO //Insert
			};

			sampler2D _MainTex;
			float _ClipDistance;
			
			v2f vert (appdata v)
			{
				v2f o;
				
			    UNITY_SETUP_INSTANCE_ID(v); //Insert
			    UNITY_INITIALIZE_OUTPUT(v2f, o); //Insert
			    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o); //Insert

				#ifdef _CLIP_DISTANCE
				if(length(v.vertex) > _ClipDistance) v.vertex = 0.0 / 0.0;
				#endif
				
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;

				return o;
			}
			
			half4 frag (v2f i) : SV_Target
			{
				half4 col = tex2D(_MainTex, i.uv);
				// col.rgb *= col.a;
				return col;
			}
			ENDCG
		}
	}
}
