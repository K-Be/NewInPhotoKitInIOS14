//
//  NSArray+RAVSupport.h
//  RAVPresentersKit
//
//  Created by Andrew Romanov on 11/03/16.
//  Copyright © 2016 BL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray <ObjectType> (RAVSupport)

- (ObjectType)rav_findObjectPassingTest:(BOOL (^)(ObjectType obj, NSUInteger idx, BOOL *stop))predicate;
- (ObjectType)rav_findObjectWithOptions:(NSEnumerationOptions)opt passingTest:(BOOL (^)(ObjectType obj, NSUInteger idx, BOOL *stop))predicate;

@end
