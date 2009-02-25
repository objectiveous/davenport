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

@implementation TPLoadNavigationOperation
@synthesize rootContributionNode;

-(id)init{
    if (![super init]) return nil;    
    rootContributionNode = [[NSTreeNode alloc] init];
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
    NSTreeNode *pluginSectionNode = [rootContributionNode addChildWithLabel:@"Cushion Tickets" identity:@"cushion-tickets"
                             descriptorType:DPDescriptorSection group:YES];
    
    SBCouchDesignDocument *designDoc;
    while(designDoc = [designDocs nextObject]){        
        //XXX descriptor type needs to come from an enum
        [pluginSectionNode addChildWithLabel:[designDoc.identity lastPathComponent] 
                                    identity:designDoc.identity 
                              descriptorType:DPDescriptorPluginProvided
                                       group:NO];
        }    
}

-(NSString*)what{
    return @"xxxxxxxxx";
}
@end
