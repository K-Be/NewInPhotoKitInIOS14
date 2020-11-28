//
//  RAVHorizontalViewController.m
//  RAVPresentersKit
//
//  Created by Andrew Romanov on 28.10.14.
//  Copyright (c) 2014 Andrew Romanov. All rights reserved.
//

#import "RAVHorizontalViewController.h"
#import "RAVPresentersStore.h"


@interface RAVHorizontalViewController ()

@property (nonatomic, strong) RAVPresentersStore* cellsPresenters;

@end


@interface RAVHorizontalViewController (Private)

- (id)_modelForIndex:(NSUInteger)index;

@end


@implementation RAVHorizontalViewController


- (id)init
{
	if (self = [super init])
	{
		_cellsPresenters = [[RAVPresentersStore alloc] init];
	}
	
	return self;
}


- (void)setHorizontalView:(RAVHorizontalView *)horizontalView
{
	_horizontalView = horizontalView;
	
	[self.cellsPresenters makeObjectsPerformSelector:@selector(setHorizontalView:) withObject:_horizontalView];
	
	_horizontalView.delegate = self;
	_horizontalView.dataSource = self;
	
	[_horizontalView reloadData];
}


- (void)setModels:(NSArray *)models
{
	_models = models;
	
	[self.horizontalView reloadData];
}


- (void)registerPresenter:(RAVHorizontalViewPresenter*)presenter
{
	[_cellsPresenters registerPresenter:presenter];
}


- (void)scrollToModel:(id)model scrollPosition:(RAVHorizontalViewScrollPosition)scrollPosition animated:(BOOL)animated
{
	NSInteger index = [self.models indexOfObjectIdenticalTo:model];
	if (index != NSNotFound)
	{
		[self.horizontalView scrollToCollumnAtIndex:index scrollPosition:scrollPosition animated:animated];
	}
	NSParameterAssert(index != NSNotFound);
}


- (void)scrollToVisibleModel:(id)model scrollPosition:(RAVHorizontalViewScrollPosition)scrollPosition animated:(BOOL)animated
{
	NSInteger index = [self.models indexOfObjectIdenticalTo:model];
	if (index != NSNotFound)
	{
		[self.horizontalView scrollToVisibleCollumnAtIndex:index scrollPosition:scrollPosition animated:animated];
	}
	NSParameterAssert(index != NSNotFound);
}


#pragma mark FAHorizontalViewDataSource
- (NSUInteger)ravHorizontalViewCountCollumns:(RAVHorizontalView*)sender
{
	return [self.models count];
}


- (UICollectionViewCell*)ravHorizontalView:(RAVHorizontalView *)sender viewForCollumn:(NSUInteger)collumnIndex
{
	id model = [self _modelForIndex:collumnIndex];
	RAVHorizontalViewPresenter* presenter = [self.cellsPresenters presenterForModel:model];
	UICollectionViewCell* cell = [presenter collectionCellForModel:model atCollumn:collumnIndex];
	
	return cell;
}


- (CGFloat)ravHorizontalView:(RAVHorizontalView *)sender widthForCollumn:(NSUInteger)collumnIndex
{
	id model = [self _modelForIndex:collumnIndex];
	RAVHorizontalViewPresenter* presenter = [self.cellsPresenters presenterForModel:model];
	CGFloat width = [presenter widthForModel:model];
	return width;
}


#pragma mark FAHorizontalViewDelegate
- (void)ravHorizontalView:(RAVHorizontalView *)sender selectedCollumn:(NSUInteger)collumnIndex
{
	id model = [self _modelForIndex:collumnIndex];
	RAVHorizontalViewPresenter* presenter = [self.cellsPresenters presenterForModel:model];
	
	BOOL needsDeselect = NO;
	BOOL animated = NO;
	[presenter selectedModel:model needsDeselect:&needsDeselect animated:&animated];
	if (needsDeselect)
	{
		[self.horizontalView deselectCollumnAtIndex:collumnIndex animated:animated];
	}
}


- (void)dealloc
{
	self.horizontalView.delegate = nil;
	self.horizontalView.dataSource = nil;
}

@end


#pragma mark -
@implementation RAVHorizontalViewController (Private)

- (id)_modelForIndex:(NSUInteger)index
{
	id model = [self.models objectAtIndex:index];
	return model;
}

@end
