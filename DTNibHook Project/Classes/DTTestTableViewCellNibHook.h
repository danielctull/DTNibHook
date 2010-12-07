//
//  DTTestTableViewCellNibHook.h
//  DTNibHook
//
//  Created by Daniel Tull on 12.03.2010.
//  Copyright 2010 Daniel Tull. All rights reserved.
//

#import "DTNibHook.h"

@interface DTTestTableViewCellNibHook : DTNibHook {
	UILabel *label;
	UIActivityIndicatorView *indicator;
}
@property (nonatomic, assign) IBOutlet UILabel *label;
@property (nonatomic, assign) IBOutlet UIActivityIndicatorView *indicator;
@end
