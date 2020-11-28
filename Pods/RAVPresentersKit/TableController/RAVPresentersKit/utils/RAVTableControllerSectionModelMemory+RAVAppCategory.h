//
//  RAVTableControllerSectionModelMemory+RAVAppCategory.h
//  RAVPresentersKit
//
//  Created by Andrew Romanov on 01.07.14.
//  Copyright (c) 2014 Andrew Romanov. All rights reserved.
//

#import "RAVTableControllerSectionModelMemory.h"

@interface RAVTableControllerSectionModelMemory (RAVAppCategory)

+ (instancetype)rav_sectionModelWithOneCellModel:(id)cellModel;
+ (instancetype)rav_sectionModelWithCellsModels:(NSArray*)cellsModels;

@end
