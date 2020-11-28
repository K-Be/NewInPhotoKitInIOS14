//
//  RAVUPDelegatesStore.m
//  RAVPresentersKit
//
//  Created by Andrew Romanov on 11/03/16.
//  Copyright © 2016 BL. All rights reserved.
//

#import "RAVUPDelegatesStore.h"
#import "_RAVDelegatesPresenter.h"
#import "NSArray+RAVSupport.h"


@interface RAVUPDelegatesStore ()

@property (nonatomic, strong) NSMutableArray<_RAVDelegatesPresenter*>* delegates;

@end


@implementation RAVUPDelegatesStore

- (instancetype)init
{
	if (self = [super init])
	{
		_delegates = [[NSMutableArray alloc] init];
	}
	
	return self;
}


- (void)registerDelegate:(id<RAVManyModelCellsPresenterDelegate>)delegate forModelClass:(Class)modelClass
{
	_RAVDelegatesPresenter* delegateContainer = [[_RAVDelegatesPresenter alloc] init];
	delegateContainer.delegate = delegate;
	delegateContainer.modelClass = modelClass;
	
	[_delegates addObject:delegateContainer];
}


- (id<RAVManyModelCellsPresenterDelegate>)getDelegateForModelClass:(Class)modelClass
{
	id<RAVManyModelCellsPresenterDelegate> delegate = [_delegates rav_findObjectPassingTest:^BOOL(_RAVDelegatesPresenter* obj, NSUInteger idx, BOOL *stop) {
		BOOL neededDelegate = (obj.modelClass == modelClass);
		return neededDelegate;
	}].delegate;
	
	return delegate;
}

@end
