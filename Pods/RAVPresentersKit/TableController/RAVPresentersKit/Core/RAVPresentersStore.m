//
//  RAVPresentersStore.m
//  TableController
//
//  Created by Andrew Romanov on 02.07.14.
//  Copyright (c) 2014 Andrew Romanov. All rights reserved.
//

#import "RAVPresentersStore.h"
#import "NSArray+RAVSupport.h"


@interface RAVPresentersStore ()

@property (nonatomic, strong) NSMutableArray<id<RAVPresenterP>>* rav_presenters;

@end


@implementation RAVPresentersStore

- (id)init
{
	if (self = [super init])
	{
		self.rav_presenters = [[NSMutableArray alloc] init];
	}
	
	return self;
}


- (void)registerPresenter:(id<RAVPresenterP>)presenter
{
	[self.rav_presenters addObject:presenter];
}


- (id<RAVPresenterP>)presenterForModel:(id)model
{
	id<RAVPresenterP> presenter = nil;
	
	if (model)
	{
		presenter = [self.rav_presenters rav_findObjectPassingTest:^BOOL(id<RAVPresenterP> presenterCandidate, NSUInteger idx, BOOL *stop) {
			BOOL requiredObject = [presenterCandidate canPresent:model];
			return requiredObject;
		}];
		NSAssert(presenter != nil, @"can't find presenter for model: %@", model);
	}
	
	return presenter;
}


- (void)makeObjectsPerformSelector:(SEL)selector withObject:(id)object
{
	[self.rav_presenters makeObjectsPerformSelector:selector withObject:object];
}


- (void)makeObjectsPerformSelector:(SEL)selector
{
	[self.rav_presenters makeObjectsPerformSelector:selector];
}

@end
