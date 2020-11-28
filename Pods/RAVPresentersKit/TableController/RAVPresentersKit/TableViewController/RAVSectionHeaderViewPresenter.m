//
//  RAVSectionHeaderViewPresenter.m
//  TableController
//
//  Created by Andrew Romanov on 23.04.14.
//  Copyright (c) 2014 Andrew Romanov. All rights reserved.
//

#import "RAVSectionHeaderViewPresenter.h"

@implementation RAVSectionHeaderViewPresenter

@synthesize tableView = _tableView;

- (BOOL)canPresent:(id)model
{
	return NO;
}

@end
