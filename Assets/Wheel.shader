Shader "Unlit/Wheel"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Percent("Percent", Float) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

			#define SEGMENTCOUNT 14
			#define PI 3.14159265359

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

			float _Percent;

            fixed4 frag (v2f i) : SV_Target
            {
				float4 white = float4(1, 1, 1, 1);
				float4 black = float4(0, 0, 0, 1);
				float spokes = 1.0;
				float2 anchorPoint = float2(0.5, 0.5);
				float2 uv = i.uv.xy;

				//float theta = atan2(uv.y - anchorPoint.y, uv.x - anchorPoint.x);
				float theta = -atan2(-uv.x + anchorPoint.x, -uv.y + anchorPoint.y);
				float percent = theta / (2.0*PI);
				//if (fmod(percent*spokes + _Time.y, 2.0) < 1.0)
				if (fmod(percent*spokes + _Percent+0.5, 2.0) < 1.0)
				{
					//o = color1;
					return black;
				}
				else {
					///o = color2;
					return white;
				}
				
            }
            ENDCG
        }
    }
}
