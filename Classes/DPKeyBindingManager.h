//
//  DPKeyBindingManager.h
//  Davenport
//
//  Created by Robert Evans on 4/19/09.
//  Copyright 2009 South And Valley. All rights reserved.
//



@protocol DPKeyBindingManager

-(void)registerBindingForKey:(NSString*)character invocation:(NSInvocation*)invocation;
-(void)registerBindingForKey:(NSString*)character target:(id) target selector:(SEL)selector;

@end
