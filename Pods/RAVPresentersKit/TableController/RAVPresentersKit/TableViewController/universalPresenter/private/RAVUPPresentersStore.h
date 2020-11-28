//
//  RAVUPPresentersStore.h
//  RAVPresentersKit
//
//  Created by Andrew Romanov on 11/03/16.
//  Copyright © 2016 BL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RAVPresenterP.h"
#import "RAVSingleModelCellPresenter.h"


@interface RAVUPPresentersStore : NSObject

- (void)registerPresenter:(RAVSingleModelCellPresenter *)presenter;
- (RAVSingleModelCellPresenter *)getPresenterForModelClass:(Class)modelClass;
- (void)enumeratePresenters:(void(^)(RAVSingleModelCellPresenter * presenter))block;

@end
