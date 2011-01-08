/*
 DTNibHook.h
 DTNibHook
 
 Created by Daniel Tull on 11.03.2010.
 
 
 
 
 Copyright (c) 2010 Daniel Tull. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 * Neither the name of the author nor the names of its contributors may be used
 to endorse or promote products derived from this software without specific
 prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <Foundation/Foundation.h>

extern NSInteger const DTNibHookFailNumber;

/** The idea behind DTNibHook is to be able to create a custom view in a nib 
 and being able to change certain views in code later on when presented with
 just that view. A good example of when we’d like to do this is with UITableViewCells,
 we hand the cell over to the table view and when we want to reuse it, all we have is
 the cell itself.
  
 You should to subclass this class and add properties for the subviews you wish to access
 later on. Your subclass then becomes the File Owner in the nib file for your view/table
 cell, where you can attach the outlet properties to the subviews and the view property 
 to your view/table cell.
 
 The following example uses a cell from a nib named DTTestCell with a sole property label. With the new runtime, our nib hook subclass looks like this:
 
	@interface DTTestNibHook : DTNibHook {}
	@property (nonatomic, retain) IBOutlet UILabel *label;
	@end
	
	@implementation DTTestNibHook
	@synthesize label;
	@end
 
 Upon loading a nib file, a nib hook dynamically sets the tag property for each 
 of the connected subviews, using a number based on the property’s alphabetised
 order. This enables another instance to bind itself to the main view and set up 
 the properties later on using the same method of ordering the property names. In 
 either case, you can access the properties of the nib hook to manipulate the subviews.
 
	- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)ip {
		
		UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"TestCell"];
		DTTestNibHook *nibHook;
		
		if (cell) {
			nibHook = [[DTTestNibHook alloc] initWithView:cell];
		} else {
			nibHook = [[DTTestNibHook alloc] initWithNibName:@"DTTestCell" bundle:nil];
			cell = [[(UITableViewCell *)nibHook.view retain] autorelease];
		}
		
		nibHook.label.text = [NSString stringWithFormat:@"Cell number %i", ip.row];
		
		[nibHook release];
		
		return cell;
	}
 
 */
@interface DTNibHook : NSObject {
	NSArray *propertyList;
	UIView *view;
}

/// @name Hooking a NibHook to a nib
+ (id)nibHookWithNibName:(NSString *)nibName;
+ (id)nibHookWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle;
- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle;

/// @name Hooking a NibHook to a view
+ (id)nibHookWithView:(UIView *)aView;
- (id)initWithView:(UIView *)aView;

/// @name Getting the View
@property (nonatomic, retain) IBOutlet UIView *view;

/// @name Internal?
- (NSInteger)hookTagForPropertyName:(NSString *)propertyName;

/// @name For Testing
- (void)logProperties;
@end
