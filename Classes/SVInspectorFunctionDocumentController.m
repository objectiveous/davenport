//
//  SVFunctionEditorController.m
// 
//
//  Created by Robert Evans on 1/18/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import "SVInspectorFunctionDocumentController.h"


@implementation SVInspectorFunctionDocumentController

@synthesize mapTextView;
@synthesize reduceTextView;

#pragma mark -
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil databaseName:(NSString *)dbName{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        //[self setDatabaseName:dbName];
    }
  
    return self;
}


@end
