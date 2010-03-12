//
//  DTTestNibHookTableViewController.m
//  DTNibHook
//
//  Created by Daniel Tull on 12.03.2010.
//  Copyright 2010 Daniel Tull. All rights reserved.
//

#import "DTTestNibHookTableViewController.h"
#import "DTTestTableViewCellNibHook.h"

NSString *const DTTestNibHookTableViewControllerCellReuseIdentifier = @"Cell";

@implementation DTTestNibHookTableViewController

#pragma mark -
#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[tableView dequeueReusableCellWithIdentifier:DTTestNibHookTableViewControllerCellReuseIdentifier] retain];
	DTTestTableViewCellNibHook *nibHook;
	
    if (cell) {
		nibHook = [[DTTestTableViewCellNibHook alloc] initWithView:cell];
	} else {
		nibHook = [[DTTestTableViewCellNibHook alloc] initWithNibName:@"DTTestTableViewCell" bundle:nil];
		cell = [(UITableViewCell *)nibHook.view retain];
    }
	
	nibHook.label.text = [NSString stringWithFormat:@"Cell number %i", indexPath.row];
	
	if (indexPath.row % 2 == 0)
		[nibHook.indicator startAnimating];
	else 
		[nibHook.indicator stopAnimating];
    
	[nibHook release];
	
    return [cell autorelease];
}

@end

