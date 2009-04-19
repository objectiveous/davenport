//
//  SVKeyBindingsResponder.m
//  Davenport
//
//  Created by Robert Evans on 4/18/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import "SVKeyBindingsResponder.h"


@implementation SVKeyBindingsResponder
@synthesize window;
@synthesize controlBindings;

static SVKeyBindingsResponder *sharedKeyBindingsResponderManager = nil;

+ (SVKeyBindingsResponder*)sharedManager{
    @synchronized(self) {
        if (sharedKeyBindingsResponderManager == nil) {
            [[self alloc] init];
        }
    }
    return sharedKeyBindingsResponderManager;
}

+ (id)allocWithZone:(NSZone *)zone{
    @synchronized(self) {
        if (sharedKeyBindingsResponderManager == nil) {
            return [super allocWithZone:zone];
        }
    }
    return sharedKeyBindingsResponderManager;
}

- (id)init{
    Class myClass = [self class];
    @synchronized(myClass) {
        if (sharedKeyBindingsResponderManager == nil) {
            if (self = [super init]) {
                sharedKeyBindingsResponderManager = self;
                // custom initialization here
            }
        }
    }
    return sharedKeyBindingsResponderManager;
}

- (id)copyWithZone:(NSZone *)zone { return self; }

- (id)retain { return self; }

- (unsigned)retainCount { return UINT_MAX; }

- (void)release {}

- (id)autorelease { return self; }



// ------------------------------

-(void)registerBindingForKey:(NSString*)character target:(id) target selector:(SEL)selector{

    
    NSMethodSignature *sig = [[target class] instanceMethodSignatureForSelector:selector];    
    NSInvocation *myInvocation = [NSInvocation invocationWithMethodSignature:sig];
    [myInvocation setTarget:target];
    [myInvocation setSelector:selector];
    
    //SVKeyBindingsResponder *keyBindings = [SVKeyBindingsResponder sharedManager];    
    [self registerBindingForKey:character invocation:myInvocation];
}

-(void)registerBindingForKey:(NSString*)character invocation:(NSInvocation*)invocation{
    [self.controlBindings setObject:invocation forKey:character];
}

- (void)awakeFromNib{
    [window setNextResponder:self];
    self.controlBindings = [NSMutableDictionary dictionaryWithCapacity:20];
}

-(void)dealloc{
    self.controlBindings = nil;
    [super dealloc];
}

- (void)keyDown:(NSEvent *)theEvent{
    NSUInteger modifierFlags = [theEvent modifierFlags];
        
    if(modifierFlags & NSControlKeyMask){
        NSString *character = [theEvent charactersIgnoringModifiers];
        NSInvocation *boundAction = [self.controlBindings objectForKey:character];
        
        if(boundAction){
            [boundAction invoke];
        }
    }else{
        [self interpretKeyEvents:[NSArray arrayWithObject:theEvent]];        
    }    
}

@end
