//
//  RAVUPCallbacksStore.m
//  RAVPresentersKit
//
//  Created by Andrew Romanov on 17/03/16.
//  Copyright © 2016 BL. All rights reserved.
//

#import "RAVUPCallbacksStore.h"
#import "RAVUPBlockBinding.h"
#import "NSArray+RAVSupport.h"


@interface RAVUPCallbacksStore ()

@property (nonatomic, strong) NSMutableArray<RAVUPBlockBinding*> * callbackslist;

@end


@implementation RAVUPCallbacksStore

- (instancetype)init
{
	if (self = [super init])
	{
		_callbackslist = [[NSMutableArray alloc] initWithCapacity:3];
	}
	
	return self;
}


- (void)registerCallback:(RAVManyModelCellsPresenterSelectionCallback)callback forModelClass:(Class)modelClass
{
	RAVUPBlockBinding* blockBinding = [RAVUPBlockBinding blockBindingWithBlock:(id)callback modelClass:modelClass];
	[_callbackslist addObject:blockBinding];
}


- (RAVManyModelCellsPresenterSelectionCallback)getCallbackForModelClass:(Class)modelClass
{
	RAVUPBlockBinding* binding = [self.callbackslist rav_findObjectPassingTest:^BOOL(RAVUPBlockBinding* obj, NSUInteger idx, BOOL *stop) {
		BOOL needed = (obj.modelClass == modelClass);
		return needed;
	}];
	RAVManyModelCellsPresenterSelectionCallback callback = (id)binding.block;
	return callback;
}

@end
