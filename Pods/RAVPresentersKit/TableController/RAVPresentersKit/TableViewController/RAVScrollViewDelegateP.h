//
//  RAVScrollViewDelegateP.h
//  TableController
//
//  Created by Andrew Romanov on 23.04.14.
//  Copyright (c) 2014 Andrew Romanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RAVTableController;
@protocol RAVScrollViewDelegateP <NSObject>

@optional
- (void)ravTableControllerScrollViewDidScroll:(RAVTableController*)sender;
- (void)ravTableControllerScrollViewDidZoom:(RAVTableController*)sender;

- (void)ravTableControllerScrollViewWillBeginDragging:(RAVTableController*)sender;
- (void)ravTableControllerScrollViewWillEndDragging:(RAVTableController*)sender withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset;

- (void)ravTableControllerScrollViewDidEndDragging:(RAVTableController*)sender willDecelerate:(BOOL)decelerate;

- (void)ravTableControllerScrollViewWillBeginDecelerating:(RAVTableController*)sender;
- (void)ravTableControllerScrollViewDidEndDecelerating:(RAVTableController*)sender;

- (void)ravTableControllerScrollViewDidEndScrollingAnimation:(RAVTableController*)sender;

- (UIView *)ravTableControllerViewForZoomingInScrollView:(RAVTableController*)sender;
- (void)ravTableControllerScrollViewWillBeginZooming:(RAVTableController*)sender withView:(UIView *)view NS_AVAILABLE_IOS(3_2);
- (void)ravTableControllerScrollViewDidEndZooming:(RAVTableController*)sender withView:(UIView *)view atScale:(CGFloat)scale;

- (BOOL)ravTableControllerScrollViewShouldScrollToTop:(RAVTableController*)sender;
- (void)ravTableControllerScrollViewDidScrollToTop:(RAVTableController*)sender;

@end
