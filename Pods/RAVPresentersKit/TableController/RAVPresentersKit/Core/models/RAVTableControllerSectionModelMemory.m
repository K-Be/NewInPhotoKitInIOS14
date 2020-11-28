//
//  RAVTableControllerSectionModelMemory.m
//  TableController
//
//  Created by Andrew Romanov on 23.04.14.
//  Copyright (c) 2014 Andrew Romanov. All rights reserved.
//

#import "RAVTableControllerSectionModelMemory.h"

@implementation RAVTableControllerSectionModelMemory

- (id)init
{
	if (self = [super init])
	{
		_models = [[NSMutableArray alloc] init];
	}
	
	return self;
}


- (id)copyWithZone:(NSZone *)zone
{
	typeof(self) copy = [[[self class] alloc] init];
	[copy.models addObjectsFromArray:self.models];
	copy.headerViewModel = self.headerViewModel;
	copy.footerViewModel = self.footerViewModel;
	
	return copy;
}


- (NSInteger)numberObjects
{
	return [self.models count];
}


- (id)modelForRow:(NSInteger)rowIndex;
{
	id model = [self.models objectAtIndex:(NSUInteger)rowIndex];
	return model;
}


- (void)removeModelAtIndex:(NSInteger)index
{
	[self.models removeObjectAtIndex:(NSUInteger)index];
}


- (void)insertModel:(id)model atIndex:(NSInteger)index
{
	[self.models insertObject:model atIndex:(NSUInteger)index];
}


- (void)exchangeModelAtIndex:(NSInteger)firstModelIndex withModelatIndex:(NSInteger)secondModelIndex
{
	[self.models exchangeObjectAtIndex:(NSUInteger)firstModelIndex withObjectAtIndex:(NSUInteger)secondModelIndex];
}

@end
