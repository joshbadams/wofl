//
//  iOSRender.h
//  Wofl
//
//  Created by Josh on 2/4/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#ifndef Wofl_iOSRender_h
#define Wofl_iOSRender_h

#include "WoflRenderer.h"
#import <MetalKit/MetalKit.h>

class iOSRenderer : public WoflRenderer
{
public:
	
	iOSRenderer(MTKView* InView);
	
	int CreateUncompressedTexture(unsigned int Width, unsigned int Height, void* Contents) override;
	
	void BeginFrame() override;
	void DrawScene(class WoflSprite* RootSprite) override;
	void EndFrame() override;

	void DrawString(const char* String, Vector Location, float Scale, WColor& Color) override;
	
	
protected:
	
	void SetupResources();
	
	unsigned int SetupViewUniforms();

	void DrawSprite(WoflSprite* Sprite);

	MTKView* View;
	
	
	dispatch_semaphore_t inFlightSemaphore;
	id <MTLDevice> device;
	id <MTLCommandQueue> commandQueue;
	
	id <MTLRenderPipelineState> pipelineState;
	id <MTLDepthStencilState> depthState;
	id <MTLTexture> colorMap;

	id <MTLBuffer> vertexBuffer;
	MTLVertexDescriptor* mtlVertexDescriptor;
	
	
	// current objects for rendering
	id <MTLRenderCommandEncoder> renderEncoder;
	id <MTLCommandBuffer> commandBuffer;

	
	struct UniformRing
	{
		unsigned int alignedUniformSize;
		unsigned int numUniformsPerFrame;
		unsigned int bufferSize;

		unsigned int bufferIndex;

		unsigned int numThisFrame;

		id <MTLBuffer> uniformBuffer;
		
		
		void* GetNext(unsigned int* OutOffset);
		void GetNextInstances(unsigned int NumInstances, void** OutBuffer1, unsigned int* OutOffset1,
							  unsigned int* OutNumInstances1, void** OutBuffer2, unsigned int* OutOffset2);

	};
	
	UniformRing	viewBuffers;
	UniformRing modelBuffers;
	
	
	matrix_float4x4 viewMatrix;
	
	float rotation;
	
	MTKMesh* mesh;

};

#endif
