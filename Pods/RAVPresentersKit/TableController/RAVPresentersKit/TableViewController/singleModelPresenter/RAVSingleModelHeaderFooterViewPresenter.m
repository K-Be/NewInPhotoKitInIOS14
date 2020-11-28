//
// Created by Andrew Romanov on 25/03/16.
// Copyright (c) 2016 BL. All rights reserved.
//

#import "RAVSingleModelHeaderFooterViewPresenter.h"


@interface RAVSingleModelHeaderFooterViewPresenter ()

@property (nonatomic, strong) UINib* viewNib;
@property (nonatomic, strong) Class viewClass;
@property (nonatomic, strong) NSString* viewIdentity;

@property (nonatomic, strong) Class modelClass;

@property (nonatomic, weak) id viewDelegate;
@property (nonatomic) SEL viewDelegateSetter;

@end


@implementation RAVSingleModelHeaderFooterViewPresenter


- (void)setViewClass:(Class)viewClass withIdentity:(NSString*)identity forModelClass:(Class)modelClass
{
	_viewNib = nil;
	
	_viewClass = viewClass;
	_viewIdentity = identity;
	_modelClass = modelClass;
}


- (void)setViewNib:(UINib*)viewNib withIdentity:(NSString*)identity forModelClass:(Class)modelClass
{
	_viewClass = nil;
	
	_viewNib = viewNib;
	_viewIdentity = identity;
	_modelClass = modelClass;
}


- (void)setDelegateForView:(__weak id)delegate //used setDelegate:
{
	[self setDelegateForView:delegate withSelector:@selector(setDelegate:)];
}


- (void)setDelegateForView:(__weak id)delegate withSelector:(SEL)delegateSetter
{
	_viewDelegate = delegate;
	_viewDelegateSetter = delegateSetter;
}


- (void)registerView
{
	[super registerView];
	
	if (self.viewNib)
	{
		[self.tableView registerNib:self.viewNib forHeaderFooterViewReuseIdentifier:_viewIdentity];
	}
	else if (_viewClass)
	{
		[self.tableView registerClass:self.viewClass forHeaderFooterViewReuseIdentifier:_viewIdentity];
	}
}


- (BOOL)canPresent:(id)model
{
	BOOL can = ([model class] == _modelClass);
	return can;
}


- (CGFloat)ravTableController:(RAVTableController*)sender sectionViewHeightForModel:(id)sectionViewModel
{
	return self.height;
}


- (UIView*)ravTableController:(RAVTableController*)sender sectionViewForModel:(id)sectionViewModel
{
	UIView<RAVUniversalDataViewP>* view = (UIView<RAVUniversalDataViewP>*)[self.tableView dequeueReusableHeaderFooterViewWithIdentifier:_viewIdentity];
	NSParameterAssert(view != nil);
	NSParameterAssert([view conformsToProtocol:@protocol(RAVUniversalDataViewP)]);
	if ([view conformsToProtocol:@protocol(RAVUniversalDataViewP)])
	{
		view.model = sectionViewModel;
	}
	
	if (_viewDelegate)
	{
		NSParameterAssert([view respondsToSelector:_viewDelegateSetter]);
		if ([view respondsToSelector:_viewDelegateSetter])
		{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
					[view performSelector:_viewDelegateSetter withObject:_viewDelegate];
#pragma clang diagnostic pop
		}
	}
	
	return view;
}

@end