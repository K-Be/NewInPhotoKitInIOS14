//
//  RAVUPBlockBinding.h
//  RAVPresentersKit
//
//  Created by Andrew Romanov on 17/03/16.
//  Copyright © 2016 BL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RAVUPBlockBinding : NSObject

@property (nonatomic, copy) dispatch_block_t block;
@property (nonatomic, strong) Class modelClass;

+ (instancetype)blockBindingWithBlock:(dispatch_block_t)block modelClass:(Class)modelClass;

@end
