//
//  RAVTableControllerListModelMemory+RAVAppCategory.m
//  RAVPresentersKit
//
//  Created by Andrew Romanov on 01.07.14.
//  Copyright (c) 2014 Andrew Romanov. All rights reserved.
//

#import "RAVTableControllerListModelMemory+RAVAppCategory.h"
#import "RAVTableControllerSectionModelMemory+RAVAppCategory.h"


@implementation RAVTableControllerListModelMemory (RAVAppCategory)

+ (instancetype)rav_tableModelWithCellModel:(id)model
{
	RAVTableControllerSectionModelMemory* sectionModel = [RAVTableControllerSectionModelMemory rav_sectionModelWithOneCellModel:model];
	RAVTableControllerListModelMemory* listModel = [self rav_tableModelWithSectionModel:sectionModel];

	return listModel;
}


+ (instancetype)rav_tableModelWithSectionCellsModels:(NSArray*)cellsModels
{
	RAVTableControllerSectionModelMemory* sectionModel = [RAVTableControllerSectionModelMemory rav_sectionModelWithCellsModels:cellsModels];
	RAVTableControllerListModelMemory* listModel = [RAVTableControllerListModelMemory rav_tableModelWithSectionModel:sectionModel];
	return listModel;
}


+ (instancetype)rav_tableModelWithSectionModel:(RAVTableControllerSectionModelMemory*)oneSectionModel
{
	RAVTableControllerListModelMemory* listModel = [[RAVTableControllerListModelMemory alloc] init];
	if (oneSectionModel)
	{
		NSAssert([oneSectionModel isKindOfClass:[RAVTableControllerSectionModelMemory class]], @"must be RAVTableControllerSectionModelMemory");
		[listModel.sectionModels addObject:oneSectionModel];
	}
	else
	{
		NSAssert(NO, @"section model must not be nil");
		[listModel.sectionModels addObject:[RAVTableControllerSectionModelMemory rav_sectionModelWithOneCellModel:nil]];
	}
	
	return listModel;
}


+ (instancetype)rav_tableModelWithSections:(NSArray*)sectionsModels
{
	RAVTableControllerListModelMemory* listModel = [[RAVTableControllerListModelMemory alloc] init];
	if (sectionsModels && [sectionsModels count] != 0)
	{
		NSAssert([[[NSSet setWithArray:sectionsModels] anyObject] isKindOfClass:[RAVTableControllerSectionModelMemory class]], @"objects must be RAVTableControllerSectionModelMemory");
		[listModel.sectionModels addObjectsFromArray:sectionsModels];
	}
	else
	{
		NSAssert(NO, @"sectionModels must not be nil");
		[listModel.sectionModels addObject:[RAVTableControllerSectionModelMemory rav_sectionModelWithOneCellModel:nil]];
	}
	
	return listModel;
}

@end
