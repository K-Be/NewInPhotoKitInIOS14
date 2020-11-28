//
//  RAVSectionIndexesDelegateP.h
//  TableController
//
//  Created by Andrew Romanov on 23.04.14.
//  Copyright (c) 2014 Andrew Romanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RAVTableController;
@protocol RAVSectionIndexesDelegateP <NSObject>

@optional
- (NSArray*)ravTableControllerSectionIndexTitles:(RAVTableController*)sender;
- (NSInteger)ravTableController:(RAVTableController *)sender sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index;

@end
