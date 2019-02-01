#ifndef LANDSCAPE_COMMON_CGINC_INCLUDED
#define LANDSCAPE_COMMON_CGINC_INCLUDED

struct Input
{
	float2 tc_Control : TEXCOORD0;	// Not prefixing '_Contorl' with 'uv' allows a tighter packing of interpolators, which is necessary to support directional lightmap.
	UNITY_FOG_COORDS(1)

	float3 worldPos;
	float3 worldNormal;
	float3 viewDir;
	INTERNAL_DATA
};

int _Landscape_Holes_Count;
float4x4 _Landscape_Holes_List[16];

sampler2D _Control;
float4 _Control_ST;
sampler2D _Splat0;
sampler2D _Splat1;
sampler2D _Splat2;
sampler2D _Splat3;
sampler2D _Normal0;
sampler2D _Normal1;
sampler2D _Normal2;
sampler2D _Normal3;

void clipLandscapeHoles(float3 worldPos)
{
	for(int index = 0; index < _Landscape_Holes_Count; index++)
	{
		float4x4 worldToLocal = _Landscape_Holes_List[index];
		float3 local = abs(mul(worldToLocal, float4(worldPos, 1)).xyz);
		clip(max(max(local.x, local.y), local.z) - 0.5);
	}
}

void splatmapVert(inout appdata_full IN, out Input OUT)
{
	UNITY_INITIALIZE_OUTPUT(Input, OUT);
	OUT.tc_Control = TRANSFORM_TEX(IN.texcoord, _Control);	// Need to manually transform uv here, as we choose not to use 'uv' prefix for this texcoord.
	float4 pos = UnityObjectToClipPos(IN.vertex);
	UNITY_TRANSFER_FOG(OUT, pos);
}

#endif
