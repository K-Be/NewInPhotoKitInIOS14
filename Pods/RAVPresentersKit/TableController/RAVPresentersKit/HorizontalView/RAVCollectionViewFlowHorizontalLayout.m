//
//  RAVCollectionViewFlowHorizontalLayout.m
//  RAVPresentersKit
//
//  Created by Andrew Romanov on 29.10.14.
//  Copyright (c) 2014 Andrew Romanov. All rights reserved.
//

#import "RAVCollectionViewFlowHorizontalLayout.h"


@interface RAVCollectionViewFlowHorizontalLayout (Private)

- (UIEdgeInsets)rav_getSectionInsetForSectionAtIndex:(NSInteger)sectionIndex;

@end


@implementation RAVCollectionViewFlowHorizontalLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
	NSMutableArray* array = [NSMutableArray arrayWithCapacity:20.0];
	
	NSInteger countSections = [self.collectionView numberOfSections];
	for (NSInteger section = 0; section < countSections; section++)
	{
		NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:section];
		for (NSInteger item = 0; item < numberOfItemsInSection; item++)
		{
			UICollectionViewLayoutAttributes* attributes = [[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:section]] copy];
			CGRect frame = [attributes frame];
			if (CGRectIntersectsRect(frame, rect))
			{
				[array addObject:attributes];
			}
		}
	}
	
	return array;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewLayoutAttributes* currentItemAttributes = [[super layoutAttributesForItemAtIndexPath:indexPath] copy];
	
	UIEdgeInsets sectionInset = [self rav_getSectionInsetForSectionAtIndex:indexPath.section];
	
	CGFloat left = sectionInset.left + indexPath.item * (self.minimumInteritemSpacing + currentItemAttributes.frame.size.width);

	CGRect frame = currentItemAttributes.frame;
	frame.origin.x = left;
	currentItemAttributes.frame = frame;

	return currentItemAttributes;
}


- (CGSize)collectionViewContentSize
{
	CGSize superContentSize = [super collectionViewContentSize];

	CGSize contentSize = superContentSize;
	NSInteger numberOfSections = [self.collectionView numberOfSections];
	if (numberOfSections > 0)
	{
		NSInteger numberOfCellsInLastSection = [self.collectionView numberOfItemsInSection:numberOfSections - 1];
		
		if (numberOfCellsInLastSection > 0)
		{
			UICollectionViewLayoutAttributes* layoutAttributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:(numberOfCellsInLastSection - 1) inSection:(numberOfSections - 1)]];
			contentSize.width = layoutAttributes.frame.origin.x + layoutAttributes.frame.size.width;
			UIEdgeInsets sectionInsets = [self rav_getSectionInsetForSectionAtIndex:(numberOfSections - 1)];
			contentSize.width += sectionInsets.right;
		}
	}
	
	return contentSize;
}

@end


#pragma mark -
@implementation RAVCollectionViewFlowHorizontalLayout (Private)

- (UIEdgeInsets)rav_getSectionInsetForSectionAtIndex:(NSInteger)sectionIndex
{
	UIEdgeInsets insets = UIEdgeInsetsZero;
	
	if([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)])
	{
		insets = [(id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:sectionIndex];
	}
	else
	{
		insets = [(UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout sectionInset];
	}
	
	return insets;
}

@end
