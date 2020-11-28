//
//  RAVCellPresenter.h
//  TableController
//
//  Created by Andrew Romanov on 23.04.14.
//  Copyright (c) 2014 Andrew Romanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RAVPresenterP.h"
#import "RAVCellActionsDelegateP.h"


@interface RAVCellPresenter : NSObject <RAVPresenterP, RAVCellActionsDelegateP>

@property (nonatomic, weak) UITableView* tableView;

@end


@interface RAVCellPresenter (Protected)

- (void)registerCells;
- (UITableViewCell*)cellForModel:(id)model;
- (UITableViewCell*)cellForModel:(id)model atIndexPath:(NSIndexPath*)indexPath;

@end

