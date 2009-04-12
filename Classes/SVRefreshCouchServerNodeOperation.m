//
//  SVRefreshCouchServerNodeOperation.m
//  Davenport
//
//  Created by Robert Evans on 4/2/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import "DPResourceFactory.h"
#import "SVAbstractCouchNodeOperation.h"
#import "SVRefreshCouchServerNodeOperation.h"
#import "SVAppDelegate.h"
#import "NSTreeNode+SVDavenport.h"
@implementation SVRefreshCouchServerNodeOperation


-(id) initWithCouchServerTreeNode:(NSTreeNode*)serverTreeNode indexPath:(NSIndexPath*)indexPath{
    self = [super initWithCouchTreeNode:serverTreeNode indexPath:indexPath resourceFactory:[(SVAppDelegate*) [NSApp delegate] mainWindowController]];
    if(self){   
        self.couchServer = [serverTreeNode couchObject];
    }
    return self;
}
-(void) dealloc{
    [super dealloc];
}

#pragma mark - 

- (void)main {
    SBCouchServer *server = [self.rootNode couchObject];
    NSTreeNode *copyOfServerNode = [NSTreeNode treeNodeWithRepresentedObject:server];
    NSArray *databases = [server listDatabases];
    
    if(databases == nil){
        SVDebug(@"No databases found.");
        return;
    }
        
    [self createNodesForDatabases:databases serverNode:copyOfServerNode];
    
    [copyOfServerNode logTree];
    
    @synchronized(self.rootNode){
        NSMutableArray *childNodes = [self.rootNode mutableChildNodes];
        [childNodes removeAllObjects];
        for(NSTreeNode *newChildNode in [copyOfServerNode mutableChildNodes]){
            [childNodes addObject:newChildNode];
            NSLog(@"--> %@, %i", [[newChildNode couchObject] class], [childNodes count]);            
        }        
    }    
    [couchServer release];
}

@end
