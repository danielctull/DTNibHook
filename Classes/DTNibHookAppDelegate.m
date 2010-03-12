//
//  DTNibHookAppDelegate.m
//  DTNibHook
//
//  Created by Daniel Tull on 11.03.2010.
//  Copyright Daniel Tull 2010. All rights reserved.
//

#import "DTNibHookAppDelegate.h"
#import "DTTestNibHook.h"
#import "DTTestTableViewController.h"

@implementation DTNibHookAppDelegate

@synthesize window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
	// This test shows two different instances of the Test Nib Hook. 
	// The first instance creates its view from the nib and assigns all the tags for its properties.
	// The second takes the created view and links its properties to the subviews using the tags.
	
	DTTestNibHook *hook = [[DTTestNibHook alloc] initWithNibName:@"DTTestNibHook" bundle:nil];
	[hook logProperties];
	UIView *view = [hook.view retain];
	[hook release];
	
	DTTestNibHook *hook2 = [[DTTestNibHook alloc] initWithView:view];
	[hook2 logProperties];
	[hook2 release];
	
	
	
	
	DTTestTableViewController *vc = [[DTTestTableViewController alloc] init];
	vc.title = @"DTNibHook";
	navController = [[UINavigationController alloc] initWithRootViewController:vc];
	[vc release];
	
	[window addSubview:navController.view];
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
