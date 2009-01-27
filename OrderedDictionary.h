//
//  OrderedDictionary.h
//  OrderedDictionary
//
//  Created by Matt Gallagher on 19/12/08.
//  Copyright 2008 Matt Gallagher. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface OrderedDictionary : NSMutableDictionary
{
	NSMutableDictionary *dictionary;
	NSMutableArray *array;
}

- (void)insertObject:(id)anObject forKey:(id)aKey atIndex:(NSUInteger)anIndex;
- (id)keyAtIndex:(NSUInteger)anIndex;
- (NSEnumerator *)reverseKeyEnumerator;

@end
