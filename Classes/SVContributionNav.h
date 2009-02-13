//
//  SVContributionNav.h
//  Davenport
//
//  Created by Robert Evans on 2/13/09.
//  Copyright 2009 South And Valley. All rights reserved.
//



@protocol SVContributionNav

// Return an empty root who's children will be added to the NSOutlineView that makes 
// up the left-hand nav of davenport. The root node is said to be "empty" when it has 
// no represented object. All child nodes MUST contain represented objects that conform 
// to the XXX protocol. 
// 
// Returning nil is also allowed. 

-(NSTreeNode*)navigationContribution;

@end
