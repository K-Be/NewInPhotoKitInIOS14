//
//  RAVTableControllerListModelP.h
//  TableController
//
//  Created by Andrew Romanov on 20.05.14.
//  Copyright (c) 2014 Andrew Romanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RAVTableControllerSectionModelP.h"


@protocol RAVTableControllerListModelP <NSObject>

- (NSInteger)countSections;
- (id<RAVTableControllerSectionModelP>)getSectionModelForSection:(NSInteger)section;

- (id)getModelForIndexPath:(NSIndexPath*)indexPath;

@end
