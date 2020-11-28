//
//  RAVCollectionViewController.m
//  RAVPresentersKit
//
//  Created by Andrew Romanov on 30.10.14.
//  Copyright (c) 2014 Andrew Romanov. All rights reserved.
//

#import "RAVCollectionViewController.h"
#import "RAVPresentersStore.h"


@interface RAVCollectionViewController ()

@property (nonatomic, strong) RAVPresentersStore* rav_presenters;

@end


@interface RAVCollectionViewController (Private)

- (id)rav_modelForIndexPath:(NSIndexPath*)indexPath;

@end


@implementation RAVCollectionViewController


- (id)init
{
	if (self = [super init])
	{
		_rav_presenters = [[RAVPresentersStore alloc] init];
	}
	
	return self;
}


- (void)setModel:(id<RAVTableControllerListModelP>)model
{
	_model = model;
	
	[_collectionView reloadData];
}


- (void)setCollectionView:(UICollectionView *)collectionView flowLayout:(UICollectionViewFlowLayout *)flowLayout
{
	if (_collectionView)
	{
		_collectionView.delegate = nil;
		_collectionView.dataSource = nil;
	}
	
	_collectionView = collectionView;
	_collectionView.delegate = self;
	_collectionView.dataSource = self;
	_flowLayout = flowLayout;
	
	[self.rav_presenters makeObjectsPerformSelector:@selector(setCollectionView:) withObject:_collectionView];
	[self.rav_presenters makeObjectsPerformSelector:@selector(setLayout:) withObject:_flowLayout];
	
	[_collectionView reloadData];
}


- (void)registerPresenter:(RAVCollectionViewPresenter*)presenter
{
	[self.rav_presenters registerPresenter:presenter];
}


#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return [_model countSections];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return [[_model getSectionModelForSection:section] numberObjects];
}


// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	id model = [self rav_modelForIndexPath:indexPath];
	RAVCollectionViewPresenter* presenter = [self.rav_presenters presenterForModel:model];
	UICollectionViewCell* cell = [presenter cellForModel:model atIndexPath:indexPath];
	
	return cell;
}


#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	BOOL deselect = NO;
	BOOL animated = NO;
	
	id model = [self rav_modelForIndexPath:indexPath];
	RAVCollectionViewPresenter* presenter = [self.rav_presenters presenterForModel:model];
	[presenter selectedModel:model deselect:&deselect animated:&animated];
	if (deselect)
	{
		[self.collectionView deselectItemAtIndexPath:indexPath animated:animated];
	}
}


#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	id model = [self rav_modelForIndexPath:indexPath];
	RAVCollectionViewPresenter* presenter = [self.rav_presenters presenterForModel:model];
	CGSize size = [presenter sizeForModel:model forIndexPath:indexPath];
	
	return size;
}


- (void)dealloc
{
	if (_collectionView)
	{
		_collectionView.delegate = nil;
		_collectionView.dataSource = nil;
	}
}

@end


#pragma mark -
@implementation RAVCollectionViewController (Private)

- (id)rav_modelForIndexPath:(NSIndexPath*)indexPath
{
	id model = [self.model getModelForIndexPath:indexPath];
	return model;
}

@end
