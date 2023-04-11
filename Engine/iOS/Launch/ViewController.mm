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

@interface WoflViewController () {
	
	WoflRenderer* Renderer;
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

	WLOG("Window size: %f, %f - View size: %f, %f\n", self.view.bounds.size.width, self.view.bounds.size.height,
		 self.view.window.frame.size.width, self.view.window.frame.size.height);

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
