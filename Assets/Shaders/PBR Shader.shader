Shader "Shaders/PBR Shader"{
    Properties{
        _Color("Color", Color) = (1,1,1,1)
        _MainTex("Texture",2D) = "white" {}
        _Glossiness("Smoothness",Range(0,1)) = 0.5
        _Metallic("Metallic",Range(0,1)) = 0.0
    }

    SubShader{
        Tags{
            "RenderType" = "Opaque"
        }
        LOD 1
        
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        struct Input{
            float2 uv_MainTex;
        };

        sampler2D _MainTex;
        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        void surf(Input IN, inout SurfaceOutputStandard o){
            fixed4 c = tex2D(_MainTex,IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;

        }
        ENDCG
    }
    Fallback "Diffuse"
}