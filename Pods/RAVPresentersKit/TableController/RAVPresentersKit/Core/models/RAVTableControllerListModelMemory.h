//
//  RAVTableControllerListModelMemory.h
//  TableController
//
//  Created by Andrew Romanov on 23.04.14.
//  Copyright (c) 2014 Andrew Romanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RAVTableControllerSectionModelMemory.h"
#import "RAVTableControllerListModelP.h"


@interface RAVTableControllerListModelMemory : NSObject <RAVTableControllerListModelP>

@property (nonatomic, strong, readonly) NSMutableArray* sectionModels; //list of RAVTableControllerSectionModelMemory;

- (NSInteger)countSections;
- (id<RAVTableControllerSectionModelP>)getSectionModelForSection:(NSInteger)section;

- (id)getModelForIndexPath:(NSIndexPath*)indexPath;

- (void)moveModelAtIndexPath:(NSIndexPath*)indexPath toIndexPath:(NSIndexPath*)destinationIndexPath;
- (id)removeModelAtIndexPath:(NSIndexPath*)indexPath;//return removed model
- (void)removeModelsAtIndexPaths:(NSArray*)indexPaths;
- (void)insertCellModel:(id)model toIndexPath:(NSIndexPath*)indexPath;
- (void)exchangeModelAtIndexPath:(NSIndexPath*)indexPath withModelAtIndexPath:(NSIndexPath*)otherIndexPath;

- (RAVTableControllerSectionModelMemory *)sectionModelForSectionIndex:(NSInteger)index;

- (NSIndexPath*)indexPathForCellModelPassingTest:(BOOL (^)(id obj, NSIndexPath* modelIndexPath, BOOL *stop))predicate;

@end
