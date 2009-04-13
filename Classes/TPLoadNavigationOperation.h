//
//  TPLoadNavigationOperation.h
//  Davenport
//
//  Created by Robert Evans on 2/22/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DPResourceFactory;

/*!
 * @class       TPLoadNavigationOperation
 * @abstract    xxx
 * @discussion  xxxxxxxxxxx xxxxxxxxxxxx xxxxxxxxxxxxxxx xxxxxxxxxx xxxxxxx
 *              xxxxxxxxxxx xxxxxxxxxxxx xxxxxxxxxxxxxxx xxxxxxxxxx xxxxxxx
 *              xxxxxxxxxxx xxxxxxxxxxxx xxxxxxxxxxxxxxx xxxxxxxxxx xxxxxxx
 *              xxxxxxxxxxx xxxxxxxxxxxx xxxxxxxxxxxxxxx xxxxxxxxxx xxxxxxx
 *
 */
@interface TPLoadNavigationOperation : NSOperation{
    NSTreeNode *rootContributionNode;
    id <DPResourceFactory> resourceFactory;
}

@property (retain) NSTreeNode* rootContributionNode;
@property (retain) <DPResourceFactory> resourceFactory;

-(id)initWithResourceFactory:(id <DPResourceFactory>)resourceFactory;
@end
