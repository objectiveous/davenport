//
//  SVRefreshCouchServerNodeOperation.h
//  Davenport
//
//  Created by Robert Evans on 4/2/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SVAbstractCouchNodeOperation.h"

@interface SVRefreshCouchServerNodeOperation : SVAbstractCouchNodeOperation{

}

-(id) initWithCouchServerTreeNode:(NSTreeNode*)databaseTreeNode indexPath:(NSIndexPath*)indexPath;

@end
