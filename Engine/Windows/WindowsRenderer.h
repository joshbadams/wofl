//
//  iOSRender.h
//  Wofl
//
//  Created by Josh on 2/4/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#pragma once

#include "WoflRenderer.h"
#include "WindowsGLSetup.h"

class WindowsRenderer : public WoflRenderer
{
public:
	
	WindowsRenderer();

	void InitializeAfterWindowCreate(unsigned int Width, unsigned int Height)
	{
		InitializeGL(Width, Height);
	}
		
	void BeginFrame() override;
	void DrawScene(class WoflSprite* RootSprite) override;
	void EndFrame() override;

	void DrawString(const char* String, Vector Location, float Scale, WColor& Color) override;

	virtual Vector GetTextureSize(unsigned int Texture) override;


protected:

	void InitializeGL(GLuint InWidth, GLuint InHeight);

	void LoadShaders();
	GLuint CompileShader(const char* Shader, GLenum ShaderType);
	void CreateBuffers();

	void MakeSpriteMatrix(const class WoflSprite* Sprite);
	void MakeViewMatrix();

	void DrawSprite(WoflSprite* Sprite);

	int CreateUncompressedTexture(unsigned int Width, unsigned int Height, void* Contents) override
	{
		unsigned int TexId;
		// Use OpenGL ES to generate a name for the texture.
		GLCHECK(glGenTextures(1, &TexId));
		// Bind the texture name.
		GLCHECK(glBindTexture(GL_TEXTURE_2D, TexId));
		// Set the texture parameters to use a minifying filter and a linear filer (weighted average)
		GLCHECK(glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR));
		// Specify a 2D texture image, providing the a pointer to the image data in memory
		GLCHECK(glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, Width, Height, 0, GL_RGBA, GL_UNSIGNED_BYTE, Contents));

		return (int)TexId;
	}


	GLuint SpriteShader;

	GLint UVScaleBiasUniform;
	GLint SpriteMatrixUniform;
	GLint SpriteTextureUniform;
	GLint ViewMatrixUniform;
	GLint ColorUniform;
	GLfloat SpriteMatrix[4][4];
	GLfloat ViewMatrix[4][4];

	GLuint CornerAttrib;
	GLuint SpriteVertexArray;
	GLuint SpriteVB;
};
