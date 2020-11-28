//
//  RAVTableController_Subclassing.h
//  TableController
//
//  Created by Andrew Romanov on 23.04.14.
//  Copyright (c) 2014 Andrew Romanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RAVTableController.h"


@interface RAVTableController (Subclassing)

- (RavCellPresenterType*)rav_cellPresenterForDataModel:(id)dataModel;
- (RAVSectionFooterViewPresenterType*)rav_sectionFooterPresenterForSectionDataModel:(id)dataModel;
- (RAVSectionHeaderViewPresenterType*)rav_sectionHeaderPresenterForSectionDataModel:(id)dataModel;

@end