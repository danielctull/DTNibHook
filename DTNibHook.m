/*
 DTNibHook.m
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

#import "DTNibHook.h"
#import <objc/runtime.h>

@interface DTNibHook ()

- (void)generatePropertyList;
- (void)setTagsForProperties;
- (void)hookPropertiesToIBTags;
@end

NSInteger const DTNibHookMainViewTag = 1911;
NSInteger const DTNibHookTagStartNumber = 1912;
NSInteger const DTNibHookFailNumber = -1911;

@implementation DTNibHook

@synthesize view;

+ (id)nibHookWithNibName:(NSString *)nibName {
	return [self nibHookWithNibName:nibName bundle:nil];
}

+ (id)nibHookWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle {
	return [[[self alloc] initWithNibName:nibName bundle:bundle] autorelease];
}

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle {
	
	if (!(self = [super init])) return nil;
	
	if (!bundle) bundle = [NSBundle mainBundle];
	
	[bundle loadNibNamed:nibName owner:self options:nil];
	
	[self generatePropertyList];
	[self setTagsForProperties];
	
	return self;
}

+ (id)nibHookWithView:(UIView *)aView {
	return [[[self alloc] initWithView:aView] autorelease];
}

- (id)initWithView:(UIView *)aView {
	
	if (!(self = [super init])) return nil;
	
	view = [aView retain];
	
	[self generatePropertyList];
	[self hookPropertiesToIBTags];
	
	return self;
}

- (void)dealloc {
	[view release];
	[super dealloc];
}

- (void)generatePropertyList {

	NSUInteger outCount;
	
	objc_property_t *properties = class_copyPropertyList([self class], &outCount);
	
	NSMutableArray *tempList = [[NSMutableArray alloc] init];
	
	for (NSUInteger i = 0; i < outCount; i++) {
		objc_property_t property = properties[i];
		
		const char *propertyName = property_getName(property);
		
		NSString *nameString = [[NSString alloc] initWithCString:propertyName];
		
		if (![nameString isEqualToString:@"view"])
			[tempList addObject:nameString];
		
		[nameString release];
		
	}
	
	free(properties);
	
	[propertyList release];
	propertyList = nil;
	propertyList = [[NSArray alloc] initWithArray:tempList];
	
	[tempList release];
	
	self.view.tag = DTNibHookMainViewTag;
	
}

- (void)setTagsForProperties {
	
	if (self.view.tag != DTNibHookMainViewTag)
		return;
	
	for (NSString *name in propertyList) {
		
		const char *cString = [name cStringUsingEncoding:[NSString defaultCStringEncoding]];
		
		SEL getSelector = sel_registerName(cString);
		
		UIView *v = [self performSelector:getSelector];
		v.tag = [self hookTagForPropertyName:name];
		
	}
	
}

- (void)hookPropertiesToIBTags {
	
	for (NSString *name in propertyList) {
		
		NSString *firstCaps = [[name substringToIndex:1] capitalizedString];
		NSString *rest = [name substringFromIndex:1];
		
		NSString *setString = [NSString stringWithFormat:@"set%@%@:", firstCaps, rest];
		
		const char *cSetString = [setString cStringUsingEncoding:[NSString defaultCStringEncoding]];
		
		SEL setSelector = sel_registerName(cSetString);
		
		UIView *v = [self.view viewWithTag:[self hookTagForPropertyName:name]];
		
		[self performSelector:setSelector withObject:v];
		
	}
	
}
		 
- (NSInteger)hookTagForPropertyName:(NSString *)propertyName {
	
	if (![propertyList containsObject:propertyName]) return DTNibHookFailNumber;
	
	NSInteger theIndex = [propertyList indexOfObject:propertyName];
	return theIndex + DTNibHookTagStartNumber;
}

- (void)logProperties {
	
	NSLog(@"%@: main view(%i) %@", self, self.view.tag, self.view);
	
	for (NSString *name in propertyList) {
		
		const char *cString = [name cStringUsingEncoding:[NSString defaultCStringEncoding]];
		
		SEL getSelector = sel_registerName(cString);
		
		UIView *v = [self performSelector:getSelector];
		
		NSLog(@"%@: %@(%i) %@", self, name, v.tag, v);
		
	}
}

@end
