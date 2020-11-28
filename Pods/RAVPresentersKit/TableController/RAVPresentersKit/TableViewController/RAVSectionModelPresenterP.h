//
//  RAVSectionViewDelegateP.h
//  TableController
//
//  Created by Andrew Romanov on 23.04.14.
//  Copyright (c) 2014 Andrew Romanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class RAVTableController;
@protocol RAVSectionModelPresenterP <NSObject>

@property (nonatomic, weak) UITableView* tableView;

@optional
- (CGFloat)ravTableController:(RAVTableController*)sender sectionViewHeightForModel:(id)sectionViewModel;
- (UIView*)ravTableController:(RAVTableController*)sender sectionViewForModel:(id)sectionViewModel;

@end
