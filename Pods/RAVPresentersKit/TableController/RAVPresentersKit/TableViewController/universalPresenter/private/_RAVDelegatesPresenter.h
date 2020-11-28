//
//  _RAVDelegatesPresenter.h
//  RAVPresentersKit
//
//  Created by Andrew Romanov on 11/03/16.
//  Copyright © 2016 BL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RAVPresenterP.h"


@protocol RAVManyModelCellsPresenterDelegate;
@interface _RAVDelegatesPresenter : NSObject

@property (nonatomic, weak) id<RAVManyModelCellsPresenterDelegate> delegate;
@property (nonatomic, strong) Class modelClass;

@end
