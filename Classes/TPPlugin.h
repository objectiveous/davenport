//
//  TNavContribution.h
//  DPTestPlugin
//
//  Created by Robert Evans on 2/13/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DPContributionPlugin.h"
#import "SVConstants.h"

typedef enum descriptorType{
    TPNavigationDescriptorDesignDoc  = 1,
    TPNavigationDescriptorView       = 2,
    TPNavigationDescriptorMilestone  = 3,
    TPNavigationDescriptorAppName    = 4,
    TPNavigationDescriptorTicketBin  = 5,
    
} TPNavigationDescriptorType;

@interface TPPlugin : NSObject <DPContributionPlugin>{
    NSTreeNode *currentItem;
    NSTreeNode *navContribution;
    NSOperationQueue *queue;
}

@property (retain) NSTreeNode *currentItem;

+(NSString*)databaseName;
+(NSString*)pluginID;
-(NSString*)pluginID;

-(void)start;
@end
