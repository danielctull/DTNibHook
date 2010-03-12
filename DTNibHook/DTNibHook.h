//
//  DTNibHook.h
//  DTNibHook
//
//  Created by Daniel Tull on 11.03.2010.
//  Copyright 2010 Daniel Tull. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSInteger const DTNibHookFailNumber;

@interface DTNibHook : NSObject {
	NSArray *propertyList;
	UIView *view;
}

@property (nonatomic, retain) IBOutlet UIView *view;

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle;
- (id)initWithView:(UIView *)aView;

- (NSInteger)hookTagForPropertyName:(NSString *)propertyName;
- (void)logProperties;
@end
