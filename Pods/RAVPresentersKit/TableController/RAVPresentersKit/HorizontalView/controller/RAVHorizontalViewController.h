//
//  RAVHorizontalViewController.h
//  RAVPresentersKit
//
//  Created by Andrew Romanov on 28.10.14.
//  Copyright (c) 2014 Andrew Romanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RAVHorizontalViewPresenter.h"


@interface RAVHorizontalViewController : NSObject <RAVHorizontalViewDataSource, RAVHorizontalViewDelegate>

@property (nonatomic, strong) RAVHorizontalView* horizontalView;
@property (nonatomic, strong) NSArray* models;

- (void)registerPresenter:(RAVHorizontalViewPresenter*)presenter;

- (void)scrollToModel:(id)model scrollPosition:(RAVHorizontalViewScrollPosition)scrollPosition animated:(BOOL)animated;
- (void)scrollToVisibleModel:(id)model scrollPosition:(RAVHorizontalViewScrollPosition)scrollPosition animated:(BOOL)animated;

@end
