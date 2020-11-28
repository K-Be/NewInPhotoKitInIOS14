//
// Created by Andrew Romanov on 25/03/16.
// Copyright (c) 2016 BL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RAVUniversalDataViewP.h"
#import "RAVSectionHeaderFooterViewPresenter.h"


@interface RAVSingleModelHeaderFooterViewPresenter : RAVSectionHeaderFooterViewPresenter

@property (nonatomic) CGFloat height;

- (void)setViewClass:(Class)viewClass withIdentity:(NSString*)identity forModelClass:(Class)modelClass;
- (void)setViewNib:(UINib*)viewNib withIdentity:(NSString*)identity forModelClass:(Class)modelClass;

- (void)setDelegateForView:(__weak id)delegate; //used setDelegate:
- (void)setDelegateForView:(__weak id)delegate withSelector:(SEL)delegateSetter;

@end