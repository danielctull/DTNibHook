//
//  DTNibHookAppDelegate.m
//  DTNibHook
//
//  Created by Daniel Tull on 11.03.2010.
//  Copyright Daniel Tull 2010. All rights reserved.
//

#import "DTNibHookAppDelegate.h"
#import "DTTestNibHook.h"
#import "DTTestNibHookTableViewController.h"

@implementation DTNibHookAppDelegate

@synthesize window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	DTTestNibHook *hook = [[DTTestNibHook alloc] initWithNibName:@"DTTestNibHook" bundle:nil];
	[hook logProperties];
	UIView *view = [hook.view retain];
	[hook release];
	
	DTTestNibHook *hook2 = [[DTTestNibHook alloc] initWithView:view];
	[hook2 logProperties];
	[hook2 release];
	
	DTTestNibHookTableViewController *vc = [[DTTestNibHookTableViewController alloc] init];
	[window addSubview:vc.view];
	
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
