//
//  SVKeyBindingsResponder.h
//  Davenport
//
//  Created by Robert Evans on 4/18/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DPKeyBindingManager.h"

@interface SVKeyBindingsResponder : NSResponder  <DPKeyBindingManager>{
    IBOutlet NSWindow   *window;
    NSMutableDictionary *controlBindings;
}
@property (nonatomic, retain) NSWindow            *window;
@property (retain)            NSMutableDictionary *controlBindings;

-(void)registerBindingForKey:(NSString*)character invocation:(NSInvocation*)invocation;
-(void)registerBindingForKey:(NSString*)character target:(id) target selector:(SEL)selector;
+ (SVKeyBindingsResponder*)sharedManager;
@end
