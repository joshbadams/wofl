//
//  ShaderTypes.h
//  MetalTest
//
//  Created by Josh on 2/5/22.
//

//
//  Header containing types and enum constants shared between Metal shaders and Swift/ObjC source
//
#ifndef ShaderTypes_h
#define ShaderTypes_h

#ifdef __METAL_VERSION__
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#define NSInteger metal::int32_t
#else
#import <Foundation/Foundation.h>
#endif

#include <simd/simd.h>

typedef NS_ENUM(NSInteger, BufferIndex)
{
    BufferIndexMeshPositions = 0,
    BufferIndexMeshGenerics  = 1,
	BufferIndexViewUniforms  = 2,
	BufferIndexModelUniforms = 3
};

typedef NS_ENUM(NSInteger, VertexAttribute)
{
    VertexAttributePosition  = 0,
    VertexAttributeTexcoord  = 1,
};

typedef NS_ENUM(NSInteger, TextureIndex)
{
    TextureIndexColor    = 0,
};

typedef struct
{
	matrix_float4x4 viewMatrix;
} ViewUniforms;

typedef struct
{
	matrix_float4x4 modelMatrix;
	simd::float4 uvScaleBias;
	simd::float4 color;
	
} ModelUniforms;

#endif /* ShaderTypes_h */

