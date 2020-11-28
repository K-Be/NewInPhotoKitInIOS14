//
//  RAVSingleModelCellPresenter.h
//  RAVPresentersKit
//
//  Created by Andrew Romanov on 11/03/16.
//  Copyright © 2016 BL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RAVCellPresenter.h"
#import "RAVUniversalDataViewP.h"


@class RAVSingleModelCellPresenter;
typedef void(^RAVSingleModelCellPresenterSelectionCallback)(RAVSingleModelCellPresenter * sender, id selectedModel);

@protocol RAVSingleModelCellPresenterDelegate;
@interface RAVSingleModelCellPresenter : RAVCellPresenter

@property (nonatomic, weak) id<RAVSingleModelCellPresenterDelegate> delegate;
@property (nonatomic, copy) RAVSingleModelCellPresenterSelectionCallback selectionCallback;

@property (nonatomic) CGFloat rowHeight;

- (void)setCellNib:(UINib*)cellNib withCellId:(NSString*)cellId forModelClass:(Class)modelClass;
- (void)setCellClass:(Class)cellClass withCellId:(NSString*)cellId forModelClass:(Class)modelClass;

- (BOOL)canPresentModelWithClass:(Class)modelClass;

@end


@protocol RAVSingleModelCellPresenterDelegate <NSObject>

- (void)ravSingleModelCellPresenter:(RAVSingleModelCellPresenter *)sender selectedModel:(id)model;

@end
