//
//  SVAbstractDescriptor.h
//  
//
//  Created by Robert Evans on 12/27/08.
//  Copyright 2008 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DPContributionNavigationDescriptor.h"

@interface SVAbstractDescriptor : NSObject <DPContributionNavigationDescriptor>{
    // A label is the text show to the user. For example, in an outline view we might 
    // display a design document named _design/numberOfJazzBands as Number Of Jazz Bands
    NSString *label;
    // Identity is the actual resource name that a Descriptor represents. For example 
    //  _design/numberOfJazzBands
    NSString *identity;         
    NSImage	 *nodeIcon;
    BOOL      groupItem;
}

@property (retain) NSString *label;
@property (retain) NSImage  *nodeIcon;
@property (retain) NSString *identity;
@property BOOL groupItem;

-(id)initWithLabel:(NSString*)nodeLabel andIdentity:(NSString*)identity;
-(BOOL)isGroupItem;
@end
