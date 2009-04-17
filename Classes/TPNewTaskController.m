//
//  TPNewTaskController.m
//  Davenport
//
//  Created by Robert Evans on 4/15/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import "TPNewTaskController.h"
#import <CouchObjC/CouchObjC.h>

@implementation TPNewTaskController

@synthesize taskForm;
@synthesize treeNode;


-(id) initWithNibName:(NSString*)nibName bundle:(NSBundle*)bundle treeNode:(NSTreeNode*)aTreeNode{
    self = [super initWithNibName:nibName bundle:bundle];
    if(self){
        self.treeNode = aTreeNode;
    }
    return self;
}


- (void)awakeFromNib{
	//[self.view setNextResponder:[[self.view window] nextResponder]];
	//[[self.view window] setNextResponder:self.view];
}

#pragma mark -
-(void) cancelAction:(id)sender{
    NSLog(@"Okay");
}
-(void) createAction:(id)sender{
    NSMutableDictionary *taskDocument = [NSMutableDictionary dictionaryWithCapacity:2];
    for(id cell in [taskForm cells]){
        NSLog(@"%@ %@", [[cell title] lowercaseString],  [cell stringValue]);
        [taskDocument setObject:[cell stringValue] forKey:[[cell title] lowercaseString]];
    }
    SBCouchDatabase *couchDatabase = [self.treeNode couchDatabase];

    SBCouchResponse *response = [couchDatabase postDocument:taskDocument];
}
@end
