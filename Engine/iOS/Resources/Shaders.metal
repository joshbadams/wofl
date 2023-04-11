//
//  Shaders.metal
//  MetalTest
//
//  Created by Josh on 2/5/22.
//

// File for Metal kernel and shader functions

#include <metal_stdlib>
#include <simd/simd.h>

// Including header shared between this Metal shader code and Swift/C code executing Metal API commands
#import "../ShaderTypes.h"

using namespace metal;

typedef struct
{
    float2 position [[attribute(VertexAttributePosition)]];
} Vertex;

typedef struct
{
    float4 position [[position]];
    float2 texCoord;
} ColorInOut;

vertex ColorInOut vertexShader(Vertex in [[stage_in]],
							   constant ViewUniforms& viewUniforms [[ buffer(BufferIndexViewUniforms) ]],
							   constant ModelUniforms* modelUniforms [[ buffer(BufferIndexModelUniforms) ]],
							   ushort iid [[instance_id]]
							   )
{
    ColorInOut out;

    float4 position = float4(in.position.x, in.position.y, 0.0, 1.0);
    out.position = viewUniforms.viewMatrix * modelUniforms[iid].modelMatrix * position;
//	out.position.y = -out.position.y;
    out.texCoord = float2(in.position.x, in.position.y) * modelUniforms[iid].uvScaleBias.xy + modelUniforms[iid].uvScaleBias.zw;

//	gl_Position = ViewMatrix * SpriteMatrix * vec4(Corner.x, Corner.y, 0.0, 1.0);
//	//	gl_Position = SpriteMatrix * ViewMatrix * vec4(Corner.x, Corner.y, 0.0, 1.0);
//
//	UVVarying = vec2(Corner.x, 1.0 - Corner.y) * UVScaleBias.xy + UVScaleBias.zw;
	
	
    return out;
}

fragment float4 fragmentShader(ColorInOut in [[stage_in]],
							   constant ViewUniforms & viewUniforms [[ buffer(BufferIndexViewUniforms) ]],
							   constant ModelUniforms & modelUniforms [[ buffer(BufferIndexModelUniforms) ]],
                               texture2d<half> colorMap     [[ texture(TextureIndexColor) ]])
{
	
    constexpr sampler colorSampler(mip_filter::linear,
                                   mag_filter::linear,
                                   min_filter::linear);

    half4 colorSample   = (half4)modelUniforms.color * colorMap.sample(colorSampler, in.texCoord.xy);

//    return float4(in.texCoord.xy, (float2)colorSample.zw);
	return float4(colorSample);
}

