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

@interface ViewController () {
	
	WoflRenderer* Renderer;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// set up Metal view
	MTKView* View = (MTKView *)self.view;
	View.device = MTLCreateSystemDefaultDevice();
	
	Renderer = new iOSRenderer(View);
	
	View.delegate = self;

	
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
	
	
	// let the application startup
	WoflApplication::Initialize();

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
    [super didReceiveMemoryWarning];

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


@end
