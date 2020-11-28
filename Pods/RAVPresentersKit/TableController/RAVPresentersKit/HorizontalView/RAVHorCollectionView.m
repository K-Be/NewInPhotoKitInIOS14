//
//  RAVHorCollectionView.m
//  RAVPresentersKit
//
//  Created by Andrew Romanov on 10.11.14.
//  Copyright (c) 2014 Andrew Romanov. All rights reserved.
//

#import "RAVHorCollectionView.h"


@interface RAVHorCollectionView (RAV_Private)

- (void)rav_commonInitialization;

@end


@implementation RAVHorCollectionView

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:aDecoder])
	{
		[self rav_commonInitialization];
	}
	
	return self;
}


- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])
	{
		[self rav_commonInitialization];
	}
	
	return self;
}


- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
	if (self = [super initWithFrame:frame collectionViewLayout:layout])
	{
		[self rav_commonInitialization];
	}
	
	return self;
}


- (id)init
{
	if (self = [super init])
	{
		[self rav_commonInitialization];
	}
	
	return self;
}


- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
	return YES;
}

@end


#pragma mark -
@implementation RAVHorCollectionView (FA_Pri)

- (void)fa_commonInitialization
{
	self.delaysContentTouches = NO;
}

@end
