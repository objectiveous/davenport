//
//  SVAbstractCouchNodeOperation.m
//  Davenport
//
//  Created by Robert Evans on 4/2/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import "DPResourceFactory.h"
#import "SVAbstractCouchNodeOperation.h"
#import "NSTreeNode+SVDavenport.h"


@implementation SVAbstractCouchNodeOperation
@synthesize rootNode;
@synthesize databaseIndexPath;
@synthesize resourceFactory;
@synthesize couchServer;


-(id) initWithCouchTreeNode:(NSTreeNode*)couchTreeNode indexPath:(NSIndexPath*)indexPath resourceFactory:(id <DPResourceFactory>)rezFactory{    
    self = [super init];
    if(self){
        self.rootNode = couchTreeNode;
        self.databaseIndexPath = indexPath;
        self.resourceFactory = rezFactory;
    }
    return self;
}
-(void) dealloc{
    self.rootNode = nil;
    self.databaseIndexPath = nil;
    [super dealloc];
}

#pragma mark -
-(void)createNodesForDatabases:(NSArray*)couchDatabaseList serverNode:(NSTreeNode*)serverNode{
    
    for(NSString *databaseName in couchDatabaseList){
        SBCouchDatabase *couchDatabase = [self.couchServer database:databaseName];                       
        NSTreeNode *databaseTreeNode = [serverNode addCouchDatabaseNode:couchDatabase resourceFactory:self.resourceFactory];            
        
        [self createNodesForDesignDocs:couchDatabase databaseNode:databaseTreeNode];            
    } 
}

-(void)createNodesForDesignDocs:(SBCouchDatabase*)couchDatabase databaseNode:(NSTreeNode*)databaseTreeNode{
    NSEnumerator *designDocs = [couchDatabase getDesignDocuments];        
    SBCouchDesignDocument *designDoc;
    NSTreeNode *designNode;
    
    while((designDoc = [designDocs nextObject])){
        
        designNode = [databaseTreeNode addCouchDesignNode:designDoc resourceFactory:self.resourceFactory];        
        NSDictionary *dictionaryOfViews =  [designDoc views];
        
        for(id viewName in dictionaryOfViews){
            SBCouchView *couchView = [dictionaryOfViews objectForKey:viewName];
            
            [designNode addCouchViewNode:couchView resourceFactory:self.resourceFactory];
        }                        
    }
}

@end
