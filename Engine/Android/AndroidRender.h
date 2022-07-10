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

class AndroidRenderer : public WoflRenderer
{

	void InitializeGL(GLuint InWidth, GLuint InHeight);

protected:
	
	void LoadShaders();
	GLuint CompileShader(const char* Shader, GLenum ShaderType);
	void CreateBuffers();
	
	void MakeSpriteMatrix(const class WoflSprite* Sprite);
	void MakeViewMatrix();
	
	void DrawSprite(WoflSprite* Sprite);

	
	int32 CreateUncompressedTexture(uint32 Width, uint32 Height, void* Contents)
	{
		// Use OpenGL ES to generate a name for the texture.
		GLCHECK(glGenTextures(1, &Info.Texture));
		// Bind the texture name.
		GLCHECK(glBindTexture(GL_TEXTURE_2D, Info.Texture));
		// Set the texture parameters to use a minifying filter and a linear filer (weighted average)
		GLCHECK(glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR));
		// Specify a 2D texture image, providing the a pointer to the image data in memory
		GLCHECK(glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, Info.Width, Info.Height, 0, GL_RGBA, GL_UNSIGNED_BYTE, ImageContents));

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

#endif
