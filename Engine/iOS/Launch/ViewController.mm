//
//  ViewController.m
//  Wofl
//
//  Created by Josh on 2/4/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#import "ViewController.h"
#include "iOSRender.h"
#include "WoflWorld.h"
#include "WoflApp.h"
#import <Carbon/Carbon.h>

@interface WoflViewController () {
	
	WoflRenderer* Renderer;

	WoflKeys Keys[400];
}

@end

@implementation WoflViewController

- (void)viewDidAppear
{
    [super viewDidAppear];
    
	// set up Metal view
	MTKView* View = (MTKView *)self.view;

	View.device = MTLCreateSystemDefaultDevice();
	
	Renderer = new iOSRenderer(View);
	
	View.delegate = self;
	[View.window makeFirstResponder:View];

	WLOG("Window size: %f, %f - View size: %f, %f\n", self.view.bounds.size.width, self.view.bounds.size.height,
		 self.view.window.frame.size.width, self.view.window.frame.size.height);

	
	memset(Keys, 0, sizeof(Keys));
	Keys[kVK_Escape] = WoflKeys::Escape;
	Keys[kVK_Return] = WoflKeys::Enter;
	Keys[kVK_Delete] = WoflKeys::Backspace;
	Keys[kVK_Space] = WoflKeys::Space;

	Keys[kVK_ANSI_A] = WoflKeys::A;
	Keys[kVK_ANSI_B] = WoflKeys::B;
	Keys[kVK_ANSI_C] = WoflKeys::C;
	Keys[kVK_ANSI_D] = WoflKeys::D;
	Keys[kVK_ANSI_E] = WoflKeys::E;
	Keys[kVK_ANSI_F] = WoflKeys::F;
	Keys[kVK_ANSI_G] = WoflKeys::G;
	Keys[kVK_ANSI_H] = WoflKeys::H;
	Keys[kVK_ANSI_I] = WoflKeys::I;
	Keys[kVK_ANSI_J] = WoflKeys::J;
	Keys[kVK_ANSI_K] = WoflKeys::K;
	Keys[kVK_ANSI_L] = WoflKeys::L;
	Keys[kVK_ANSI_M] = WoflKeys::M;
	Keys[kVK_ANSI_N] = WoflKeys::N;
	Keys[kVK_ANSI_O] = WoflKeys::O;
	Keys[kVK_ANSI_P] = WoflKeys::P;
	Keys[kVK_ANSI_Q] = WoflKeys::Q;
	Keys[kVK_ANSI_R] = WoflKeys::R;
	Keys[kVK_ANSI_S] = WoflKeys::S;
	Keys[kVK_ANSI_T] = WoflKeys::T;
	Keys[kVK_ANSI_U] = WoflKeys::U;
	Keys[kVK_ANSI_V] = WoflKeys::V;
	Keys[kVK_ANSI_W] = WoflKeys::W;
	Keys[kVK_ANSI_X] = WoflKeys::X;
	Keys[kVK_ANSI_Y] = WoflKeys::Y;
	Keys[kVK_ANSI_Z] = WoflKeys::Z;
	Keys[kVK_ANSI_0] = WoflKeys::Zero;
	Keys[kVK_ANSI_1] = WoflKeys::One;
	Keys[kVK_ANSI_2] = WoflKeys::Two;
	Keys[kVK_ANSI_3] = WoflKeys::Three;
	Keys[kVK_ANSI_4] = WoflKeys::Four;
	Keys[kVK_ANSI_5] = WoflKeys::Five;
	Keys[kVK_ANSI_6] = WoflKeys::Six;
	Keys[kVK_ANSI_7] = WoflKeys::Seven;
	Keys[kVK_ANSI_8] = WoflKeys::Eight;
	Keys[kVK_ANSI_9] = WoflKeys::Nine;
	
	Keys[kVK_UpArrow] = WoflKeys::UpArrow;
	Keys[kVK_DownArrow] = WoflKeys::DownArrow;
	Keys[kVK_LeftArrow] = WoflKeys::LeftArrow;
	Keys[kVK_RightArrow] = WoflKeys::RightArrow;
	
	Keys[kVK_F1] = WoflKeys::F1;
	Keys[kVK_F2] = WoflKeys::F2;
	Keys[kVK_F3] = WoflKeys::F3;
	Keys[kVK_F4] = WoflKeys::F4;
	Keys[kVK_F5] = WoflKeys::F5;
	Keys[kVK_F6] = WoflKeys::F6;
	Keys[kVK_F7] = WoflKeys::F7;
	Keys[kVK_F8] = WoflKeys::F8;
	Keys[kVK_F9] = WoflKeys::F9;
	Keys[kVK_F10] = WoflKeys::F10;
	Keys[kVK_F11] = WoflKeys::F11;
	Keys[kVK_F12] = WoflKeys::F12;


	// for landscape view, swap the width and height
//	UIDevice* Dev = [UIDevice currentDevice];
//	[Dev beginGeneratingDeviceOrientationNotifications];
//	if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
//	{
//		unsigned int T = Width;
//		Width = Height;
//		Height = T;
//	}
//	[Dev endGeneratingDeviceOrientationNotifications];
	
#if !IS_WOFL_LIBRARY
	// let the application startup
	WoflApplication::Initialize();
#endif
	
}

- (void)dealloc
{
	delete Renderer;
}

- (BOOL)prefersStatusBarHidden
{
	return YES;
}

- (void)didReceiveMemoryWarning
{
#if !TARGET_OS_MAC
    [super didReceiveMemoryWarning];
#endif
	
//    if ([self isViewLoaded] && ([[self view] window] == nil)) {
//        self.view = nil;
//
////        [self tearDownGL];
//
//        if ([EAGLContext currentContext] == self.context) {
//            [EAGLContext setCurrentContext:nil];
//        }
//        self.context = nil;
//    }

    // Dispose of any resources that can be recreated.
}


- (void)drawInMTKView:(nonnull MTKView *)view
{
	WoflApplication::Tick();
	WoflApplication::Render();
	
}

- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size
{
	
}

#if TARGET_OS_MAC

-(void)mouseDown:(NSEvent *)event
{
	NSPoint Loc = [event locationInWindow];
	Loc.y = self.view.window.frame.size.height - Loc.y;
	Loc = [self.view.window convertPointToBacking:Loc];
	
	Utils::Input->AddTouch(0, Loc.x, Loc.y, TouchType::Begin);
}

-(void)mouseUp:(NSEvent *)event
{
	NSPoint Loc = [event locationInWindow];
	Loc.y = self.view.window.frame.size.height - Loc.y;
	Loc = [self.view.window convertPointToBacking:Loc];

	Utils::Input->AddTouch(0, Loc.x, Loc.y, TouchType::End);
}

-(void)keyDown:(NSEvent *)event
{
	int Char = [[event characters] characterAtIndex:0];
//	NSLog(@"keydown %d / char %d\n", [event keyCode], Char);

	if (Char >= 0x7f)
	{
		// only allow Repeats on char presses
		if ([event isARepeat])
		{
			return;
		}
		Char = 0;
	}
	Utils::Input->AddKey(Keys[[event keyCode]], Char, [event isARepeat] ? KeyType::Repeat : KeyType::Down);
}

-(void)keyUp:(NSEvent *)event
{
	int Char = [[event characters] characterAtIndex:0];
	if (Char >= 0x7f) Char = 0;
	Utils::Input->AddKey(Keys[[event keyCode]], Char, KeyType::Up);
//	NSLog(@"keyup %d\n", [event keyCode]);
}

#else

static UITouch* Fingers[10];

- (void)AddTouches:(NSSet*)touches ofType:(TouchType)type
{
	for (UITouch* Touch in touches)
	{
		CGPoint Loc = [Touch locationInView:self.view];
		Loc.y = [self.view bounds].size.height - Loc.y;
		
		int FingerIndex;
		if (Touch.phase == UITouchPhaseBegan)
		{
			assert(type == TouchType::Begin);
			
			// find unused slot
			for (FingerIndex = 0; FingerIndex < ARRAY_COUNT(Fingers); FingerIndex++)
			{
				if (Fingers[FingerIndex] == nullptr)
				{
					Fingers[FingerIndex] = Touch;
					break;
				}
			}
		}
		else
		{
			// find unused slot
			for (FingerIndex = 0; FingerIndex < ARRAY_COUNT(Fingers); FingerIndex++)
			{
				if (Fingers[FingerIndex] == Touch)
				{
					if (Touch.phase == UITouchPhaseEnded || Touch.phase == UITouchPhaseCancelled)
					{
						assert(type == TouchType::End);
						Fingers[FingerIndex] = nullptr;
					}
					break;
				}
			}
		}
		
		Utils::Input->AddTouch(FingerIndex, Loc.x * self.view.contentScaleFactor, Loc.y * self.view.contentScaleFactor, type);
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self AddTouches:touches ofType:TouchType::Begin];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
{
	[self AddTouches:touches ofType:TouchType::Update];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
	[self AddTouches:touches ofType:TouchType::End];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
{
	[self touchesEnded:touches withEvent:event];
}

#endif


@end
