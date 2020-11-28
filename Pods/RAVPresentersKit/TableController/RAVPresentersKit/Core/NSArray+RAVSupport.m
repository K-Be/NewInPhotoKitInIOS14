//
//  NSArray+RAVSupport.m
//  RAVPresentersKit
//
//  Created by Andrew Romanov on 11/03/16.
//  Copyright © 2016 BL. All rights reserved.
//

#import "NSArray+RAVSupport.h"

@implementation NSArray (RAVSupport)

- (id)rav_findObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
	id object = [self rav_findObjectWithOptions:kNilOptions passingTest:predicate];
	return object;
}


- (id)rav_findObjectWithOptions:(NSEnumerationOptions)opt passingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
	id object = nil;
	if (predicate)
	{
		NSInteger index = [self indexOfObjectWithOptions:opt passingTest:predicate];
		if (index != NSNotFound)
		{
			object = [self objectAtIndex:index];
		}
	}
	else
	{
		NSAssert(NO, @"not configured predicate");
	}
	
	return object;
}


@end
