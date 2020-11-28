//
//  RAVManyModelCellsPresenter.h
//  RAVPresentersKit
//
//  Created by Andrew Romanov on 11/03/16.
//  Copyright © 2016 BL. All rights reserved.
//

#import "RAVCellPresenter.h"
#import <UIKit/UIKit.h>
#import "RAVUniversalDataViewP.h"


@class RAVManyModelCellsPresenter;
typedef void(^RAVManyModelCellsPresenterSelectionCallback)(RAVManyModelCellsPresenter * sender, id model);


@protocol RAVManyModelCellsPresenterDelegate;
@interface RAVManyModelCellsPresenter : RAVCellPresenter

@property (nonatomic) CGFloat cellHeight;

- (void)registerDelegate:(id<RAVManyModelCellsPresenterDelegate>)delegate forModelClass:(Class)modelClass;
- (void)setDelegateForAllModels:(id<RAVManyModelCellsPresenterDelegate>)delegate;

- (void)registerSelectionCallback:(RAVManyModelCellsPresenterSelectionCallback)callback forModelClass:(Class)modelClass;
/*
 The cell should support RAVUniversalCell protocol
 */
- (void)registerNib:(UINib*)nib withCellId:(NSString*)cellId forModelClass:(Class)modelClass;
- (void)registerCellClass:(Class)cellClass withCellId:(NSString*)cellId forModelClass:(Class)modelClass;

@end


@protocol RAVManyModelCellsPresenterDelegate <NSObject>

- (void)ravManyModelCellsPresenter:(RAVManyModelCellsPresenter *)sender selectedModel:(id)model;
@optional
- (CGFloat)ravManyModelCellsPresenter:(RAVManyModelCellsPresenter *)sender heightForModel:(id)model;

@end
