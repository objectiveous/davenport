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
    while(designDoc =  [designDocs nextObject]){        
        //XXX descriptor type needs to come from an enum
        NSTreeNode *designDocNode = [pluginSectionNode addChildWithLabel:[designDoc.identity lastPathComponent] 
                                                                identity:designDoc.identity 
                                                          descriptorType:DPDescriptorPluginProvided
                                                         resourceFactory:self.resourceFactory
                                                                   group:NO];
        
        [(TPBaseDescriptor*)[designDocNode representedObject] setCouchDatabase:database];
        [(TPBaseDescriptor*)[designDocNode representedObject] setPrivateType:DPDescriptorCouchDesign];

        
        //NSLog(@"XXXXX %@", test);

        SBCouchDesignDocument *designDocWithViews = [database getDesignDocument:[designDoc identity]];
        // VIEWS
        for(NSString *viewName in [[designDocWithViews views] allKeys]){
            NSTreeNode *childNode = [designDocNode addChildWithLabel:viewName identity:viewName descriptorType:DPDescriptorPluginProvided  
                                                     resourceFactory:self.resourceFactory group:NO];        

            [(TPBaseDescriptor*)[childNode representedObject] setCouchDatabase:database];
            [(TPBaseDescriptor*)[childNode representedObject] setPrivateType:DPDescriptorCouchView];
        }         
    }
}

@end
