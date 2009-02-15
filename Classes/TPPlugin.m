//
//  TNavContribution.m
//  DPTestPlugin
//
//  Created by Robert Evans on 2/13/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import "TPPlugin.h"
#import "TPBucket.h"
#import "TPTask.h"
#import "NSTreeNode+TP.h"


@implementation TPPlugin

+(NSString*)pluginID{
    //return [TPPlugin class];
    // TODO It would be nice to make this dynamic
    return @"TPPlugin";
}


-(NSString*)pluginID{
    //return [TPPlugin class];
    // TODO It would be nice to make this dynamic
    return @"TPPlugin";
}

-(NSTreeNode*)navigationContribution{
    NSTreeNode *contributionRoot = [[[NSTreeNode alloc] init] autorelease];            
    NSTreeNode *taskmgmtNode = [contributionRoot addChildWithLabel:@"Task Mgmt" identity:@"taskmgmt" group:YES];
    
    
    NSTreeNode *milestone = [taskmgmtNode addChildWithLabel:@"milestone one" identity:@"milsotneone"];
    [milestone addChildWithLabel:@"Map/Reduce Editor" identity:@"do it"];
    [milestone addChildWithLabel:@"Self Hosting" identity:@"do it"];
    [milestone addChildWithLabel:@"Feature Complete" identity:@"do it"];

    NSTreeNode *milestone2 = [taskmgmtNode addChildWithLabel:@"milestone two" identity:@"milsotneone"];
    [milestone2 addChildWithLabel:@"Network Plugin Loading" identity:@"do it"];
    [milestone2 addChildWithLabel:@"Buffer Interface" identity:@"do it"];

        
    return contributionRoot;
}
/*!
 This is a delegate method that is invoked when a user selects a navigation item 
 that we have contributed to the left hand navigation of Davenport. 
 */
-(void)selectionDidChange:(NSTreeNode*)item{
    NSLog(@"User selected one our navigation items!");
}

@end
