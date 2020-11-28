//
//  RAVUPBlockBinding.m
//  RAVPresentersKit
//
//  Created by Andrew Romanov on 17/03/16.
//  Copyright © 2016 BL. All rights reserved.
//

#import "RAVUPBlockBinding.h"

@implementation RAVUPBlockBinding

+ (instancetype)blockBindingWithBlock:(dispatch_block_t)block modelClass:(Class)modelClass
{
	RAVUPBlockBinding* binding = [[RAVUPBlockBinding alloc] init];
	binding.block = block;
	binding.modelClass = modelClass;
	
	return binding;
}

@end
