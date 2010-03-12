//
//  DTNibHook.m
//  DTNibHook
//
//  Created by Daniel Tull on 11.03.2010.
//  Copyright 2010 Daniel Tull. All rights reserved.
//

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

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle {
	
	if (!(self = [super init])) return nil;
	
	if (!bundle)
		bundle = [NSBundle mainBundle];
	
	[bundle loadNibNamed:nibName owner:self options:nil];
	
	[self generatePropertyList];
	[self setTagsForProperties];
	
	return self;
}

- (id)initWithView:(UIView *)aView {
	
	if (!(self = [super init])) return nil;
	
	view = [aView retain];
	
	[self generatePropertyList];
	[self hookPropertiesToIBTags];
	
	return self;
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
	
	NSInteger index = [propertyList indexOfObject:propertyName];
	return index + DTNibHookTagStartNumber;
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
