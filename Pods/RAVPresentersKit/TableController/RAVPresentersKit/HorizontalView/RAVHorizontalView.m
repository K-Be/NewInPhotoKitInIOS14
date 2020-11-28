//
//  RAVHorizontalView.m
//  RAVPresentersKit
//
//  Created by Andrew Romanov on 28.10.14.
//  Copyright (c) 2014 Andrew Romanov. All rights reserved.
//

#import "RAVHorizontalView.h"
#import "RAVCollectionViewFlowHorizontalLayout.h"
#import "RAVHorCollectionView.h"
//#import "TB_CGAdditions.h"


@interface RAVHorizontalView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView* rav_collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout* rav_flowLayout;

@end


@interface RAVHorizontalView (Private)

- (NSIndexPath*)rav_indexPathFromCollumnIndex:(NSUInteger)collumnIndex;
- (NSUInteger)rav_collumnIndexFromIndexPath:(NSIndexPath*)indexPath;
- (UICollectionViewScrollPosition)rav_collectionViewScrollPostionFromHorizontalViewScrollPosition:(RAVHorizontalViewScrollPosition)horScrollPosition;

@end


@implementation RAVHorizontalView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:aDecoder])
	{
		[self rav_commonInitialization];
	}
	
	return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])
	{
		[self rav_commonInitialization];
	}
	
	return self;
}


- (void)rav_commonInitialization
{
	self.rav_flowLayout = [[RAVCollectionViewFlowHorizontalLayout alloc] init];
	self.rav_flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
	
	self.rav_collectionView = [[RAVHorCollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.rav_flowLayout];
	self.rav_collectionView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
	self.rav_collectionView.backgroundColor = [UIColor clearColor];
	UIView* collectionViewBackground = [[UIView alloc] initWithFrame:CGRectZero];
	collectionViewBackground.backgroundColor = [UIColor clearColor];
	collectionViewBackground.userInteractionEnabled = NO;
	self.rav_collectionView.backgroundView = collectionViewBackground;
	
	self.rav_collectionView.delegate = self;
	self.rav_collectionView.dataSource = self;
	self.rav_collectionView.scrollsToTop = NO;
	self.rav_collectionView.showsHorizontalScrollIndicator = NO;
	self.rav_collectionView.showsVerticalScrollIndicator = NO;
	//self.rav_collectionView.panGestureRecognizer.delaysTouchesBegan = YES;
	self.rav_collectionView.delaysContentTouches = NO;
	
	[self addSubview:self.rav_collectionView];
	
	self.collumnsPadding = 0.0;
}


- (void)setContentOffset:(CGPoint)contentOffset
{
	if (self.rav_collectionView.contentSize.width > self.rav_collectionView.bounds.size.width)
	{
		self.rav_collectionView.contentOffset = contentOffset;
	}
}


- (CGPoint)contentOffset
{
	return self.rav_collectionView.contentOffset;
}


- (void)setShowsHorizontalScrollIndicator:(BOOL)showsHorizontalScrollIndicator
{
	self.rav_collectionView.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator;
}


- (BOOL)showsHorizontalScrollIndicator
{
	return self.rav_collectionView.showsHorizontalScrollIndicator;
}


- (void)setShowsVerticalScrollIndicator:(BOOL)showsVerticalScrollIndicator
{
	self.rav_collectionView.showsVerticalScrollIndicator = showsVerticalScrollIndicator;
}


- (BOOL)showsVerticalScrollIndicator
{
	return self.rav_collectionView.showsVerticalScrollIndicator;
}


- (void)setClipsToBounds:(BOOL)clipsToBounds
{
	self.rav_collectionView.clipsToBounds = clipsToBounds;
}


- (BOOL)clipsToBounds
{
	return self.rav_collectionView.clipsToBounds;
}


- (void)setCollumnsPadding:(CGFloat)collumnsPadding
{
	_collumnsPadding = collumnsPadding;
	
	self.rav_flowLayout.minimumInteritemSpacing = collumnsPadding;
}


- (void)registerNib:(UINib*)nib forCellReuseIdentifier:(NSString *)identifier
{
	[self.rav_collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
}


- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier
{
	[self.rav_collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}


- (void)setContentInset:(UIEdgeInsets)contentInset
{
	_contentInset = contentInset;
	
	self.rav_collectionView.contentInset = contentInset;
}


- (id)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forCollumnIndex:(NSUInteger)index
{
	id cell = [_rav_collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:[self rav_indexPathFromCollumnIndex:index]];
	return cell;
}


- (void)reloadData
{
	[self.rav_collectionView reloadData];
}


- (void)willMoveToWindow:(UIWindow *)newWindow
{
	[super willMoveToWindow:newWindow];
	
	if (newWindow && NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1)
	{
		[self.rav_collectionView reloadData];
	}
}


//cells
- (NSIndexSet*)indexesForSelectedCollumns
{
	NSArray* indexPaths = [self.rav_collectionView indexPathsForSelectedItems];
	NSMutableIndexSet* indexes = [[NSMutableIndexSet alloc] init];
	[indexPaths enumerateObjectsUsingBlock:^(NSIndexPath* indexPath, NSUInteger idx, BOOL *stop) {
		NSUInteger index = [self rav_collumnIndexFromIndexPath:indexPath];
		[indexes addIndex:index];
	}];
	
	return indexes;
}


- (NSIndexSet*)indexesForVisibleCollumns
{
	NSArray* indexPaths = [self.rav_collectionView indexPathsForVisibleItems];
	NSMutableIndexSet* indexes = [[NSMutableIndexSet alloc] init];
	[indexPaths enumerateObjectsUsingBlock:^(NSIndexPath* indexPath, NSUInteger idx, BOOL *stop) {
		NSUInteger index = [self rav_collumnIndexFromIndexPath:indexPath];
		[indexes addIndex:index];
	}];
	
	return indexes;
}


- (UICollectionViewCell*)cellForCollumnAtIndex:(NSUInteger)collumnIndex
{
	NSIndexPath* indexPath = [self rav_indexPathFromCollumnIndex:collumnIndex];
	UICollectionViewCell* cell = [self.rav_collectionView cellForItemAtIndexPath:indexPath];
	
	return cell;
}


- (void)selectCollumnAtIndex:(NSUInteger)collumnIndex animated:(BOOL)animated scrollPostion:(RAVHorizontalViewScrollPosition)position
{
	NSIndexPath* indexPath = [self rav_indexPathFromCollumnIndex:collumnIndex];
	UICollectionViewScrollPosition scrollPosition = [self rav_collectionViewScrollPostionFromHorizontalViewScrollPosition:position];
	[self.rav_collectionView selectItemAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
}


- (void)deselectCollumnAtIndex:(NSUInteger)collumnIndex animated:(BOOL)animated
{
	NSIndexPath* indexPath = [self rav_indexPathFromCollumnIndex:collumnIndex];
	[self.rav_collectionView deselectItemAtIndexPath:indexPath animated:animated];
}


- (void)scrollToCollumnAtIndex:(NSUInteger)collumnIndex scrollPosition:(RAVHorizontalViewScrollPosition)position animated:(BOOL)animated
{
	NSIndexPath* indexPath = [self rav_indexPathFromCollumnIndex:collumnIndex];
	UICollectionViewScrollPosition scrollPosition = [self rav_collectionViewScrollPostionFromHorizontalViewScrollPosition:position];
	[self.rav_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
}


- (void)scrollToVisibleCollumnAtIndex:(NSUInteger)collumnIndex scrollPosition:(RAVHorizontalViewScrollPosition)position animated:(BOOL)animated
{
	/*
	 Метод скролирует только если столбец частично или полность не виден, до "if" идёт вычисление видимой рамки.
	*/
	NSIndexPath* indexPath = [self rav_indexPathFromCollumnIndex:collumnIndex];
	UICollectionViewLayoutAttributes* collumnAttributes = [self.rav_collectionView layoutAttributesForItemAtIndexPath:indexPath];
	CGRect collumnRect = collumnAttributes.frame;
	CGRect intersect = CGRectIntersection(self.rav_collectionView.bounds, collumnRect);
	if (!CGSizeEqualToSize(intersect.size, collumnRect.size))
	{
		[self scrollToCollumnAtIndex:collumnIndex scrollPosition:position animated:animated];
	}
}


- (CGSize)contentSize
{
	return self.rav_collectionView.contentSize;
}


#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	NSInteger number = 0;
	if (self.dataSource)
	{
		number = [self.dataSource ravHorizontalViewCountCollumns:self];
	}
	
	return number;
}


// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewCell* cell = [self.dataSource ravHorizontalView:self viewForCollumn:[self rav_collumnIndexFromIndexPath:indexPath]];
	return cell;
}


#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	[self.delegate ravHorizontalView:self selectedCollumn:[self rav_collumnIndexFromIndexPath:indexPath]];
}


#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat width = [self.dataSource ravHorizontalView:self widthForCollumn:[self rav_collumnIndexFromIndexPath:indexPath]];
	CGSize size = CGSizeMake(width, self.bounds.size.height - self.rav_collectionView.contentInset.top - self.rav_collectionView.contentInset.bottom);
	return size;
}


- (void)dealloc
{
	_rav_collectionView.delegate = nil;
	_rav_collectionView.dataSource = nil;
}

@end


#pragma mark -
@implementation RAVHorizontalView (Private)

- (NSIndexPath*)rav_indexPathFromCollumnIndex:(NSUInteger)collumnIndex
{
	NSIndexPath* indexPath = [NSIndexPath indexPathForItem:collumnIndex inSection:0];
	return indexPath;
}


- (NSUInteger)rav_collumnIndexFromIndexPath:(NSIndexPath*)indexPath
{
	return indexPath.item;
}


- (UICollectionViewScrollPosition)rav_collectionViewScrollPostionFromHorizontalViewScrollPosition:(RAVHorizontalViewScrollPosition)horScrollPosition
{
	UICollectionViewScrollPosition scrollPosition = UICollectionViewScrollPositionNone;
	switch (horScrollPosition)
	{
  case RAVHorizontalViewScrollPositionNone:
			scrollPosition = UICollectionViewScrollPositionNone;
			break;
		case RAVHorizontalViewScrollPositionCenteredHorizontally:
			scrollPosition = UICollectionViewScrollPositionCenteredHorizontally;
			break;
		case RAVHorizontalViewScrollPositionLeft:
			scrollPosition = UICollectionViewScrollPositionLeft;
			break;
		case RAVHorizontalViewScrollPositionRight:
			scrollPosition = UICollectionViewScrollPositionRight;
			break;
		default:
		{
			NSAssert(NO, @"Unknown position");
		}
			break;
	}
	
	return scrollPosition;
}

@end
