//
//  RAVUPCallbacksStore.h
//  RAVPresentersKit
//
//  Created by Andrew Romanov on 17/03/16.
//  Copyright © 2016 BL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RAVManyModelCellsPresenter.h"


@interface RAVUPCallbacksStore : NSObject

- (void)registerCallback:(RAVManyModelCellsPresenterSelectionCallback)callback forModelClass:(Class)modelClass;
- (RAVManyModelCellsPresenterSelectionCallback)getCallbackForModelClass:(Class)modelClass;

@end
