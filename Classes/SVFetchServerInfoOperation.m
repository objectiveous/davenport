//
//  SVFetchServerInfoOperation.m
// 
//
//  Created by Robert Evans on 12/30/08.
//  Copyright 2008 South And Valley. All rights reserved.
//

#import "SVFetchServerInfoOperation.h"
#import "SVAppDelegate.h"
#import "NSTreeNode+SVDavenport.h"
#import <CouchObjC/CouchObjC.h>
#import "SVBaseNavigationDescriptor.h"
#import "DPContributionNavigationDescriptor.h"

#define QUERIES                 @"QUERIES"
#define DATABASES               @"DATABASES"
#define TOOLS                   @"TOOLS"
#define DESIGN                  @"DESIGN"


@implementation SVFetchServerInfoOperation

@synthesize rootNode;
@synthesize couchServer;

-(id) initWithCouchServer:(SBCouchServer *)server rootTreeNode:(NSTreeNode*)rootTreeNode{
    self = [super init];
    if(self){
        self.couchServer = server;
        self.rootNode = rootTreeNode;
    }
    return self;
}

// XXX A list of things I don't like with this method: 
//     - Too long. 
//     - Seems like SVBaseNavigationDescriptor could have a simpler constructor 
//     - Seems to do more than one thing - needs some decomposition. 
//     - I'm a little worried about loading in the view data as I think it impacts 
//       performance. 
//     - Return fetched data is obsolete 
//
//      Consider using anohter operaton to load Views. 
- (void)main {
    SVDebug(@"Trying to fetch server information from localhot:5983");
    fetchReturnedData = NO;
    id <DPResourceFactory> factory = [(SVAppDelegate*) [NSApp delegate] mainWindowController];
    
    assert(couchServer);
    NSArray *databases = [couchServer listDatabases];
    
    if(databases == nil){
        SVDebug(@"No databases found.");
        return;
    }
    fetchReturnedData = YES;


    NSString *hostAndPort = [NSString stringWithFormat:@"%@:%i",self.couchServer.host, self.couchServer.port];
    NSTreeNode *couchServerNode = [self.rootNode addCouchServerSection:hostAndPort];

    for(NSString *databaseName in databases){
        SBCouchDatabase *couchDatabase = [self.couchServer database:databaseName];
            
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:2];
        [userInfo setObject:couchDatabase forKey:@"couchobject"];
        
        SVBaseNavigationDescriptor *databaseDescriptor = [[SVBaseNavigationDescriptor alloc] initWithLabel:databaseName
                                                                                               andIdentity:databaseName
                                                                                                      type:DPDescriptorCouchDatabase
                                                                                                    userInfo:userInfo];
        
        databaseDescriptor.couchDatabase = couchDatabase;
        databaseDescriptor.resourceFactory = factory;
        
        NSTreeNode *databaseTreeNode = [couchServerNode addChildNodeWithObject:databaseDescriptor];                
        NSEnumerator *designDocs = [couchDatabase getDesignDocuments];        

        SBCouchDocument *couchDocument;
        while((couchDocument = [designDocs nextObject])){                        
          SBCouchDesignDocument *designDoc = [SBCouchDesignDocument designDocumentFromDocument:couchDocument];
            
          NSString *label = [couchDocument.identity lastPathComponent];

          NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:2];
          [userInfo setObject:designDoc forKey:@"couchobject"];

           SVBaseNavigationDescriptor *designDescriptor = [[SVBaseNavigationDescriptor alloc] initWithLabel:label
                                                                                                andIdentity:couchDocument.identity
                                                                                                       type:DPDescriptorCouchDesign
                                                                                                   userInfo:userInfo];
           designDescriptor.couchDatabase = couchDatabase;
           designDescriptor.resourceFactory = factory;
           NSTreeNode *designNode = [databaseTreeNode addChildNodeWithObject:designDescriptor];
            
            NSDictionary *dictionaryOfViews =  [designDoc views];
            for(SBCouchView *viewName in dictionaryOfViews){
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
    }        
}

-(BOOL)fetchReturnedData{
    return fetchReturnedData;
}
@end
