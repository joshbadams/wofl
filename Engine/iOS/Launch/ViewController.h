//
//  ViewController.h
//  Wofl
//
//  Created by Josh on 2/4/13.
//  Copyright (c) 2013 Josh. All rights reserved.
//

#import <MetalKit/MetalKit.h>

#if TARGET_OS_MAC
	#import <AppKit/AppKit.h>
@interface WoflViewController : NSViewController <MTKViewDelegate>
#else
	#import <UIKit/UIKit.h>
@interface WoflViewController : UIViewController <MTKViewDelegate>
#endif
{
	class WoflWorld* TheWorld;
}


@end

