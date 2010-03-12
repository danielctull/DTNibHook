//
//  DTTestNibHook.h
//  DTNibHook
//
//  Created by Daniel Tull on 11.03.2010.
//  Copyright 2010 Daniel Tull. All rights reserved.
//

#import "DTNibHook.h"


@interface DTTestNibHook : DTNibHook {
	UILabel *label;
	UIImageView *imageView;
	UIActivityIndicatorView *indicator;
}

@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;

@end
