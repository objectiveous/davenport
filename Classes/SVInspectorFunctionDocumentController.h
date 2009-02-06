//
//  SVFunctionEditorController.h
//  
//
//  Created by Robert Evans on 1/18/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SVInspectorFunctionDocumentController.h"

@interface SVInspectorFunctionDocumentController : NSViewController {

    IBOutlet NSTextView *mapTextView;
    IBOutlet NSTextView *reduceTextView;        
}
@property (nonatomic, retain) NSTextView *mapTextView;
@property (nonatomic, retain) NSTextView *reduceTextView;

@end
