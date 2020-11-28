//
//  RAVCellPresenter.m
//  TableController
//
//  Created by Andrew Romanov on 23.04.14.
//  Copyright (c) 2014 Andrew Romanov. All rights reserved.
//

#import "RAVCellPresenter.h"

@implementation RAVCellPresenter

@synthesize tableView = _tableView;

- (void)setTableView:(UITableView *)tableView
{
	_tableView = tableView;
	
	if (_tableView != nil)
	{
		[self registerCells];
	}
}


- (BOOL)canPresent:(id)model
{
	return NO;
}


- (CGFloat)ravTableController:(RAVTableController*)sender rowHeightForModel:(id)model
{
	return [self.tableView rowHeight];
}

@end


#pragma mark -
@implementation RAVCellPresenter (Protected)

- (void)registerCells
{
	
}


- (UITableViewCell*)cellForModel:(id)model
{
	return nil;
}


- (UITableViewCell*)cellForModel:(id)model atIndexPath:(NSIndexPath*)indexPath
{
	return  nil;
}

@end
