//
//  DPResourceFactory.h
//  Davenport
//
//  Created by Robert Evans on 2/24/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum sharedResources{
    DPSharedViewContollerNamedFunctionEditor  = 1,
    
} DPSharedResources;


// Conforming classes will provide shared resources to plugins. 
// a typicall usage would be a plugin wanting to return the 
// standard FuntionEditor during a call to [plugin mainSectionContribution]
//
@protocol DPResourceFactory 

-(id)namedResource:(DPSharedResources)resourceName withItem:(id)itemOrNil;

@end
