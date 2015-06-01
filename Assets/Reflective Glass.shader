Shader "Glass Reflective" {
Properties {
_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
_Shininess ("Shininess", Range (0.01, 1)) = 0.078125
_ReflectColor ("Reflection Color", Color) = (1,1,1,0.5)
_Cube("Reflection Cubemap",Cube) = "black"{TexGen CubeReflect}
}
// 3. In the following code, we indicate that this is a transparent material. This is
// rendered after the opaque objects are rendered to blend the colors.
SubShader {
Tags {
"Queue"="Transparent"
"IgnoreProjector"="True"
"RenderType"="Transparent"
}
LOD 300
// 4. In the shader program ( CGPROGRAM) the actual calculations are coded. The
// color sampled from the CubeMap ( reflcol) is first modulated (multiplied)
// with the RGB channel of the reflection color ( _ReflectColor.rgb) as set
// previously. This defines the output emission ( o.Emission). The same
// reflection color is also multiplied with the alpha channel of the reflection
// color to set the output opacity ( o.Alpha). The output (o ) is what is returned
// back from the shader to the graphics system. The shader program is as
// follows:
CGPROGRAM
#pragma surface surf BlinnPhong decal:add nolightmap
samplerCUBE _Cube;
fixed4 _ReflectColor;
half _Shininess;
struct Input {
float3 worldRefl;
};
void surf (Input IN, inout SurfaceOutput o) {
o.Albedo = 0;
o.Gloss = 1;
o.Specular = _Shininess;
fixed4 reflcol = texCUBE (_Cube, IN.worldRefl);
o.Emission = reflcol.rgb * _ReflectColor.rgb;
o.Alpha = reflcol.a * _ReflectColor.a;
}
ENDCG
}
// 5. And finally, the Fallback section ensures that the shader will render at least
// something when the GPU cannot render the preceding instructions. You see
// this with most shaders. The Fallback section is as follows:
// FallBack "Transparent/VertexLit"
}
