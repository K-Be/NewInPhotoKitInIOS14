//
//  RAVTableControllerListModelMemory.m
//  TableController
//
//  Created by Andrew Romanov on 23.04.14.
//  Copyright (c) 2014 Andrew Romanov. All rights reserved.
//

#import "RAVTableControllerListModelMemory.h"

@implementation RAVTableControllerListModelMemory

- (id)init
{
	if (self = [super init])
	{
		_sectionModels = [[NSMutableArray alloc] init];
	}
	
	return self;
}


- (NSInteger)countSections
{
	return [self.sectionModels count];
}


- (id<RAVTableControllerSectionModelP>)getSectionModelForSection:(NSInteger)section
{
	return [self.sectionModels objectAtIndex:(NSUInteger)section];
}


- (id)getModelForIndexPath:(NSIndexPath*)indexPath
{
	RAVTableControllerSectionModelMemory * sectionModel = [self sectionModelForSectionIndex:indexPath.section];
	id model = [sectionModel modelForRow:indexPath.row];
	return model;
}


- (void)moveModelAtIndexPath:(NSIndexPath*)indexPath toIndexPath:(NSIndexPath*)destinationIndexPath
{
	RAVTableControllerSectionModelMemory * sectionModel = [self sectionModelForSectionIndex:indexPath.section];
	id model = [sectionModel modelForRow:indexPath.row];
	[sectionModel removeModelAtIndex:indexPath.row];
		
	RAVTableControllerSectionModelMemory * destinationSectionModel = [self sectionModelForSectionIndex:destinationIndexPath.section];
	[destinationSectionModel insertModel:model atIndex:destinationIndexPath.row];
}


- (id)removeModelAtIndexPath:(NSIndexPath*)indexPath
{
	RAVTableControllerSectionModelMemory * sectionModel = [self sectionModelForSectionIndex:indexPath.section];
	id model = [sectionModel modelForRow:indexPath.row];
	[sectionModel removeModelAtIndex:indexPath.row];
	return model;
}


- (void)removeModelsAtIndexPaths:(NSArray*)indexPaths
{
	if ([indexPaths count] > 1)
	{
		NSArray* sortedIndexes = [indexPaths sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
			NSComparisonResult nativeResult = [(NSIndexPath*)obj1 compare:obj2];
			NSComparisonResult result = nativeResult;
			if (nativeResult == NSOrderedAscending)
			{
				result = NSOrderedDescending;
			}
			else if (nativeResult == NSOrderedDescending)
			{
				result = NSOrderedAscending;
			}
			
			return result;
		}];
		
		[sortedIndexes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			[self removeModelsAtIndexPaths:obj];
		}];
	}
	else if ([indexPaths count] == 1)
	{
		[self removeModelAtIndexPath:[indexPaths firstObject]];
	}
}


- (void)insertCellModel:(id)model toIndexPath:(NSIndexPath*)indexPath
{
	RAVTableControllerSectionModelMemory * sourceSectionModel = [self sectionModelForSectionIndex:indexPath.section];
	[sourceSectionModel insertModel:model atIndex:indexPath.row];
}


- (void)exchangeModelAtIndexPath:(NSIndexPath*)indexPath withModelAtIndexPath:(NSIndexPath*)otherIndexPath
{
	if (indexPath.section == otherIndexPath.section)
	{
		RAVTableControllerSectionModelMemory * sourceSectionModel = [self sectionModelForSectionIndex:indexPath.section];
		[sourceSectionModel exchangeModelAtIndex:indexPath.row withModelatIndex:otherIndexPath.row];
	}
	else
	{
		RAVTableControllerSectionModelMemory* firstSection = [self sectionModelForSectionIndex:indexPath.section];
		id modelFromFirstSection = [firstSection modelForRow:indexPath.row];
		
		RAVTableControllerSectionModelMemory* secondSection = [self sectionModelForSectionIndex:otherIndexPath.section];
		id modelFromSecondSection = [secondSection modelForRow:otherIndexPath.row];
		
		[secondSection removeModelAtIndex:otherIndexPath.row];
		[secondSection insertModel:modelFromFirstSection atIndex:otherIndexPath.row];
		
		[firstSection removeModelAtIndex:indexPath.row];
		[firstSection insertModel:modelFromSecondSection atIndex:indexPath.row];
	}
}


- (RAVTableControllerSectionModelMemory *)sectionModelForSectionIndex:(NSInteger)index
{
	RAVTableControllerSectionModelMemory * sectionModel = [self.sectionModels objectAtIndex:(NSUInteger)index];
	return sectionModel;
}


- (NSIndexPath*)indexPathForCellModelPassingTest:(BOOL (^)(id obj, NSIndexPath* modelIndexPath, BOOL *userPredicateStop))predicate
{
	__block NSInteger modelIndexInSection = NSNotFound;
	NSInteger sectionIndex = [self.sectionModels indexOfObjectPassingTest:^BOOL(id obj, NSUInteger sectionIdx, BOOL *sectionsStop) {
		RAVTableControllerSectionModelMemory * sectionModel = obj;
		__block BOOL needsStop = NO;
		
		NSInteger neededModelIndex = [sectionModel.models indexOfObjectPassingTest:^BOOL(id cellModel, NSUInteger modelIdx, BOOL *stop) {
			BOOL needsStopByUser = NO;
			BOOL goodModel = predicate(cellModel, [NSIndexPath indexPathForRow:modelIdx inSection:sectionIdx], &needsStopByUser);
			if (needsStopByUser)
			{
				needsStop = YES;
				*stop = needsStop;
			}
			return goodModel;
		}];
		
		if (needsStop)
		{
			*sectionsStop = YES;
		}
		
		BOOL neededSection = NO;
		if (neededModelIndex != NSNotFound)
		{
			neededSection = YES;
			modelIndexInSection = neededModelIndex;
		}
		return neededSection;
	}];
	
	NSIndexPath* indexPath = nil;
	if (sectionIndex != NSNotFound && modelIndexInSection != NSNotFound)
	{
		indexPath = [NSIndexPath indexPathForRow:modelIndexInSection inSection:sectionIndex];
	}
	
	return indexPath;
}

@end
