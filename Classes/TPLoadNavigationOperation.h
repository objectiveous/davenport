//
//  TPLoadNavigationOperation.h
//  Davenport
//
//  Created by Robert Evans on 2/22/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface TPLoadNavigationOperation : NSOperation{
    NSTreeNode *rootContributionNode;
}

@property (retain) NSTreeNode* rootContributionNode;

-(NSString*)what;
@end
