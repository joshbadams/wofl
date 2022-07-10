//
//  iOSSupport.cpp
//  Wofl
//
//  Created by Josh on 2/4/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#include <jni.h>
#include "AndroidRender.h"
#include "WoflWorld.h"
#include "WoflApp.h"

extern "C"
{
    JNIEXPORT void JNICALL Java_com_moshpit_scrolly_GLES3JNILib_init(JNIEnv* env, jobject obj);
    JNIEXPORT void JNICALL Java_com_moshpit_scrolly_GLES3JNILib_resize(JNIEnv* env, jobject obj, jint width, jint height);
    JNIEXPORT void JNICALL Java_com_moshpit_scrolly_GLES3JNILib_step(JNIEnv* env, jobject obj);
};


static void printGlString(const char* name, GLenum s)
{
    const char* v = (const char*)glGetString(s);
    WLOG("GL %s: %s\n", name, v);
}

JNIEXPORT void JNICALL
Java_com_moshpit_scrolly_GLES3JNILib_init(JNIEnv* env, jobject obj)
{
	delete WoflRenderer::Renderer;
	AndroidRenderer* Renderer = new AndroidRenderer;

	WoflApplication::Initialize();
}

JNIEXPORT void JNICALL
Java_com_moshpit_scrolly_GLES3JNILib_resize(JNIEnv* env, jobject obj, jint width, jint height)
{
	WoflRenderer::Renderer->InitializeGL(width, height);

    printGlString("Version", GL_VERSION);
    printGlString("Vendor", GL_VENDOR);
    printGlString("Renderer", GL_RENDERER);
    printGlString("Extensions", GL_EXTENSIONS);

    const char* versionStr = (const char*)glGetString(GL_VERSION);
    WLOG("versionStr: %s\n", versionStr);
    WLOG("ScreenSize: %d x %d\n", width, height);
}

JNIEXPORT void JNICALL
Java_com_moshpit_scrolly_GLES3JNILib_step(JNIEnv* env, jobject obj)
{
//	WLOG("Ticking");
	WoflApplication::Tick();
	WoflApplication::Render();
}
