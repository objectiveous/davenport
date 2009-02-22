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
@interface TPPlugin : NSObject <DPContributionPlugin>{
    NSTreeNode *currentItem;
}

@property (retain) NSTreeNode *currentItem;

+(NSString*)databaseName;
+(NSString*)pluginID;
-(NSString*)pluginID;

-(void)start;
@end
