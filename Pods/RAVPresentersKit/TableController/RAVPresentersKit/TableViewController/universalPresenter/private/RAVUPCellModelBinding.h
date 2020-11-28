//
//  RAVUPCellModelBinding.h
//  RAVPresentersKit
//
//  Created by Andrew Romanov on 11/03/16.
//  Copyright © 2016 BL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RAVUniversalDataViewP.h"


@interface RAVUPCellModelBinding : NSObject

@property (nonatomic, strong) Class cellClass;
@property (nonatomic, strong) UINib* cellNib;

@property (nonatomic, strong) NSString* cellId;

@property (nonatomic, strong) Class modelClass;

+ (instancetype)cellModelBindingWithCellClass:(Class)cellClass withCellId:(NSString*)cellId forModelClass:(Class)modelClass;
+ (instancetype)cellModelBindingWithCellNib:(UINib*)cellNib withCellId:(NSString*)cellId forModelClass:(Class)modelClass;

@end
