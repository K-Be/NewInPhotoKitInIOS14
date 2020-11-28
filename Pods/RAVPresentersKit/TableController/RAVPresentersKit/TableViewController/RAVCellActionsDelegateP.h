//
//  RAVCellActionsDelegateP.h
//  TableController
//
//  Created by Andrew Romanov on 23.04.14.
//  Copyright (c) 2014 Andrew Romanov. All rights reserved.
//

#import <Foundation/Foundation.h>


@class RAVTableController;
@protocol RAVCellActionsDelegateP <NSObject>
@required
@property (nonatomic, weak) UITableView* tableView;

- (CGFloat)ravTableController:(RAVTableController*)sender rowHeightForModel:(id)model;

@optional
- (void)ravTableController:(RAVTableController*)sender didSelectModel:(id)model needsDeselect:(inout BOOL*)needsDeselect animated:(inout BOOL*)animated;
- (void)ravTableController:(RAVTableController*)sender willDisplayModel:(id)model withIndexPath:(NSIndexPath*)indexPath;
- (void)ravTableController:(RAVTableController *)sender willDisplayCell:(UITableViewCell*)cell forIndexPath:(NSIndexPath *)indexPath;
- (void)ravTableController:(RAVTableController *)sender didEndDisplayCell:(UITableViewCell*)cell withModel:(id)model froIndexPath:(NSIndexPath*)indexPath;
- (void)ravTableController:(RAVTableController*)sender accessoryButtonPressedForModel:(id)model;

//Highlighting
- (BOOL)ravTableController:(RAVTableController*)sender shouldHighlightRowWithModel:(id)model;
- (void)ravTableController:(RAVTableController*)sender didHighlightRowWithModel:(id)model;
- (void)ravTableController:(RAVTableController*)sender didUnhighlightRowWithModel:(id)model;

//Copy/Paste
- (BOOL)ravTableController:(RAVTableController*)sender shouldShowMenuForModel:(id)model NS_AVAILABLE_IOS(5_0);
- (BOOL)ravTableController:(RAVTableController*)sender canPerformAction:(SEL)action forModel:(id)model withActionSender:(id)actionSender NS_AVAILABLE_IOS(5_0);
- (void)ravTableController:(RAVTableController*)sender performAction:(SEL)action forModel:(id)model withActionSender:(id)actionSender NS_AVAILABLE_IOS(5_0);

@end
