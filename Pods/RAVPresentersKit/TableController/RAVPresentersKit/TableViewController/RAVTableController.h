//
//  RAVTableController.h
//  TableController
//
//  Created by Andrew Romanov on 23.04.14.
//  Copyright (c) 2014 Andrew Romanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RAVCellPresenter.h"
#import "RAVSectionModelPresenterP.h"
#import "RAVScrollViewDelegateP.h"
#import "RAVEditDelegateP.h"
#import "RAVSectionIndexesDelegateP.h"
#import "RAVTableControllerListModelP.h"


typedef RAVCellPresenter RavCellPresenterType;
typedef NSObject<RAVPresenterP, RAVSectionModelPresenterP> RAVSectionFooterViewPresenterType;
typedef NSObject<RAVPresenterP, RAVSectionModelPresenterP> RAVSectionHeaderViewPresenterType;


@interface RAVTableController : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) id<RAVTableControllerListModelP> model;

@property (nonatomic, weak) id<RAVScrollViewDelegateP> scrollViewDelegate;
@property (nonatomic, weak) id<RAVEditDelegateP> editDelegate;
@property (nonatomic, weak) id<RAVSectionIndexesDelegateP> sectionIndexesDelegate;

- (void)reloadData;

- (void)registerCellPresenter:(RavCellPresenterType*)cellPresenter;
- (void)registerSectionHeaderPresenter:(RAVSectionHeaderViewPresenterType*)sectionHeaderPresenter;
- (void)registerSectionFooterPresenter:(RAVSectionFooterViewPresenterType*)sectionFooterPresenter;

- (void)setModelInAnimationBlock:(id<RAVTableControllerListModelP>)model;

@end
