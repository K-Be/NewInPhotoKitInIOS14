//
//  RAVTableControllerSectionModelMemory.h
//  TableController
//
//  Created by Andrew Romanov on 23.04.14.
//  Copyright (c) 2014 Andrew Romanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RAVTableControllerSectionModelP.h"


@interface RAVTableControllerSectionModelMemory : NSObject <NSCopying, RAVTableControllerSectionModelP>

@property (nonatomic, strong) id headerViewModel;
@property (nonatomic, strong) id footerViewModel;
@property (nonatomic, strong, readonly) NSMutableArray* models;//some objects for draw

- (NSInteger)numberObjects;
- (id)modelForRow:(NSInteger)rowIndex;

- (void)removeModelAtIndex:(NSInteger)index;
- (void)insertModel:(id)model atIndex:(NSInteger)index;
- (void)exchangeModelAtIndex:(NSInteger)firstModelIndex withModelatIndex:(NSInteger)secondModelIndex;

@end
