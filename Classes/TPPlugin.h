//
//  TNavContribution.h
//  DPTestPlugin
//
//  Created by Robert Evans on 2/13/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DPResourceFactory;
@class DPContributionPlugin;

/*
typedef enum descriptorType{
    TPNavigationDescriptorDesignDoc  = 1,
    TPNavigationDescriptorView       = 2,
    TPNavigationDescriptorMilestone  = 3,
    TPNavigationDescriptorAppName    = 4,
    TPNavigationDescriptorTicketBin  = 5,
    
} TPNavigationDescriptorType;

 */
@interface TPPlugin : NSObject <DPContributionPlugin>{
    NSBundle               *bundle;
    NSTreeNode             *currentItem;
    NSTreeNode             *navContribution;
    NSOperationQueue       *queue;
    id <DPResourceFactory> resourceFactory;
}

@property (retain) NSTreeNode          *currentItem;
@property (retain) <DPResourceFactory> resourceFactory;
@property (retain) NSBundle            *bundle;

+ (NSString*)databaseName;
+ (NSString*)pluginID;
- (NSString*)pluginID;

- (void)start;
@end
