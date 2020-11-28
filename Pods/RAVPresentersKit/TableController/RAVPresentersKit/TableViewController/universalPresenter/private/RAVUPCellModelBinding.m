//
//  RAVUPCellModelBinding.m
//  RAVPresentersKit
//
//  Created by Andrew Romanov on 11/03/16.
//  Copyright © 2016 BL. All rights reserved.
//

#import "RAVUPCellModelBinding.h"


@implementation RAVUPCellModelBinding

+ (instancetype)cellModelBindingWithCellClass:(Class)cellClass withCellId:(NSString*)cellId forModelClass:(Class)modelClass
{
	RAVUPCellModelBinding* binding = [[RAVUPCellModelBinding alloc] init];
	binding.cellClass = cellClass;
	binding.cellId = cellId;
	binding.modelClass = modelClass;
	
	return binding;
}


+ (instancetype)cellModelBindingWithCellNib:(UINib*)cellNib withCellId:(NSString*)cellId forModelClass:(Class)modelClass
{
	RAVUPCellModelBinding* binding = [[RAVUPCellModelBinding alloc] init];
	binding.cellNib = cellNib;
	binding.cellId = cellId;
	binding.modelClass = modelClass;
	
	return binding;
}

@end
