//
//  RAVHorizontalView.h
//  RAVPresentersKit
//
//  Created by Andrew Romanov on 28.10.14.
//  Copyright (c) 2014 Andrew Romanov. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, RAVHorizontalViewScrollPosition) {
	RAVHorizontalViewScrollPositionNone                 = 0,
	
	// Likewise, the horizontal positions are mutually exclusive to each other.
	RAVHorizontalViewScrollPositionLeft                 = 1 << 3,
	RAVHorizontalViewScrollPositionCenteredHorizontally = 1 << 4,
	RAVHorizontalViewScrollPositionRight 					= 1 << 5
};


@protocol RAVHorizontalViewDataSource;
@protocol RAVHorizontalViewDelegate;
@interface RAVHorizontalView : UIView

@property (nonatomic, weak) id<RAVHorizontalViewDataSource> dataSource;
@property (nonatomic, weak) id<RAVHorizontalViewDelegate> delegate;
@property (nonatomic) CGFloat collumnsPadding;
@property (nonatomic) UIEdgeInsets contentInset;
@property (nonatomic) CGPoint contentOffset;
@property (nonatomic) BOOL showsHorizontalScrollIndicator;
@property (nonatomic) BOOL showsVerticalScrollIndicator;
@property (nonatomic) BOOL clipsToBounds;


- (void)registerNib:(UINib*)nib forCellReuseIdentifier:(NSString *)identifier;
- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier;

- (id)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forCollumnIndex:(NSUInteger)index;
- (void)reloadData;

- (NSIndexSet*)indexesForSelectedCollumns;
- (NSIndexSet*)indexesForVisibleCollumns;
- (UICollectionViewCell*)cellForCollumnAtIndex:(NSUInteger)collumnIndex;
- (void)selectCollumnAtIndex:(NSUInteger)collumnIndex animated:(BOOL)animated scrollPostion:(RAVHorizontalViewScrollPosition)position;
- (void)deselectCollumnAtIndex:(NSUInteger)collumnIndex animated:(BOOL)animated;

- (void)scrollToCollumnAtIndex:(NSUInteger)collumnIndex scrollPosition:(RAVHorizontalViewScrollPosition)position animated:(BOOL)animated;
- (void)scrollToVisibleCollumnAtIndex:(NSUInteger)collumnIndex scrollPosition:(RAVHorizontalViewScrollPosition)position animated:(BOOL)animated;

- (CGSize)contentSize;

@end


@protocol RAVHorizontalViewDataSource <NSObject>

- (NSUInteger)ravHorizontalViewCountCollumns:(RAVHorizontalView*)sender;
- (UICollectionViewCell*)ravHorizontalView:(RAVHorizontalView *)sender viewForCollumn:(NSUInteger)collumnIndex;

- (CGFloat)ravHorizontalView:(RAVHorizontalView *)sender widthForCollumn:(NSUInteger)collumnIndex;

@end


@protocol RAVHorizontalViewDelegate <NSObject>

- (void)ravHorizontalView:(RAVHorizontalView *)sender selectedCollumn:(NSUInteger)collumnIndex;

@end

