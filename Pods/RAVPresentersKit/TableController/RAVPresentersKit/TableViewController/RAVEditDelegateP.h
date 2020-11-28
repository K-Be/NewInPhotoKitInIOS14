//
//  RAVEditDelegateP.h
//  TableController
//
//  Created by Andrew Romanov on 23.04.14.
//  Copyright (c) 2014 Andrew Romanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class RAVTableController;
@protocol RAVEditDelegateP <NSObject>

@optional
//UITableViewDataSource
- (BOOL)ravTableController:(RAVTableController*)sender canEditRowAtIndexPath:(NSIndexPath*)indexPath;
- (BOOL)ravTableController:(RAVTableController*)sender canMoveRowAtIndexPath:(NSIndexPath*)indexPath;
- (void)ravTableController:(RAVTableController*)sender commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath;
- (void)ravTableController:(RAVTableController*)sender moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;
//UITableViewDelegate
- (UITableViewCellEditingStyle)ravTableController:(RAVTableController*)sender editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)ravTableController:(RAVTableController*)sender titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0);
- (BOOL)ravTableController:(RAVTableController*)sender shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)ravTableController:(RAVTableController*)sender willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)ravTableController:(RAVTableController*)sender didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)ravTableController:(RAVTableController*)sender targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath;

@end
