//
//  TPNewTaskController.h
//  Davenport
//
//  Created by Robert Evans on 4/15/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface TPNewTaskController : NSViewController {
    IBOutlet NSForm     *taskForm;
             NSTreeNode *treeNode;
}

@property (nonatomic, retain) NSForm *taskForm;
@property (nonatomic, retain) NSTreeNode *treeNode;

-(id) initWithNibName:(NSString*)nibName bundle:(NSBundle*)bundle treeNode:(NSTreeNode*)aTreeNode;


-(void) cancelAction:(id)sender;
-(void) createAction:(id)sender;
@end
