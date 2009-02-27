//
//  TPLoadNavigationOperation.h
//  Davenport
//
//  Created by Robert Evans on 2/22/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DPResourceFactory.h"

@interface TPLoadNavigationOperation : NSOperation{
    NSTreeNode *rootContributionNode;
    id <DPResourceFactory> resourceFactory;
}

@property (retain) NSTreeNode* rootContributionNode;
@property (retain) <DPResourceFactory> resourceFactory;

-(id)initWithResourceFactory:(id <DPResourceFactory>)resourceFactory;
@end
