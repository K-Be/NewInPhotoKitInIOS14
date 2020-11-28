//
//  RAVPresentersStore.h
//  TableController
//
//  Created by Andrew Romanov on 02.07.14.
//  Copyright (c) 2014 Andrew Romanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RAVPresenterP.h"


@interface RAVPresentersStore : NSObject

- (void)registerPresenter:(id<RAVPresenterP>)presenter;
- (id<RAVPresenterP>)presenterForModel:(id)model;

- (void)makeObjectsPerformSelector:(SEL)selector withObject:(id)object;
- (void)makeObjectsPerformSelector:(SEL)selector;

@end
