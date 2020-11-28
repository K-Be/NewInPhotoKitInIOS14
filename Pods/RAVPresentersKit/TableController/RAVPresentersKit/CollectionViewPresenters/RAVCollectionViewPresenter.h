//
//  RAVCollectionViewPresenter.h
//  RAVPresentersKit
//
//  Created by Andrew Romanov on 30.10.14.
//  Copyright (c) 2014 Andrew Romanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RAVPresenterP.h"


@interface RAVCollectionViewPresenter : NSObject <RAVPresenterP>

@property (nonatomic, weak) UICollectionView* collectionView;
@property (nonatomic, weak) UICollectionViewFlowLayout* layout;

- (UICollectionViewCell*)cellForModel:(id)model atIndexPath:(NSIndexPath*)indexPath;
- (void)selectedModel:(id)model deselect:(out BOOL*)deselect animated:(out BOOL*)animated;
- (CGSize)sizeForModel:(id)model forIndexPath:(NSIndexPath*)indexPath;

@end


@interface RAVCollectionViewPresenter (Override)

- (void)_registerViews;

@end
