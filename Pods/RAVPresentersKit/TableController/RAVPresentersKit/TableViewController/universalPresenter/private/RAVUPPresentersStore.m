//
//  RAVUPPresentersStore.m
//  RAVPresentersKit
//
//  Created by Andrew Romanov on 11/03/16.
//  Copyright © 2016 BL. All rights reserved.
//

#import "RAVUPPresentersStore.h"
#import "NSArray+RAVSupport.h"


@interface RAVUPPresentersStore ()

@property (nonatomic, strong) NSMutableArray<RAVSingleModelCellPresenter *>* presenters;

@end


@implementation RAVUPPresentersStore

- (instancetype)init
{
	if (self = [super init])
	{
		_presenters = [[NSMutableArray alloc] init];
	}
	
	return self;
}


- (void)registerPresenter:(RAVSingleModelCellPresenter *)presenter
{
	[_presenters addObject:presenter];
}


- (RAVSingleModelCellPresenter *)getPresenterForModelClass:(Class)modelClass
{
	RAVSingleModelCellPresenter * presenter = [_presenters rav_findObjectPassingTest:^BOOL(RAVSingleModelCellPresenter * obj, NSUInteger idx, BOOL *stop) {
		BOOL neededPresenter = [obj canPresentModelWithClass:modelClass];
		return neededPresenter;
	}];
	
	return presenter;
}


- (void)enumeratePresenters:(void(^)(RAVSingleModelCellPresenter * presenter))block
{
	NSParameterAssert(block != nil);
	[self.presenters enumerateObjectsUsingBlock:^(RAVSingleModelCellPresenter * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		block(obj);
	}];
}

@end
