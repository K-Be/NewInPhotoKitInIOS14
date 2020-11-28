//
//  RAVTableControllerSectionModelP.h
//  TableController
//
//  Created by Andrew Romanov on 20.05.14.
//  Copyright (c) 2014 Andrew Romanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RAVTableControllerSectionModelP <NSObject>

@property (nonatomic, strong) id headerViewModel;
@property (nonatomic, strong) id footerViewModel;

- (NSInteger)numberObjects;
- (id)modelForRow:(NSInteger)rowIndex;

@end
