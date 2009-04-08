//
//  SVFeetchDatabaseInfoOperation.m
//  Davenport
//
//  Created by Robert Evans on 3/20/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import "SVRefreshCouchDatabaseNodeOperation.h"
#import "NSTreeNode+SVDavenport.h"
#import "SVBaseNavigationDescriptor.h"
#import "SVAppDelegate.h"

@implementation SVRefreshCouchDatabaseNodeOperation
//@synthesize rootNode;
//@synthesize databaseIndexPath;

-(id) initWithCouchDatabaseTreeNode:(NSTreeNode*)databaseTreeNode indexPath:(NSIndexPath*)indexPath{    
    self = [super initWithCouchTreeNode:databaseTreeNode indexPath:indexPath resourceFactory:[(SVAppDelegate*) [NSApp delegate] mainWindowController]];
    if(self){
    }
    return self;
}

-(void) dealloc{
    [super dealloc];
}

#pragma mark -

- (void)main {
    NSTreeNode *newDatabaseTreeNode = [NSTreeNode treeNodeWithRepresentedObject:nil];
    id <DPResourceFactory> factory = [(SVAppDelegate*) [NSApp delegate] mainWindowController];
    
    NSTreeNode *databaseNode = [self.rootNode descendantNodeAtIndexPath:self.databaseIndexPath];

    id couchDatabase = [databaseNode couchObject];
    
    // If we've been handed a tree node holding a CouchDocument, we can still update the 
    // database. 
    if([couchDatabase isKindOfClass:[SBCouchDocument class]]){
        couchDatabase = [(SBCouchDocument*)couchDatabase couchDatabase];
        databaseNode = [databaseNode parentNode];
    }
        
    NSEnumerator *designDocs = [couchDatabase getDesignDocuments];        
    
    SBCouchDesignDocument *designDoc;
    while((designDoc = [designDocs nextObject])){        
        NSString *label = [designDoc.identity lastPathComponent];
        
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:2];
        [userInfo setObject:designDoc forKey:@"couchobject"];
        
        SVBaseNavigationDescriptor *designDescriptor = [[SVBaseNavigationDescriptor alloc] initWithLabel:label
                                                                                             andIdentity:designDoc.identity
                                                                                                    type:DPDescriptorCouchDesign
                                                                                                userInfo:userInfo];
        designDescriptor.couchDatabase = couchDatabase;
        designDescriptor.resourceFactory = factory;
        NSTreeNode *designNode = [newDatabaseTreeNode addChildNodeWithObject:designDescriptor];
        
        NSDictionary *dictionaryOfViews =  [designDoc views];
        for(id viewName in dictionaryOfViews){
            SBCouchView *couchView = [dictionaryOfViews objectForKey:viewName];
            
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:2];
            [userInfo setObject:couchView forKey:@"couchobject"];
            
            SVBaseNavigationDescriptor *viewDescriptor = [[SVBaseNavigationDescriptor alloc] initWithLabel:couchView.name
                                                                                               andIdentity:[couchView identity]
                                                                                                      type:DPDescriptorCouchView
                                                                                                  userInfo:userInfo];
            viewDescriptor.resourceFactory = factory;
            
            [designNode addChildNodeWithObject:viewDescriptor];
        }        
    }
    
    @synchronized(self.rootNode) {        
        NSMutableArray *childNodes = [databaseNode mutableChildNodes];
        [childNodes removeAllObjects];        
        for(NSTreeNode *newChildNode in [newDatabaseTreeNode mutableChildNodes]){
            [childNodes addObject:newChildNode];
            //NSLog(@"--> %@, %i", [[newChildNode couchObject] class], [childNodes count]);            
        }
    }
}
@end
