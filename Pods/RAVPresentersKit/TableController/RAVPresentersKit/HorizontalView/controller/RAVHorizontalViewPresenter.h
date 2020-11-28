//
//  RAVHorizontalViewPresenter.h
//  RAVPresentersKit
//
//  Created by Andrew Romanov on 28.10.14.
//  Copyright (c) 2014 Andrew Romanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RAVPresenterP.h"
#import "RAVHorizontalView.h"


@interface RAVHorizontalViewPresenter : NSObject <RAVPresenterP>

@property (nonatomic, weak) RAVHorizontalView* horizontalView;

- (BOOL)canPresent:(id)model;
- (UICollectionViewCell*)collectionCellForModel:(id)model atCollumn:(NSUInteger)collumn;
- (CGFloat)widthForModel:(id)model;
- (void)selectedModel:(id)model needsDeselect:(out BOOL*)needsDeselect animated:(out BOOL*)animated;

@end


@interface RAVHorizontalViewPresenter (Override)

- (void)_registerCells;

@end


