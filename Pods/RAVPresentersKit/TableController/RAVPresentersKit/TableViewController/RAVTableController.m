//
//  RAVTableController.m
//  TableController
//
//  Created by Andrew Romanov on 23.04.14.
//  Copyright (c) 2014 Andrew Romanov. All rights reserved.
//

#import "RAVTableController.h"
#import "RAVTableController_Subclassing.h"
#import "RAVTableControllerListModelMemory.h"
#import "RAVPresentersStore.h"


typedef id RAVCellModel;
typedef id RAVSectionHeaderViewModel;
typedef id RAVSectionFooterViewModel;


@interface RAVTableController ()

@property (nonatomic, strong) RAVPresentersStore* rav_cellsPresenters;
@property (nonatomic, strong) RAVPresentersStore* rav_sectionHeadersPresenters;
@property (nonatomic, strong) RAVPresentersStore* rav_sectionFooterPresenters;

@end


@interface RAVTableController (rav_protected)

- (RavCellPresenterType*)rav_cellPresenterForDataModel:(RAVCellModel)dataModel;
- (RAVSectionFooterViewPresenterType*)rav_sectionFooterPresenterForSectionDataModel:(RAVSectionFooterViewModel)dataModel;
- (RAVSectionHeaderViewPresenterType*)rav_sectionHeaderPresenterForSectionDataModel:(RAVSectionHeaderViewModel)dataModel;

@end


@interface RAVTableController (rav_private)

- (id<RAVPresenterP>)rav_findPresenterForModel:(id)model inStore:(RAVPresentersStore*)presentersStore;
- (RAVSectionHeaderViewModel)rav_getHeaderSectionViewModelForSection:(NSInteger)section;
- (RAVSectionFooterViewModel)rav_getFooterSectionViewModelForSection:(NSInteger)section;
- (RAVCellModel)rav_getCellModelForIndexPath:(NSIndexPath*)indexPath;

- (UIView*)rav_emptySectionView;
- (void)rav_clearSourceAndDelegateOnTable;
- (void)rav_updateTableRefOnChildren;

@end


@implementation RAVTableController

- (id)init
{
	if (self = [super init])
	{
		self.rav_cellsPresenters = [[RAVPresentersStore alloc] init];
		self.rav_sectionHeadersPresenters = [[RAVPresentersStore alloc] init];
		self.rav_sectionFooterPresenters = [[RAVPresentersStore alloc] init];
		
		_model = [[RAVTableControllerListModelMemory alloc] init];
	}
	
	return self;
}


- (void)setTableView:(UITableView *)tableView
{
	[self rav_clearSourceAndDelegateOnTable];
	
	_tableView = tableView;
	_tableView.delegate = self;
	_tableView.dataSource = self;
	
	[self rav_updateTableRefOnChildren];
}


- (void)setModel:(id<RAVTableControllerListModelP>)model
{
	_model = model;
	[self reloadData];
}


- (void)reloadData
{
	if (self.tableView != nil && self.tableView.dataSource == self)
	{
		[self.tableView reloadData];
	}
}


- (void)registerCellPresenter:(RavCellPresenterType*)cellPresenter
{
	[self.rav_cellsPresenters registerPresenter:cellPresenter];
	cellPresenter.tableView = self.tableView;
}


- (void)registerSectionHeaderPresenter:(RAVSectionHeaderViewPresenterType*)sectionHeaderPresenter
{
	[self.rav_sectionHeadersPresenters registerPresenter:sectionHeaderPresenter];
	sectionHeaderPresenter.tableView = self.tableView;
}


- (void)registerSectionFooterPresenter:(RAVSectionFooterViewPresenterType*)sectionFooterPresenter
{
	[self.rav_sectionFooterPresenters registerPresenter:sectionFooterPresenter];
	sectionFooterPresenter.tableView = self.tableView;
}


- (void)setModelInAnimationBlock:(id<RAVTableControllerListModelP>)model
{
	_model = model;
}


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger count = 0;
	if ([self.model countSections] > 0)
	{
		id<RAVTableControllerSectionModelP> sectionModel = [self.model getSectionModelForSection:section];
		count = [sectionModel numberObjects];
	}
	else
	{
		count = 0;
	}
	return count;
}


// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	RAVCellModel dataModel = [self rav_getCellModelForIndexPath:indexPath];
	RavCellPresenterType* cellPresenter = [self rav_cellPresenterForDataModel:dataModel];
	UITableViewCell* cell = [cellPresenter cellForModel:dataModel atIndexPath:indexPath];
	if (!cell)
	{
		cell = [cellPresenter cellForModel:dataModel];
	}

	if (!cell)
	{
		NSAssert(NO, @"can't create cell for model %@ , presenter: %@", dataModel, cellPresenter);
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rav_stubCell"];
	}
	
	return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	NSInteger count = 1;
	if ([self.model countSections] > 0)
	{
		count = [self.model countSections];
	}
	
	return count;
}


// Editing
// Individual rows can opt out of having the -editing property set for them. If not implemented, all rows are assumed to be editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	BOOL can = NO;
	if ([self.editDelegate respondsToSelector:@selector(ravTableController:canEditRowAtIndexPath:)])
	{
		can = [self.editDelegate ravTableController:self canEditRowAtIndexPath:indexPath];
	}
	
	return can;
}


// Moving/reordering

// Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
	BOOL can = NO;
	if ([self.editDelegate respondsToSelector:@selector(ravTableController:canMoveRowAtIndexPath:)])
	{
		can = [self.editDelegate ravTableController:self canMoveRowAtIndexPath:indexPath];
	}
	
	return can;
}

// Index

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView                                                    // return list of section titles to display in section index view (e.g. "ABCD...Z#")
{
	NSArray* indexes = nil;
	
	if ([self.sectionIndexesDelegate respondsToSelector:@selector(ravTableControllerSectionIndexTitles:)])
	{
		indexes = [self.sectionIndexesDelegate ravTableControllerSectionIndexTitles:self];
	}
	
	return indexes;
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index  // tell table which section corresponds to section title/index (e.g. "B",1))
{
	NSInteger sectionIndex = index;
	if ([self.sectionIndexesDelegate respondsToSelector:@selector(ravTableController:sectionForSectionIndexTitle:atIndex:)])
	{
		sectionIndex = [self.sectionIndexesDelegate ravTableController:self sectionForSectionIndexTitle:title atIndex:index];
	}
	
	return sectionIndex;
}


// Data manipulation - insert and delete support

// After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([self.editDelegate respondsToSelector:@selector(ravTableController:commitEditingStyle:forRowAtIndexPath:)])
	{
		[self.editDelegate ravTableController:self commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
	}
}

// Data manipulation - reorder / moving support

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
	if ([self.editDelegate respondsToSelector:@selector(ravTableController:moveRowAtIndexPath:toIndexPath:)])
	{
		[self.editDelegate ravTableController:self moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
	}
}


#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	RAVCellModel cellModel = [self rav_getCellModelForIndexPath:indexPath];
	RavCellPresenterType* presenter = [self rav_cellPresenterForDataModel:cellModel];
	if ([presenter respondsToSelector:@selector(ravTableController:willDisplayModel:withIndexPath:)])
	{
		[presenter ravTableController:self willDisplayModel:cellModel withIndexPath:indexPath];
	}
	if ([presenter respondsToSelector:@selector(ravTableController:willDisplayCell:forIndexPath:)])
	{
		[presenter ravTableController:self willDisplayCell:cell forIndexPath:indexPath];
	}
}


- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
	if (indexPath.section < self.model.countSections)
	{
		id<RAVTableControllerSectionModelP> section = [self.model getSectionModelForSection:indexPath.section];
		if (indexPath.row < section.numberObjects)
		{
			RAVCellModel cellModel = [self rav_getCellModelForIndexPath:indexPath];
			RavCellPresenterType* presenter = [self rav_cellPresenterForDataModel:cellModel];
			if ([presenter respondsToSelector:@selector(ravTableController:didEndDisplayCell:withModel:froIndexPath:)])
			{
				[presenter ravTableController:self
										didEndDisplayCell:cell
														withModel:cellModel
												 froIndexPath:indexPath];
			}
		}
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat height = self.tableView.rowHeight;
	
	RAVCellModel cellModel = [self rav_getCellModelForIndexPath:indexPath];
	RavCellPresenterType* presenter = [self rav_cellPresenterForDataModel:cellModel];
	if ([presenter respondsToSelector:@selector(ravTableController:rowHeightForModel:)])
	{
		height = [presenter ravTableController:self rowHeightForModel:cellModel];
	}
	
	return height;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	CGFloat height = self.tableView.sectionHeaderHeight;
	if ([self.model countSections] > 0)
	{
		RAVSectionHeaderViewModel model = [self rav_getHeaderSectionViewModelForSection:section];
		RAVSectionHeaderViewPresenterType* presenter = [self rav_sectionHeaderPresenterForSectionDataModel:model];
		if ([presenter respondsToSelector:@selector(ravTableController:sectionViewHeightForModel:)])
		{
			height = [presenter ravTableController:self sectionViewHeightForModel:model];
		}
	}
	
	return height;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	CGFloat height = self.tableView.sectionFooterHeight;
	if ([self.model countSections] > 0)
	{
		RAVSectionFooterViewModel model = [self rav_getFooterSectionViewModelForSection:section];
		RAVSectionFooterViewPresenterType* presenter = [self rav_sectionFooterPresenterForSectionDataModel:model];
		if ([presenter respondsToSelector:@selector(ravTableController:sectionViewHeightForModel:)])
		{
			height = [presenter ravTableController:self sectionViewHeightForModel:model];
		}
	}
	
	return height;
}


// Section header & footer information. Views are preferred over title should you decide to provide both
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView* view = nil;
	
	if ([self.model countSections] > 0)
	{
		RAVSectionHeaderViewModel model = [self rav_getHeaderSectionViewModelForSection:section];
		RAVSectionHeaderViewPresenterType* presenter = [self rav_sectionHeaderPresenterForSectionDataModel:model];
		if ([presenter respondsToSelector:@selector(ravTableController:sectionViewForModel:)])
		{
			view = [presenter ravTableController:self sectionViewForModel:model];
		}
	}
	else
	{
		
	}
	if (!view)
	{
		view = [self rav_emptySectionView];
	}
	
	return view;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	UIView* view = nil;
	
	if ([self.model countSections] > 0)
	{
		RAVSectionFooterViewModel model = [self rav_getFooterSectionViewModelForSection:section];
		RAVSectionFooterViewPresenterType* presenter = [self rav_sectionFooterPresenterForSectionDataModel:model];
		if ([presenter respondsToSelector:@selector(ravTableController:sectionViewForModel:)])
		{
			view = [presenter ravTableController:self sectionViewForModel:model];
		}
	}
	else
	{
	}
	if (!view)
	{
		view = [self rav_emptySectionView];
	}
	
	return view;
}


// Accessories (disclosures).
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	RAVCellModel model = [self rav_getCellModelForIndexPath:indexPath];
	RavCellPresenterType* presenter = [self rav_cellPresenterForDataModel:model];
	if ([presenter respondsToSelector:@selector(ravTableController:accessoryButtonPressedForModel:)])
	{
		[presenter ravTableController:self accessoryButtonPressedForModel:model];
	}
}


// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	RAVCellModel model = [self rav_getCellModelForIndexPath:indexPath];
	RavCellPresenterType* presenter = [self rav_cellPresenterForDataModel:model];
	if ([presenter respondsToSelector:@selector(ravTableController:didSelectModel:needsDeselect:animated:)])
	{
		BOOL shouldDeselect = NO;
		BOOL animated = NO;
		[presenter ravTableController:self didSelectModel:model needsDeselect:&shouldDeselect animated:&animated];
		if (shouldDeselect)
		{
			[self.tableView deselectRowAtIndexPath:indexPath animated:animated];
		}
	}
}

// Editing

// Allows customization of the editingStyle for a particular cell located at 'indexPath'. If not implemented, all editable cells will have UITableViewCellEditingStyleDelete set for them when the table has editing property set to YES.
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCellEditingStyle editStyle = UITableViewCellEditingStyleDelete;
	if ([self.editDelegate respondsToSelector:@selector(ravTableController:editingStyleForRowAtIndexPath:)])
	{
		editStyle = [self.editDelegate ravTableController:self editingStyleForRowAtIndexPath:indexPath];
	}
	
	return editStyle;
}


// Controls whether the background is indented while editing.  If not implemented, the default is YES.  This is unrelated to the indentation level below.  This method only applies to grouped style table views.
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	BOOL intend = YES;
	if ([self.editDelegate respondsToSelector:@selector(ravTableController:shouldIndentWhileEditingRowAtIndexPath:)])
	{
		intend = [self.editDelegate ravTableController:self shouldIndentWhileEditingRowAtIndexPath:indexPath];
	}
	
	return intend;
}


// The willBegin/didEnd methods are called whenever the 'editing' property is automatically changed by the table (allowing insert/delete/move). This is done by a swipe activating a single row
- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([self.editDelegate respondsToSelector:@selector(ravTableController:willBeginEditingRowAtIndexPath:)])
	{
		[self.editDelegate ravTableController:self willBeginEditingRowAtIndexPath:indexPath];
	}
}


- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([self.editDelegate respondsToSelector:@selector(ravTableController:didEndEditingRowAtIndexPath:)])
	{
		[self.editDelegate ravTableController:self didEndEditingRowAtIndexPath:indexPath];
	}
}



// Moving/reordering

// Allows customization of the target row for a particular row as it is being moved/reordered
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
	NSIndexPath* result = proposedDestinationIndexPath;
	if ([self.editDelegate respondsToSelector:@selector(ravTableController:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:)])
	{
		result = [self.editDelegate ravTableController:self targetIndexPathForMoveFromRowAtIndexPath:sourceIndexPath toProposedIndexPath:proposedDestinationIndexPath];
	}
	
	return result;
}


// Copy/Paste.  All three methods must be implemented by the delegate.

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
	BOOL should = NO;
	RAVCellModel model = [self rav_getCellModelForIndexPath:indexPath];
	RavCellPresenterType* presenter = [self rav_cellPresenterForDataModel:model];
	if ([presenter respondsToSelector:@selector(ravTableController:shouldShowMenuForModel:)])
	{
		should = [presenter ravTableController:self shouldShowMenuForModel:model];
	}
	
	return should;
}


- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
	BOOL can = NO;
	RAVCellModel model = [self rav_getCellModelForIndexPath:indexPath];
	RavCellPresenterType* presenter = [self rav_cellPresenterForDataModel:model];
	if ([presenter respondsToSelector:@selector(ravTableController:canPerformAction:forModel:withActionSender:)])
	{
		can = [presenter ravTableController:self canPerformAction:action forModel:model withActionSender:sender];
	}
	
	return can;
}


- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
	RAVCellModel model = [self rav_getCellModelForIndexPath:indexPath];
	RavCellPresenterType* presenter = [self rav_cellPresenterForDataModel:model];
	if ([presenter respondsToSelector:@selector(ravTableController:performAction:forModel:withActionSender:)])
	{
		[presenter ravTableController:self performAction:action forModel:model withActionSender:sender];
	}
}


//Highlighting
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
	RAVCellModel model = [self rav_getCellModelForIndexPath:indexPath];
	RAVCellPresenter* presenter = [self rav_cellPresenterForDataModel:model];
	BOOL should = YES;
	if ([presenter respondsToSelector:@selector(ravTableController:shouldHighlightRowWithModel:)])
	{
		should = [presenter ravTableController:self shouldHighlightRowWithModel:model];
	}
	
	return should;
}


- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
	RAVCellModel model = [self rav_getCellModelForIndexPath:indexPath];
	RAVCellPresenter* presenter = [self rav_cellPresenterForDataModel:model];
	if ([presenter respondsToSelector:@selector(ravTableController:didHighlightRowWithModel:)])
	{
		[presenter ravTableController:self didHighlightRowWithModel:model];
	}
}


- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
	RAVCellModel model = [self rav_getCellModelForIndexPath:indexPath];
	RAVCellPresenter* presenter = [self rav_cellPresenterForDataModel:model];
	if ([presenter respondsToSelector:@selector(ravTableController:didUnhighlightRowWithModel:)])
	{
		[presenter ravTableController:self didUnhighlightRowWithModel:model];
	}
}


#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if ([self.scrollViewDelegate respondsToSelector:@selector(ravTableControllerScrollViewDidScroll:)])
	{
		[self.scrollViewDelegate ravTableControllerScrollViewDidScroll:self];
	}
}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
	if ([self.scrollViewDelegate respondsToSelector:@selector(ravTableControllerScrollViewDidZoom:)])
	{
		[self.scrollViewDelegate ravTableControllerScrollViewDidZoom:self];
	}
}


// called on start of dragging (may require some time and or distance to move)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	if ([self.scrollViewDelegate respondsToSelector:@selector(ravTableControllerScrollViewWillBeginDragging:)])
	{
		[self.scrollViewDelegate ravTableControllerScrollViewWillBeginDragging:self];
	}
}


// called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
	if ([self.scrollViewDelegate respondsToSelector:@selector(ravTableControllerScrollViewWillEndDragging:withVelocity:targetContentOffset:)])
	{
		[self.scrollViewDelegate ravTableControllerScrollViewWillEndDragging:self withVelocity:velocity targetContentOffset:targetContentOffset];
	}
}


// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if ([self.scrollViewDelegate respondsToSelector:@selector(ravTableControllerScrollViewDidEndDragging:willDecelerate:)])
	{
		[self.scrollViewDelegate ravTableControllerScrollViewDidEndDragging:self willDecelerate:decelerate];
	}
}


- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
	if ([self.scrollViewDelegate respondsToSelector:@selector(ravTableControllerScrollViewWillBeginDecelerating:)])
	{
		[self.scrollViewDelegate ravTableControllerScrollViewWillBeginDecelerating:self];
	}
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	if ([self.scrollViewDelegate respondsToSelector:@selector(ravTableControllerScrollViewDidEndDecelerating:)])
	{
		[self.scrollViewDelegate ravTableControllerScrollViewDidEndDecelerating:self];
	}
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
	if ([self.scrollViewDelegate respondsToSelector:@selector(ravTableControllerScrollViewDidEndScrollingAnimation:)])
	{
		[self.scrollViewDelegate ravTableControllerScrollViewDidEndScrollingAnimation:self];
	}
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	UIView* view = nil;
	if ([self.scrollViewDelegate respondsToSelector:@selector(ravTableControllerViewForZoomingInScrollView:)])
	{
		view = [self.scrollViewDelegate ravTableControllerViewForZoomingInScrollView:self];
	}
	
	return view;
}


- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
	if ([self.scrollViewDelegate respondsToSelector:@selector(ravTableControllerScrollViewWillBeginZooming:withView:)])
	{
		[self.scrollViewDelegate ravTableControllerScrollViewWillBeginZooming:self withView:view];
	}
}


- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
	if ([self.scrollViewDelegate respondsToSelector:@selector(ravTableControllerScrollViewDidEndZooming:withView:atScale:)])
	{
		[self.scrollViewDelegate ravTableControllerScrollViewDidEndZooming:self withView:view atScale:scale];
	}
}


- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
	BOOL should = [scrollView scrollsToTop];
	if ([self.scrollViewDelegate respondsToSelector:@selector(ravTableControllerScrollViewShouldScrollToTop:)])
	{
		should = [self.scrollViewDelegate ravTableControllerScrollViewShouldScrollToTop:self];
	}
	
	return should;
}


- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
	if ([self.scrollViewDelegate respondsToSelector:@selector(ravTableControllerScrollViewDidScrollToTop:)])
	{
		[self.scrollViewDelegate ravTableControllerScrollViewDidScrollToTop:self];
	}
}


- (void)dealloc
{
	[self rav_clearSourceAndDelegateOnTable];
}

@end


#pragma mark -
@implementation RAVTableController (rav_protected)

- (RavCellPresenterType*)rav_cellPresenterForDataModel:(RAVCellModel)dataModel
{
	RavCellPresenterType* presenter = (RavCellPresenterType*)[self rav_findPresenterForModel:dataModel inStore:self.rav_cellsPresenters];
	return presenter;
}


- (RAVSectionFooterViewPresenterType*)rav_sectionFooterPresenterForSectionDataModel:(RAVSectionFooterViewModel)dataModel
{
	RAVSectionFooterViewPresenterType* presenter = (RAVSectionFooterViewPresenterType*)[self rav_findPresenterForModel:dataModel inStore:self.rav_sectionFooterPresenters];
	return presenter;
}


- (RAVSectionHeaderViewPresenterType*)rav_sectionHeaderPresenterForSectionDataModel:(RAVSectionHeaderViewModel)dataModel
{
	RAVSectionHeaderViewPresenterType* presenter = (RAVSectionHeaderViewPresenterType*)[self rav_findPresenterForModel:dataModel inStore:self.rav_sectionHeadersPresenters];
	return presenter;
}

@end


#pragma mark -
@implementation RAVTableController (rav_private)

- (id<RAVPresenterP>)rav_findPresenterForModel:(id)model inStore:(RAVPresentersStore*)presentersStore
{
	id<RAVPresenterP> presenter = [presentersStore presenterForModel:model];
	return presenter;
}


- (RAVSectionHeaderViewModel)rav_getHeaderSectionViewModelForSection:(NSInteger)section
{
	id<RAVTableControllerSectionModelP> sectionModel = [self.model getSectionModelForSection:section];
	return sectionModel.headerViewModel;
}


- (RAVSectionFooterViewModel)rav_getFooterSectionViewModelForSection:(NSInteger)section
{
	id<RAVTableControllerSectionModelP> sectionModel = [self.model getSectionModelForSection:section];
	return sectionModel.footerViewModel;
}


- (RAVCellModel)rav_getCellModelForIndexPath:(NSIndexPath*)indexPath
{
	RAVCellModel model = [self.model getModelForIndexPath:indexPath];
	return model;
}


- (UIView*)rav_emptySectionView
{
	UIView* view = [[UIView alloc] initWithFrame:CGRectZero];
	view.userInteractionEnabled = NO;
	view.backgroundColor = [UIColor clearColor];
	
	return view;
}


- (void)rav_clearSourceAndDelegateOnTable
{
	if (self.tableView.delegate == self)
	{
		self.tableView.delegate = nil;
	}
	if (self.tableView.dataSource == self)
	{
		self.tableView.dataSource = nil;
	}
}


- (void)rav_updateTableRefOnChildren
{
	[self.rav_cellsPresenters makeObjectsPerformSelector:@selector(setTableView:) withObject:self.tableView];
	[self.rav_sectionFooterPresenters makeObjectsPerformSelector:@selector(setTableView:) withObject:self.tableView];
	[self.rav_sectionHeadersPresenters makeObjectsPerformSelector:@selector(setTableView:) withObject:self.tableView];
}

@end
