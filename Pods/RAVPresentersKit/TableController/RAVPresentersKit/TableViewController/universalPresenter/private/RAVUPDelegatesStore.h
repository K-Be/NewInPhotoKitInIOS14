//
//  RAVUPDelegatesStore.h
//  RAVPresentersKit
//
//  Created by Andrew Romanov on 11/03/16.
//  Copyright © 2016 BL. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol RAVManyModelCellsPresenterDelegate;
@interface RAVUPDelegatesStore : NSObject

- (void)registerDelegate:(id<RAVManyModelCellsPresenterDelegate>)delegate forModelClass:(Class)modelClass;
- (id<RAVManyModelCellsPresenterDelegate>)getDelegateForModelClass:(Class)modelClass;

@end
