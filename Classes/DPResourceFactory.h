//
//  DPResourceFactory.h
//  Davenport
//
//  Created by Robert Evans on 2/24/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>
//#import "DPContributionNavigationDescriptor.h"

@class DPContributionNavigationDescriptor;

typedef enum sharedResources{
    DPSharedViewContollerNamedFunctionEditor  = 1,
    DPSharedViewContollerNamedViewResults     = 2,
//    DPSharedViewEmptyView                     = 4,
    
} DPSharedResources;


/*!
 Conforming classes will provide shared resources to plugins. Typically calls will come from an instance that conforms to 
 DPContributionNavigationDescriptor that wants to use the standard/shared NSViewControllers. For example a plugin wanting 
 to return the standard FunctionEditor during a call to [navContributionDesciptor contributionMainViewController]; 
 
 An interesting problem is the issue of supplying the shared NSController and it's hierarchy of views with the data it needs. 
 For example, the SVQueryResultController's view has an NSOutlineView ivar that requires a datasource to be functional. This could 
 simply be provided by the by navContributionDesciptor but doing so in a generic way seems challenging at the moment. Maybe I 
 need some sleep. 

 
*/
@protocol DPResourceFactory 
-(id)namedResource:(DPSharedResources)resourceName;
@end
