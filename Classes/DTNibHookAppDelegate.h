//
//  DTNibHookAppDelegate.h
//  DTNibHook
//
//  Created by Daniel Tull on 11.03.2010.
//  Copyright Daniel Tull 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTNibHookAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UINavigationController *navController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

