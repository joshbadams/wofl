//
//  Render.cpp
//  Wofl
//
//  Created by Josh on 2/4/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#include "WindowsRenderer.h"
#include "WoflUtils.h"
#include "WoflSprite.h"
#include "WoflImage.h"
#include "WoflWorld.h"

#define BUFFER_OFFSET(i) ((char *)NULL + (i))
enum Attributes
{
	Attrib_Corner,
	Attrib_UV,
};


WindowsRenderer::WindowsRenderer()
	: WoflRenderer()
{
}

static void InitMatrix(GLfloat M[4][4])
{
	memset(M[0], 0, sizeof(M[0]));
	memset(M[1], 0, sizeof(M[1]));
	memset(M[2], 0, sizeof(M[2]));
	memset(M[3], 0, sizeof(M[3]));
	M[0][0] = 1.0f;
	M[1][1] = 1.0f;
	M[2][2] = 1.0f;
	M[3][3] = 1.0f;
}


void WindowsRenderer::InitializeGL(GLuint InWidth, GLuint InHeight)
{
	ViewSize = Vector((float)InWidth, (float)InHeight);
	
	// let the platform do its thing
//	PlatformInitializeGL();
	
	// crank up GL objects
	LoadShaders();
	CreateBuffers();
	
	// set up the reusable matrix
	InitMatrix(SpriteMatrix);
	InitMatrix(ViewMatrix);
	
	GLCHECK(glDisable(GL_CULL_FACE));
	GLCHECK(glDisable(GL_DEPTH_TEST));
	GLCHECK(glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA));
	GLCHECK(glEnable(GL_BLEND));
}

void WindowsRenderer::LoadShaders()
{
	GLuint VertexShader = CompileShader("Shader.vsh", GL_VERTEX_SHADER);
	GLuint FragmentShader = CompileShader("Shader.fsh", GL_FRAGMENT_SHADER);
	
	GLCHECK(SpriteShader = glCreateProgram());
	
	// attach shaders to program
	GLCHECK(glAttachShader(SpriteShader, VertexShader));
    GLCHECK(glAttachShader(SpriteShader, FragmentShader));
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    GLCHECK(glBindAttribLocation(SpriteShader, Attrib_Corner, "Corner"));

	GLCHECK(glLinkProgram(SpriteShader));
	
	GLCHECK(UVScaleBiasUniform = glGetUniformLocation(SpriteShader, "UVScaleBias"));
	GLCHECK(SpriteMatrixUniform = glGetUniformLocation(SpriteShader, "SpriteMatrix"));
	GLCHECK(SpriteTextureUniform = glGetUniformLocation(SpriteShader, "SpriteTexture"));
	GLCHECK(ViewMatrixUniform = glGetUniformLocation(SpriteShader, "ViewMatrix"));
	GLCHECK(ColorUniform = glGetUniformLocation(SpriteShader, "Color"));
}

GLuint WindowsRenderer::CompileShader(const char* ShaderName, GLenum ShaderType)
{
	// laod the file
	std::string ShaderPath = Utils::File->GetResourcePath(ShaderName);
	std::string ShaderContents = Utils::File->LoadFileToString(ShaderPath.c_str());
	
	WLOG("Compile shader with %s\n", ShaderPath.c_str());

	// compile it
	GLCHECK(GLuint Shader = glCreateShader(ShaderType));
	const char* Buffer = ShaderContents.c_str();
    GLCHECK(glShaderSource(Shader, 1, &Buffer, NULL));
    GLCHECK(glCompileShader(Shader));
    
#if 1//def DEBUG
    GLint LogLength;
    glGetShaderiv(Shader, GL_INFO_LOG_LENGTH, &LogLength);
    if (LogLength > 0)
	{
        GLchar* Log = (GLchar *)malloc(LogLength);
        glGetShaderInfoLog(Shader, LogLength, &LogLength, Log);
        WLOG("Shader compile log:\n%s\n", Log);
        WLOG("Shader source:\n%s\n", Buffer);
        free(Log);
    }
#endif
    
	GLint Status;
    glGetShaderiv(Shader, GL_COMPILE_STATUS, &Status);
    if (Status == 0)
	{
        glDeleteShader(Shader);
        return 0;
    }
    
    return Shader;
	
	
}

void WindowsRenderer::CreateBuffers()
{
    GLCHECK(glGenBuffers(1, &SpriteVB));
    GLCHECK(glBindBuffer(GL_ARRAY_BUFFER, SpriteVB));
	
	GLfloat Verts[] =
	{
		0.0f, 0.0f,
		1.0f, 0.0f,
		1.0f, 1.0f,
		0.0f, 0.0f,
		1.0f, 1.0f,
		0.0f, 1.0f,
	};

#if SUPPORTS_VERTEX_ARRAYS
    GLCHECK(glGenVertexArraysOES(1, &SpriteVertexArray));
    GLCHECK(glBindVertexArrayOES(SpriteVertexArray));

	
    GLCHECK(glBufferData(GL_ARRAY_BUFFER, sizeof(Verts), Verts, GL_STATIC_DRAW));
    
    GLCHECK(glEnableVertexAttribArray(Attrib_Corner));
    GLCHECK(glVertexAttribPointer(Attrib_Corner, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 2, BUFFER_OFFSET(0)));
    
    GLCHECK(glBindVertexArrayOES(0));

#else

    CornerAttrib = glGetAttribLocation(SpriteShader, "Corner");

#endif
}

void WindowsRenderer::MakeSpriteMatrix(const WoflSprite* Sprite)
{
	Vector Pos = Sprite->GetPosition();
	Vector Size = Sprite->GetSize();
	
	SpriteMatrix[3][0] = Pos.X;
//	SpriteMatrix[3][1] = ViewSize.Y - Pos.Y;
	SpriteMatrix[3][1] = Pos.Y;
//	SpriteMatrix[3][0] = (Pos.X);// / (GLfloat)ViewSize.X) * 2.0f - 1.0f;
//	SpriteMatrix[3][1] = ((ViewSize.Y - Pos.Y));// / (GLfloat)ViewSize.Y) * 2.0f - 1.0f;

	SpriteMatrix[0][0] = Size.X;
	SpriteMatrix[1][1] = Size.Y;
}

void WindowsRenderer::MakeViewMatrix()
{
	Vector ViewOffset = WoflWorld::Get()->GetViewOffset();
	Vector ViewScale = WoflWorld::Get()->GetViewScale();

	ViewMatrix[3][0] = (ViewOffset.X * 2.0f / (GLfloat)ViewSize.X) - 1.0f;
//	ViewMatrix[3][1] = (-ViewOffset.Y * 2.0f / (GLfloat)ViewSize.Y) - 1.0f;
	ViewMatrix[3][1] = (ViewOffset.Y * 2.0f / (GLfloat)ViewSize.Y) - 1.0f;
	
	ViewMatrix[0][0] = (ViewScale.X * 2.0f / (GLfloat)ViewSize.X);
	ViewMatrix[1][1] = (ViewScale.Y * 2.0f / (GLfloat)ViewSize.Y);
}

void WindowsRenderer::DrawSprite(WoflSprite* Sprite)
{
	// allow the sprite to render itself
	if (Sprite->CustomPreRender())
	{
		return;
	}
	
	// update matrix
	MakeSpriteMatrix(Sprite);
	
	// get current image
	WoflImage* Image = Sprite->GetImage();
	
	if (Image != NULL)
	{
		// render it!
		GLCHECK(glBindTexture(GL_TEXTURE_2D, Image->Texture));
		GLCHECK(glUniform1i(SpriteTextureUniform, 0));
		GLCHECK(glUniform4fv(UVScaleBiasUniform, 1, Image->UVScaleBias));
		GLCHECK(glUniform4fv(ColorUniform, 1, (float*)&Sprite->GetColor()));
		GLCHECK(glUniformMatrix4fv(SpriteMatrixUniform, 1, 0, (GLfloat*)SpriteMatrix));
		GLCHECK(glDrawArrays(GL_TRIANGLES, 0, 6));
	}

	Sprite->CustomRender();
}

void WindowsRenderer::BeginFrame()
{

}

void WindowsRenderer::EndFrame()
{

}

Vector WindowsRenderer::GetTextureSize(unsigned int Texture)
{
	return Vector(128, 128);
}

void WindowsRenderer::DrawScene(WoflSprite* RootSprite)
{
	//	GLCHECK(glClearColor(1.65f, 0.65f, 0.65f, 1.0f));
	static unsigned char b = 0;
	b++;
	GLCHECK(glClearColor(0, (float)b/255, 0, 1.0f));
	GLCHECK(glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT));

	if (RootSprite == nullptr)
	{
		return;
	}
	
#if SUPPORTS_VERTEX_ARRAYS
	GLCHECK(glBindVertexArrayOES(SpriteVertexArray));
#else
    glBindBuffer(GL_ARRAY_BUFFER, SpriteVB);
    glVertexAttribPointer(CornerAttrib, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 2, BUFFER_OFFSET(0));
    glEnableVertexAttribArray(CornerAttrib);
#endif

    GLCHECK(glUseProgram(SpriteShader));

	MakeViewMatrix();
	GLCHECK(glUniformMatrix4fv(ViewMatrixUniform, 1, 0, (GLfloat*)ViewMatrix));

	WoflWorld::Get()->Visit(true, true, false,
							[this](WoflSprite* Sprite)
							{
								DrawSprite(Sprite);
								return true;
							},
							RootSprite);
}

const char* Chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()-=_+`~[]\\{}|;':\",./<>? ";
const int TexSize = 256;
const float InvTexSize = 1.0f / (float)TexSize;
const int CharX = 18;
const int CharY = 35;
const int NumCharsX = TexSize / CharX;
//const int NumCharsY = TexSize / CharY;

void WindowsRenderer::DrawString(const char* String, Vector Location, float Scale, WColor& Color)
{
	GLCHECK(glUniform4fv(ColorUniform, 1, (float*)&Color));

	while (*String)
	{
		// find the char index
		int CharIndexX = -1, CharIndexY = -1;
		for (int i = 0; i < strlen(Chars); i++)
		{
			if (Chars[i] == *String)
			{
				CharIndexX = i % NumCharsX;
				// this +1 is there because the textue is upside down (I think)
				CharIndexY = (i / NumCharsX);
			}
		}
		
		WoflImage CharImage("Font", CharIndexX * CharX * InvTexSize, CharIndexY * CharY * InvTexSize, CharX * InvTexSize, CharY * InvTexSize);
		GLCHECK(glUniform4fv(UVScaleBiasUniform, 1, CharImage.UVScaleBias));
		GLCHECK(glBindTexture(GL_TEXTURE_2D, CharImage.Texture));
		GLCHECK(glUniform1i(SpriteTextureUniform, 0));
		
		WoflSprite CharSprite(Location.X, Location.Y, CharX * Scale, CharY * Scale);
		MakeSpriteMatrix(&CharSprite);
		GLCHECK(glUniformMatrix4fv(SpriteMatrixUniform, 1, 0, (GLfloat*)SpriteMatrix));
		GLCHECK(glDrawArrays(GL_TRIANGLES, 0, 6));
		
		Location.X += CharX * Scale;
		
		String++;
	}
}
