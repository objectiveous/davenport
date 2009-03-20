//
//  TPLoadNavigationOperation.m
//  Davenport
//
//  Created by Robert Evans on 2/22/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import "TPLoadNavigationOperation.h"
#import "TPPlugin.h"
#import "NSTreeNode+TP.h"
#import "NSTreeNode+SVDavenport.h"
#import <CouchObjC/CouchObjC.h>
#import "TPBaseDescriptor.h"

@implementation TPLoadNavigationOperation
@synthesize rootContributionNode;
@synthesize resourceFactory;

-(id)initWithResourceFactory:(id <DPResourceFactory>)rezFactory{
    if (![super init]) return nil;    
    rootContributionNode = [[NSTreeNode alloc] init];
    self.resourceFactory = rezFactory;
    return self;
}

-(void)dealloc{
    [rootContributionNode release];
    [super dealloc];    
}

-(void) main{
    // Using localhost and default port
    SBCouchServer *server = [SBCouchServer new];
    SBCouchDatabase *database = [server database:[TPPlugin databaseName]];
    NSEnumerator *designDocs = [database getDesignDocuments];
 
    // XXX The child node label should be discovered, not hardcoded. 
    NSTreeNode *pluginSectionNode = [rootContributionNode addChildWithLabel:@"Cushion Tickets" 
                                                                   identity:@"cushion-tickets"
                                                             descriptorType:DPDescriptorSection 
                                                            resourceFactory:self.resourceFactory
                                                                      group:YES];
    
    
    
    SBCouchDocument *designDoc;
    while(designDoc = [designDocs nextObject]){        
        //NSLog(@"----------> %@", designDoc);
        //XXX descriptor type needs to come from an enum
        NSTreeNode *designDocNode = [pluginSectionNode addChildWithLabel:[designDoc.identity lastPathComponent] 
                                                                identity:designDoc.identity 
                                                          descriptorType:DPDescriptorPluginProvided
                                                         resourceFactory:self.resourceFactory
                                                                   group:NO];
        
        [(TPBaseDescriptor*)[designDocNode representedObject] setCouchDatabase:database];
        [(TPBaseDescriptor*)[designDocNode representedObject] setPrivateType:DPDescriptorCouchDesign];

        
        //NSLog(@"XXXXX %@", test);
        NSString *designDocIdentity = [designDoc identity];
        //NSLog(@"designDoc Identity : %@", designDocIdentity);
        SBCouchDesignDocument *designDocWithViews = [database getDesignDocument:designDocIdentity];
        // VIEWS
        for(NSString *viewName in [[designDocWithViews views] allKeys]){
            NSString *viewIdentity = [NSString stringWithFormat:@"_view/%@/%@", [designDocIdentity lastPathComponent], viewName];
           
            // http://localhost:5984/cushion-tickets/_view/More%20Stuff/sprint?limit=30&group=true
            NSTreeNode *childNode = [designDocNode addChildWithLabel:viewName 
                                                            identity:viewIdentity
                                                      descriptorType:DPDescriptorPluginProvided  
                                                     resourceFactory:self.resourceFactory];        

            [(TPBaseDescriptor*)[childNode representedObject] setCouchDatabase:database];
            [(TPBaseDescriptor*)[childNode representedObject] setPrivateType:DPDescriptorCouchView];
        }         
    }
}

@end
