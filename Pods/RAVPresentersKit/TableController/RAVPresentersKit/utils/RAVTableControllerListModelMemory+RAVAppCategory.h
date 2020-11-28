//
//  RAVTableControllerListModelMemory+RAVAppCategory.h
//  RAVPresentersKit
//
//  Created by Andrew Romanov on 01.07.14.
//  Copyright (c) 2014 Andrew Romanov. All rights reserved.
//

#import "RAVTableControllerListModelMemory.h"

@interface RAVTableControllerListModelMemory (RAVAppCategory)

+ (instancetype)rav_tableModelWithCellModel:(id)model;
+ (instancetype)rav_tableModelWithSectionCellsModels:(NSArray*)cellsModels;
+ (instancetype)rav_tableModelWithSectionModel:(RAVTableControllerSectionModelMemory*)oneSectionModel;
+ (instancetype)rav_tableModelWithSections:(NSArray*)sectionsModels;

@end
