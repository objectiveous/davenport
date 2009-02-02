//
//  SVJSONDescriptor.h
//  Davenport
//
//  Created by Robert Evans on 2/1/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SVAbstractDescriptor.h"

#define JSON_TYPE_OBJECT 1
#define JSON_TYPE_SCALAR 2
#define JSON_TYPE_ARRAY  3

@interface SVJSONDescriptor : SVAbstractDescriptor {
    NSString *value;
    NSInteger     jsonType;
}

@property (retain) NSString *value;
@property NSInteger jsonType;
@end
