//
//  RAVSingleModelCellPresenter.m
//  RAVPresentersKit
//
//  Created by Andrew Romanov on 11/03/16.
//  Copyright © 2016 BL. All rights reserved.
//

#import "RAVSingleModelCellPresenter.h"


@interface RAVSingleModelCellPresenter ()

@property (nonatomic, strong) Class cellClass;
@property (nonatomic, strong) UINib* cellNib;
@property (nonatomic, strong) NSString* cellId;

@property (nonatomic, strong) Class modelClass;

@end


@implementation RAVSingleModelCellPresenter

- (instancetype)init
{
	if (self = [super init])
	{
		_rowHeight = 40.0;
	}
	
	return self;
}


- (void)setCellNib:(UINib*)cellNib withCellId:(NSString*)cellId forModelClass:(Class)modelClass
{
	_cellClass = nil;
	_cellNib = cellNib;
	_cellId = cellId;
	_modelClass = modelClass;
}


- (void)setCellClass:(Class)cellClass withCellId:(NSString*)cellId forModelClass:(Class)modelClass
{
	_cellClass = cellClass;
	_cellNib = nil;
	_cellId = cellId;
	_modelClass = modelClass;
}


- (BOOL)canPresentModelWithClass:(Class)modelClass
{
	BOOL can = (modelClass == self.modelClass);
	return can;
}


- (void)registerCells
{
	[super registerCells];
	
	if (self.cellClass)
	{
		[self.tableView registerClass:self.cellClass forCellReuseIdentifier:self.cellId];
	}
	else if (self.cellNib)
	{
		[self.tableView registerNib:self.cellNib forCellReuseIdentifier:self.cellId];
	}
}


- (BOOL)canPresent:(id)model
{
	BOOL can = [self canPresentModelWithClass:[model class]];
	return can;
}


- (UITableViewCell*)cellForModel:(id)model
{
	UITableViewCell<RAVUniversalDataViewP>* cell = [self.tableView dequeueReusableCellWithIdentifier:self.cellId];
#ifdef DEBUG
	NSParameterAssert([cell conformsToProtocol:@protocol(RAVUniversalDataViewP)]);
#endif
	cell.model = model;
	return cell;
}


- (UITableViewCell*)cellForModel:(id)model atIndexPath:(NSIndexPath*)indexPath
{
	UITableViewCell<RAVUniversalDataViewP>* cell = [self.tableView dequeueReusableCellWithIdentifier:self.cellId forIndexPath:indexPath];
#ifdef DEBUG
	NSParameterAssert([cell conformsToProtocol:@protocol(RAVUniversalDataViewP)]);
#endif
	cell.model = model;
	return cell;

}


- (CGFloat)ravTableController:(RAVTableController*)sender rowHeightForModel:(id)model
{
	return self.rowHeight;
}


- (void)ravTableController:(RAVTableController *)sender didSelectModel:(id)model needsDeselect:(inout BOOL *)needsDeselect animated:(inout BOOL *)animated
{
	*needsDeselect = YES;
	*animated = YES;

	[self.delegate ravSingleModelCellPresenter:self selectedModel:model];
	if (_selectionCallback)
	{
		_selectionCallback(self, model);
	}
}


@end
