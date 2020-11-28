//
//  RAVSectionFooterViewPresenter.m
//  TableController
//
//  Created by Andrew Romanov on 23.04.14.
//  Copyright (c) 2014 Andrew Romanov. All rights reserved.
//

#import "RAVSectionHeaderFooterViewPresenter.h"

@implementation RAVSectionHeaderFooterViewPresenter

@synthesize tableView = _tableView;

- (void)setTableView:(UITableView *)tableView
{
	_tableView = tableView;
	[self registerView];
}


- (BOOL)canPresent:(id)model
{
	return NO;
}

@end


#pragma mark 
@implementation RAVSectionHeaderFooterViewPresenter (Override)

- (void)registerView
{
}

@end


