//
//  AppDelegate.m
//  Neuro
//
//  Created by Josh Adams on 4/9/23.
//

#import "AppDelegate.h"
#import "NeuroGame.h"

@interface AppDelegate ()


@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	WoflGame* Game = new NeuroGame;
	WoflApplication::Initialize(Game);
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
	return YES;
}


@end
