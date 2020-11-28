//
//  RAVTableControllerSectionModelMemory+RAVAppCategory.m
//  RAVPresentersKit
//
//  Created by Andrew Romanov on 01.07.14.
//  Copyright (c) 2014 Andrew Romanov. All rights reserved.
//

#import "RAVTableControllerSectionModelMemory+RAVAppCategory.h"

@implementation RAVTableControllerSectionModelMemory (RAVAppCategory)

+ (instancetype)rav_sectionModelWithOneCellModel:(id)cellModel
{
	RAVTableControllerSectionModelMemory* sectionModel = [[RAVTableControllerSectionModelMemory alloc] init];
	if (cellModel)
	{
		[sectionModel.models addObject:cellModel];
	}
	
	return sectionModel;
}


+ (instancetype)rav_sectionModelWithCellsModels:(NSArray*)cellsModels
{
	RAVTableControllerSectionModelMemory* sectionModel = [[RAVTableControllerSectionModelMemory alloc] init];
	if (cellsModels)
	{
		[sectionModel.models addObjectsFromArray:cellsModels];
	}
	
	return sectionModel;
}

@end
