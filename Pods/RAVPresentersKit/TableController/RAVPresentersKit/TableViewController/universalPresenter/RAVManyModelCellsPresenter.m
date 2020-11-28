//
//  RAVManyModelCellsPresenter.m
//  RAVPresentersKit
//
//  Created by Andrew Romanov on 11/03/16.
//  Copyright © 2016 BL. All rights reserved.
//

#import "RAVManyModelCellsPresenter.h"
#import "RAVUPDelegatesStore.h"
#import "RAVUPPresentersStore.h"
#import "RAVUPCellModelBinding.h"
#import "RAVSingleModelCellPresenter.h"
#import "RAVUPCallbacksStore.h"


@interface RAVManyModelCellsPresenter ()

@property (nonatomic, weak) id<RAVManyModelCellsPresenterDelegate> rav_universalDelegate;
@property (nonatomic, strong) RAVUPDelegatesStore* rav_delegatesStore;
@property (nonatomic, strong) RAVUPCallbacksStore* rav_selectionCallbacksStore;

@property (nonatomic, strong) RAVUPPresentersStore* rav_presentersStore;

@property (nonatomic, strong) NSMutableArray<RAVUPCellModelBinding*>* rav_cellsBinding;

@end


@interface RAVManyModelCellsPresenter (Private)

- (void)rav_registerPresenterForBinding:(RAVUPCellModelBinding*)binding;
- (RAVSingleModelCellPresenter *)rav_createPresenterForBinding:(RAVUPCellModelBinding*)binding;

@end


@implementation RAVManyModelCellsPresenter

- (instancetype)init
{
	if (self = [super init])
	{
		_cellHeight = 40.0;
		_rav_delegatesStore = [[RAVUPDelegatesStore alloc] init];
		_rav_presentersStore = [[RAVUPPresentersStore alloc] init];
		_rav_selectionCallbacksStore = [[RAVUPCallbacksStore alloc] init];
		_rav_cellsBinding = [[NSMutableArray alloc] init];
	}
	
	return self;
}


- (void)registerDelegate:(id<RAVManyModelCellsPresenterDelegate>)delegate forModelClass:(Class)modelClass
{
	[self.rav_delegatesStore registerDelegate:delegate forModelClass:modelClass];
}


- (void)setDelegateForAllModels:(id<RAVManyModelCellsPresenterDelegate>)delegate
{
	self.rav_universalDelegate = delegate;
}


- (void)registerSelectionCallback:(RAVManyModelCellsPresenterSelectionCallback)callback forModelClass:(Class)modelClass
{
	[self.rav_selectionCallbacksStore registerCallback:callback forModelClass:modelClass];
}


- (void)registerNib:(UINib*)nib withCellId:(NSString*)cellId forModelClass:(Class)modelClass
{
	RAVUPCellModelBinding* binding = [RAVUPCellModelBinding cellModelBindingWithCellNib:nib withCellId:cellId forModelClass:modelClass];
	[self.rav_cellsBinding addObject:binding];

	[self rav_registerPresenterForBinding:binding];
}


- (void)registerCellClass:(Class)cellClass withCellId:(NSString*)cellId forModelClass:(Class)modelClass
{
	RAVUPCellModelBinding* binding = [RAVUPCellModelBinding cellModelBindingWithCellClass:cellClass withCellId:cellId forModelClass:modelClass];
	[self.rav_cellsBinding addObject:binding];

	[self rav_registerPresenterForBinding:binding];
}


- (void)setTableView:(UITableView *)tableView
{
	[super setTableView:tableView];
	
	[self.rav_presentersStore enumeratePresenters:^(RAVSingleModelCellPresenter *presenter) {
		presenter.tableView = tableView;
	}];
}


- (void)registerCells
{
	[super registerCells];
	
	UITableView* tableView = self.tableView;
	[self.rav_presentersStore enumeratePresenters:^(RAVSingleModelCellPresenter *presenter) {
		presenter.tableView = tableView;
		[presenter registerCells];
	}];
}


- (UITableViewCell*)cellForModel:(id)model
{
	RAVSingleModelCellPresenter * modelPresenter = [self.rav_presentersStore getPresenterForModelClass:[model class]];
	NSParameterAssert(modelPresenter != nil);
	UITableViewCell* cell = [modelPresenter cellForModel:model];
	
	return cell;
}


- (CGFloat)ravTableController:(RAVTableController*)sender rowHeightForModel:(id)model
{
	CGFloat height = self.cellHeight;
	
	id<RAVManyModelCellsPresenterDelegate> delegate = [self.rav_delegatesStore getDelegateForModelClass:model];
	if ([delegate respondsToSelector:@selector(ravManyModelCellsPresenter:heightForModel:)])
	{
		height = [delegate ravManyModelCellsPresenter:self heightForModel:model];
	}
	else if ([self.rav_universalDelegate respondsToSelector:@selector(ravManyModelCellsPresenter:heightForModel:)])
	{
		height = [self.rav_universalDelegate ravManyModelCellsPresenter:self heightForModel:model];
	}

	return height;
}



- (void)ravTableController:(RAVTableController*)sender didSelectModel:(id)model needsDeselect:(inout BOOL*)needsDeselect animated:(inout BOOL*)animated
{
	*needsDeselect = YES;
	*animated = YES;
	
	id<RAVManyModelCellsPresenterDelegate> delegate = [self.rav_delegatesStore getDelegateForModelClass:[model class]];
	if (delegate)
	{
		[delegate ravManyModelCellsPresenter:self selectedModel:model];
	}
	
	RAVManyModelCellsPresenterSelectionCallback callback = [self.rav_selectionCallbacksStore getCallbackForModelClass:[model class]];
	if (callback)
	{
		callback(self, model);
	}
	
	if (self.rav_universalDelegate)
	{
		[self.rav_universalDelegate ravManyModelCellsPresenter:self selectedModel:model];
	}
}

@end


#pragma mark -
@implementation RAVManyModelCellsPresenter (Private)

- (void)rav_registerPresenterForBinding:(RAVUPCellModelBinding*)binding
{
	RAVSingleModelCellPresenter * modelPresenter = [self rav_createPresenterForBinding:binding];
	[self.rav_presentersStore registerPresenter:modelPresenter];
}


- (RAVSingleModelCellPresenter *)rav_createPresenterForBinding:(RAVUPCellModelBinding*)binding
{
	RAVSingleModelCellPresenter * presenter = [[RAVSingleModelCellPresenter alloc] init];
	if (binding.cellClass)
	{
		[presenter setCellClass:binding.cellClass withCellId:binding.cellId forModelClass:binding.modelClass];
	}
	else if (binding.cellNib)
	{
		[presenter setCellNib:binding.cellNib withCellId:binding.cellId forModelClass:binding.modelClass];
	}
	else
	{
		NSParameterAssert(binding.cellNib != nil && binding.cellClass != nil);
	}
	
	return presenter;
}

@end
