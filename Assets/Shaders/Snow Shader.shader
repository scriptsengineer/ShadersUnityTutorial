// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Shaders/SnowShader"{

    Properties{
        _MainTex("Texture",2D) = "white" {}
        _MainColor ("Main Color", Color) = (1.0,1.0,1.0,1.0)
        _Bump ("Bump", 2D) = "bump" {}
        _Snow ("Level of snow", Range(1, -1)) = 1
        _SnowColor ("Color of snow", Color) = (1.0,1.0,1.0,1.0)
        _SnowDirection("Snow Direction",Vector) = (0,1,0)
        _SnowDepth ("Depth of snow", Range(0,0.0001)) = 0
    }

    SubShader{
        Tags{
            "RenderType" = "Opaque"
        }
        LOD 200
        CGPROGRAM
        #pragma surface surf Lambert vertex:vert

        float4 _MainColor;
        sampler2D _MainTex;
        sampler2D _Bump;
        float _Snow;
        float4 _SnowColor;
        float4 _SnowDirection;
        float _SnowDepth;

        struct Input{
            float2 uv_MainTex;
            float2 uv_Bump;
            float3 worldNormal;
            INTERNAL_DATA
        };

        void vert(inout appdata_full v){
            float4 sn = mul(_SnowDirection,unity_WorldToObject);
            if(dot(v.normal,sn.xyz) >= _Snow)
                v.vertex.xyz += (sn.xyz + v.normal) * _SnowDepth * _Snow;
        }

        void surf(Input IN, inout SurfaceOutput o){
            half4 c = tex2D(_MainTex,IN.uv_MainTex);
            o.Normal = UnpackNormal(tex2D(_Bump, IN.uv_Bump));
            if(dot(WorldNormalVector(IN, o.Normal), _SnowDirection.xyz) >= _Snow)
                o.Albedo = _SnowColor.rgb;
            else
                o.Albedo = c.rgb * _MainColor;
            o.Alpha = 1;
        }
        ENDCG

    }
    Fallback "Diffuse"
}