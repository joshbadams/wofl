#include "iOSRender.h"
#include "WoflWorld.h"
#include "WoflSprite.h"
#include "WoflImage.h"
#include "ShaderTypes.h"

static const NSUInteger kMaxBuffersInFlight = 3;
static const NSUInteger kMaxSpritesPerFrame = 500;
#pragma mark Matrix Math Utilities

@interface TestClass : NSObject
@end

@implementation TestClass
@end

static inline matrix_float4x4 MakeOrthoViewMatrix(Vector Offset, Vector Scale, Vector Size)
{
	return (matrix_float4x4) {{
		{ (Scale.X * 2.0f / Size.X),   0,  0,  0 },
		{ 0,   (Scale.Y * 2.0f / Size.Y),  0,  0 },
		{ 0,   0,  1,  0 },
		{ (Offset.X * 2.f / Size.X) - 1.0f,   (Offset.Y * 2.0f / Size.Y) - 1.0f,  0,  1 }
	}};
}

static inline matrix_float4x4 MakeSpriteMatrix(Vector Pos, Vector Size, float ViewHeight)
{
	return (matrix_float4x4) {{
		{ Size.X,   0,  0,  0 },
		{ 0,   -Size.Y,  0,  0 },
		{ 0,   0,  1,  0 },
		{ Pos.X,   ViewHeight - Pos.Y,  0,  1 }
	}};
}

//matrix_float4x4 matrix4x4_translation(float tx, float ty, float tz)
//{
//	return (matrix_float4x4) {{
//		{ 1,   0,  0,  0 },
//		{ 0,   1,  0,  0 },
//		{ 0,   0,  1,  0 },
//		{ tx, ty, tz,  1 }
//	}};
//}
//
//static matrix_float4x4 matrix4x4_rotation(float radians, vector_float3 axis)
//{
//	axis = vector_normalize(axis);
//	float ct = cosf(radians);
//	float st = sinf(radians);
//	float ci = 1 - ct;
//	float x = axis.x, y = axis.y, z = axis.z;
//
//	return (matrix_float4x4) {{
//		{ ct + x * x * ci,     y * x * ci + z * st, z * x * ci - y * st, 0},
//		{ x * y * ci - z * st,     ct + y * y * ci, z * y * ci + x * st, 0},
//		{ x * z * ci + y * st, y * z * ci - x * st,     ct + z * z * ci, 0},
//		{                   0,                   0,                   0, 1}
//	}};
//}

//matrix_float4x4 matrix_perspective_right_hand(float fovyRadians, float aspect, float nearZ, float farZ)
//{
//	float ys = 1 / tanf(fovyRadians * 0.5);
//	float xs = ys / aspect;
//	float zs = farZ / (nearZ - farZ);
//
//	return (matrix_float4x4) {{
//		{ xs,   0,          0,  0 },
//		{  0,  ys,          0,  0 },
//		{  0,   0,         zs,  -1 },
//		{  0,   0, nearZ * zs,  0 }
//	}};
//}

#pragma mark iOSRenderer

iOSRenderer::iOSRenderer(MTKView* InView)
	: View(InView)
{
#if TARGET_OS_MAC
	ViewSize.X = [InView.window convertRectToBacking:View.frame].size.width;
	ViewSize.Y = [InView.window convertRectToBacking:View.frame].size.height;
#else
	ViewSize.X = View.frame.size.width * View.contentScaleFactor;
	ViewSize.Y = View.frame.size.height * View.contentScaleFactor;
#endif
	
	
	device = View.device;
	inFlightSemaphore = dispatch_semaphore_create(kMaxBuffersInFlight);
//	[self _loadMetalWithView:view];
//	[self _loadAssets];

	
	
	View.depthStencilPixelFormat = MTLPixelFormatDepth32Float_Stencil8;
	View.colorPixelFormat = MTLPixelFormatBGRA8Unorm;
	View.sampleCount = 1;
	
	mtlVertexDescriptor = [[MTLVertexDescriptor alloc] init];
	
	mtlVertexDescriptor.attributes[VertexAttributePosition].format = MTLVertexFormatFloat2;
	mtlVertexDescriptor.attributes[VertexAttributePosition].offset = 0;
	mtlVertexDescriptor.attributes[VertexAttributePosition].bufferIndex = BufferIndexMeshPositions;
	
//	mtlVertexDescriptor.attributes[VertexAttributeTexcoord].format = MTLVertexFormatFloat2;
//	mtlVertexDescriptor.attributes[VertexAttributeTexcoord].offset = 0;
//	mtlVertexDescriptor.attributes[VertexAttributeTexcoord].bufferIndex = BufferIndexMeshGenerics;
	
	mtlVertexDescriptor.layouts[BufferIndexMeshPositions].stride = 8;
	mtlVertexDescriptor.layouts[BufferIndexMeshPositions].stepRate = 1;
	mtlVertexDescriptor.layouts[BufferIndexMeshPositions].stepFunction = MTLVertexStepFunctionPerVertex;
	
//	mtlVertexDescriptor.layouts[BufferIndexMeshGenerics].stride = 8;
//	mtlVertexDescriptor.layouts[BufferIndexMeshGenerics].stepRate = 1;
//	mtlVertexDescriptor.layouts[BufferIndexMeshGenerics].stepFunction = MTLVertexStepFunctionPerVertex;
	
//	id<MTLLibrary> defaultLibrary = [device newDefaultLibrary];
	NSError* Error;
	id<MTLLibrary> defaultLibrary = [device newDefaultLibraryWithBundle:[NSBundle bundleForClass:NSClassFromString(@"TestClass")] error: &Error];
	
	id <MTLFunction> vertexFunction = [defaultLibrary newFunctionWithName:@"vertexShader"];
	id <MTLFunction> fragmentFunction = [defaultLibrary newFunctionWithName:@"fragmentShader"];
	
	MTLRenderPipelineDescriptor *pipelineStateDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
	pipelineStateDescriptor.label = @"MyPipeline";
	pipelineStateDescriptor.sampleCount = View.sampleCount;
	pipelineStateDescriptor.vertexFunction = vertexFunction;
	pipelineStateDescriptor.fragmentFunction = fragmentFunction;
	pipelineStateDescriptor.vertexDescriptor = mtlVertexDescriptor;
	pipelineStateDescriptor.colorAttachments[0].pixelFormat = View.colorPixelFormat;
	pipelineStateDescriptor.colorAttachments[0].blendingEnabled = true;
	pipelineStateDescriptor.colorAttachments[0].sourceRGBBlendFactor = MTLBlendFactorSourceAlpha;
	pipelineStateDescriptor.colorAttachments[0].destinationRGBBlendFactor = MTLBlendFactorOneMinusSourceAlpha;
	pipelineStateDescriptor.depthAttachmentPixelFormat = View.depthStencilPixelFormat;
	pipelineStateDescriptor.stencilAttachmentPixelFormat = View.depthStencilPixelFormat;
	
	NSError *error = NULL;
	pipelineState = [device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor error:&error];
	if (!pipelineState)
	{
		NSLog(@"Failed to created pipeline state, error %@", error);
	}
	
	MTLDepthStencilDescriptor *depthStateDesc = [[MTLDepthStencilDescriptor alloc] init];
	depthStateDesc.depthCompareFunction = MTLCompareFunctionLess;
	depthStateDesc.depthWriteEnabled = NO;
	depthState = [device newDepthStencilStateWithDescriptor:depthStateDesc];
	

	commandQueue = [device newCommandQueue];
	
	SetupResources();
};

void iOSRenderer::SetupResources()
{
//	NSError *error;
//
//	MTKMeshBufferAllocator *metalAllocator = [[MTKMeshBufferAllocator alloc]
//											  initWithDevice: device];
//
	
//	float aspect = ViewSize.X / ViewSize.Y;
//	projectionMatrix = matrix_perspective_right_hand(65.0f * (M_PI / 180.0f), aspect, 0.1f, 100.0f);

//	static const size_t kAlignedViewUniformsSize = (sizeof(ViewUniforms) & ~0xFF) + 0x100;
//	static const size_t kAlignedModelUniformsSize = (sizeof(ModelUniforms) & ~0xFF) + 0x100;

	viewBuffers.alignedUniformSize = (sizeof(ViewUniforms) & ~0xFF) + 0x100;
	viewBuffers.numUniformsPerFrame = 1;
	viewBuffers.bufferSize = viewBuffers.numUniformsPerFrame * viewBuffers.alignedUniformSize * kMaxBuffersInFlight;
	viewBuffers.uniformBuffer = [device newBufferWithLength:viewBuffers.bufferSize options:MTLResourceStorageModeShared];
	viewBuffers.uniformBuffer.label = @"ViewBuffers";
	viewBuffers.bufferIndex = 0;
	viewBuffers.numThisFrame = 0;

	modelBuffers.alignedUniformSize = (sizeof(ModelUniforms) & ~0xFF) + 0x100;
	modelBuffers.numUniformsPerFrame = kMaxSpritesPerFrame;
	modelBuffers.bufferSize = modelBuffers.numUniformsPerFrame * modelBuffers.alignedUniformSize * kMaxBuffersInFlight;
	modelBuffers.uniformBuffer = [device newBufferWithLength:modelBuffers.bufferSize options:MTLResourceStorageModeShared];
	modelBuffers.uniformBuffer.label = @"ModelBuffers";
	modelBuffers.bufferIndex = 0;
	modelBuffers.numThisFrame = 0;
	
	
	simd_float2 verts[]
	{
		{ 0.0f, 0.0f },
		{ 1.0f, 0.0f },
		{ 1.0f, 1.0f },
		{ 0.0f, 0.0f },
		{ 1.0f, 1.0f },
		{ 0.0f, 1.0f },
	};
	vertexBuffer = [device newBufferWithLength:sizeof(verts) options:MTLResourceStorageModeShared];
	memcpy(vertexBuffer.contents, verts, sizeof(verts));
	vertexBuffer.label = @"VertexBuffer";
}


std::vector<id<MTLTexture>> GTextures;

int iOSRenderer::CreateUncompressedTexture(unsigned int Width, unsigned int Height, void* Contents)
{
	MTLTextureDescriptor* desc = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:MTLPixelFormatRGBA8Unorm width:Width height:Height mipmapped:NO];
	id<MTLTexture> texture = [device newTextureWithDescriptor:desc];

	[texture replaceRegion:MTLRegionMake2D(0, 0, Width, Height)
				mipmapLevel:0
				  withBytes:Contents
				bytesPerRow:4*Width];

	GTextures.push_back(texture);
	
	return (int)GTextures.size() - 1;
}

void iOSRenderer::BeginFrame()
{
	// start the frame
	
	dispatch_semaphore_wait(inFlightSemaphore, DISPATCH_TIME_FOREVER);
	
	commandBuffer = [commandQueue commandBuffer];
	commandBuffer.label = @"MyCommand";
	
	__block dispatch_semaphore_t block_sema = inFlightSemaphore;
	[commandBuffer addCompletedHandler:^(id<MTLCommandBuffer> buffer)
	 {
		dispatch_semaphore_signal(block_sema);
	 }];

	viewBuffers.numThisFrame = 0;
	modelBuffers.numThisFrame = 0;
	
	unsigned int BufferOffset = SetupViewUniforms();

	/// Delay getting the currentRenderPassDescriptor until we absolutely need it to avoid
	///   holding onto the drawable and blocking the display pipeline any longer than necessary
	MTLRenderPassDescriptor* renderPassDescriptor = View.currentRenderPassDescriptor;

	if(renderPassDescriptor != nil)
	{
		renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
		renderEncoder.label = @"MyRenderEncoder";

		[renderEncoder setFrontFacingWinding:MTLWindingCounterClockwise];
		[renderEncoder setCullMode:MTLCullModeNone];
		[renderEncoder setRenderPipelineState:pipelineState];
		[renderEncoder setDepthStencilState:depthState];

		[renderEncoder setVertexBuffer:viewBuffers.uniformBuffer
								offset:BufferOffset
							   atIndex:BufferIndexViewUniforms];
		
		[renderEncoder setFragmentBuffer:viewBuffers.uniformBuffer
								  offset:BufferOffset
								 atIndex:BufferIndexViewUniforms];
	}
	else
	{
		renderEncoder = nullptr;
	}



}

void iOSRenderer::DrawScene(class WoflSprite* RootSprite)
{
	if (renderEncoder == nullptr)
	{
		return;
	}
	[renderEncoder pushDebugGroup:@"DrawBox"];


	[renderEncoder setVertexBuffer:vertexBuffer
							offset:0
						   atIndex:BufferIndexMeshPositions];
		
	// walk over the sprites and draw em!
	// this could be done earlier to set up a flat list of sprites to render much faster
	WoflWorld::Get()->Visit(true, true, false,
		[this](WoflSprite* Sprite)
		{
			DrawSprite(Sprite);
			return true;
		},
		RootSprite);
	
	
	[renderEncoder popDebugGroup];
}

void iOSRenderer::DrawSprite(WoflSprite* Sprite)
{
	// allow the sprite to render itself
	if (Sprite->CustomPreRender())
	{
		return;
	}
	
	
	// get current image
	WoflImage* Image = Sprite->GetImage();
	
	if (Image != NULL)
	{
		// set uniforms
		unsigned int BufferOffset;
		ModelUniforms* Uniform = (ModelUniforms*)modelBuffers.GetNext(&BufferOffset);
		Uniform->modelMatrix = MakeSpriteMatrix(Sprite->GetPosition(), Sprite->GetSize(), ViewSize.Y);
		Uniform->color = (simd::float4&)Sprite->GetColor();
		Uniform->uvScaleBias = (simd::float4&)Image->UVScaleBias;
		
		[renderEncoder setVertexBuffer:modelBuffers.uniformBuffer
								offset:BufferOffset
							   atIndex:BufferIndexModelUniforms];
		[renderEncoder setFragmentBuffer:modelBuffers.uniformBuffer
								  offset:BufferOffset
								 atIndex:BufferIndexModelUniforms];
		
		[renderEncoder setFragmentTexture:GTextures[Image->Texture]
								  atIndex:TextureIndexColor];
		
		[renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:6];
	}
	
	Sprite->CustomRender();
}


void iOSRenderer::EndFrame()
{
	[renderEncoder endEncoding];
	renderEncoder = nullptr;

	[commandBuffer presentDrawable:View.currentDrawable];
	[commandBuffer commit];
	
	commandBuffer = nullptr;
}

void iOSRenderer::DrawString(const char* String, Vector Location, float Scale, WColor& Color)
{
	assert(renderEncoder != nullptr);
	
	simd_float4 SimdColor = { Color.R, Color.G, Color.B, Color.A };
	Vector SpriteSize(String_CharX * Scale, String_CharY * Scale);
	
//	GLCHECK(glUniform4fv(ColorUniform, 1, (float*)&Color));
//
	int NumChars = (int)strlen(String);
	void* Buffer1, *Buffer2;
	unsigned int NumInstances1, Offset1, Offset2;
	modelBuffers.GetNextInstances(NumChars, &Buffer1, &Offset1, &NumInstances1, &Buffer2, &Offset2);

	for (int i = 0; i < NumChars; i++)
	{
		ModelUniforms* Uniform;

		if (i >= NumInstances1)
		{
			Uniform = (ModelUniforms*)Buffer2 + i - NumInstances1;
		}
		else
		{
			Uniform = (ModelUniforms*)Buffer1 + i;
		}
		
		// find the char index
		int CharIndexX = -1, CharIndexY = -1;
		for (int i = 0; i < strlen(String_Chars); i++)
		{
			if (String_Chars[i] == *String)
			{
				CharIndexX = i % String_NumCharsX;
				CharIndexY = (i / String_NumCharsX);
			}
		}

		WoflImage CharImage("Font", CharIndexX * String_CharX * String_InvTexSize,
							CharIndexY * String_CharY * String_InvTexSize,
							String_CharX * String_InvTexSize, String_CharY * String_InvTexSize);

		
		Uniform->modelMatrix = MakeSpriteMatrix(Location, SpriteSize, ViewSize.Y);
		Uniform->color = SimdColor;
		Uniform->uvScaleBias = (simd::float4&)CharImage.UVScaleBias;

		// set texture on first one, the rest will follow
		if (i == 0)
		{
			[renderEncoder setFragmentTexture:GTextures[CharImage.Texture]
									  atIndex:TextureIndexColor];
		}

		Location.X += String_CharX * Scale;
		String++;
	}

	
	[renderEncoder setVertexBuffer:modelBuffers.uniformBuffer
							offset:Offset1
						   atIndex:BufferIndexModelUniforms];
	[renderEncoder setFragmentBuffer:modelBuffers.uniformBuffer
							offset:Offset1
						   atIndex:BufferIndexModelUniforms];

	[renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:6 instanceCount:NumInstances1];

	if (Buffer2 != nullptr)
	{
		[renderEncoder setVertexBuffer:modelBuffers.uniformBuffer
								offset:Offset2
							   atIndex:BufferIndexModelUniforms];

		[renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:6 instanceCount:NumChars-NumInstances1];
	}
}





unsigned int iOSRenderer::SetupViewUniforms()
{
	Vector ViewOffset = WoflWorld::Get()->GetViewOffset();
	Vector ViewScale = WoflWorld::Get()->GetViewScale();

	unsigned int BufferOffset;
	ViewUniforms* Uniform = (ViewUniforms*)viewBuffers.GetNext(&BufferOffset);
	Uniform->viewMatrix = MakeOrthoViewMatrix(ViewOffset, ViewScale, ViewSize);
	
	return BufferOffset;
}

void* iOSRenderer::UniformRing::GetNext(unsigned int* OutOffset)
{
	numThisFrame++;
	assert(numThisFrame <= numUniformsPerFrame);

	// set current offset
	*OutOffset = bufferIndex * alignedUniformSize;

	// move to next one for next call
	bufferIndex++;
	if (bufferIndex == numUniformsPerFrame * kMaxBuffersInFlight)
	{
		bufferIndex = 0;
	}
	
	return ((unsigned char*)uniformBuffer.contents) + *OutOffset;

}

void iOSRenderer::UniformRing::GetNextInstances(unsigned int NumInstances, void** OutBuffer1, unsigned int* OutOffset1,
												unsigned int* OutNumInstances1, void** OutBuffer2, unsigned int* OutOffset2)
{
	numThisFrame += NumInstances;
	assert(numThisFrame <= numUniformsPerFrame);

	// set current offset
	*OutOffset1 = bufferIndex * alignedUniformSize;
	*OutBuffer1 = ((unsigned char*)uniformBuffer.contents) + *OutOffset1;
	*OutNumInstances1 = NumInstances;
	
	*OutOffset2 = 0;
	*OutBuffer2 = nullptr;

	// move to next one for next call
	unsigned int NumUniforms = numUniformsPerFrame * kMaxBuffersInFlight;
	bufferIndex += NumInstances;
	if (bufferIndex == NumUniforms)
	{
		bufferIndex = 0;
	}
	else if (bufferIndex > NumUniforms)
	{
		*OutNumInstances1 = NumInstances - (bufferIndex - NumUniforms);
		*OutBuffer2 = uniformBuffer.contents;
		*OutOffset2 = 0;
		
		// wrap around
		bufferIndex = bufferIndex - NumUniforms;
	}
}
