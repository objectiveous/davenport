//
//  NSTreeNode+TP.m
//  Davenport
//
//  Created by Robert Evans on 2/14/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import "NSTreeNode+TP.h"
#import "TPBaseDescriptor.h"
#import "TPPlugin.h"

@implementation NSTreeNode(TP)

+(NSTreeNode*)nodeWithLabel:(NSString*)alabel identity:(NSString*)anIdentity descriptorType:(NSString*)aType group:(BOOL)isGroup{
    TPBaseDescriptor *descriptor = [[[TPBaseDescriptor alloc] initWithPluginID:[TPPlugin pluginID]
                                                                         label:alabel 
                                                                      identity:anIdentity
                                                                descriptorType:aType
                                                                         group:isGroup] autorelease];
    
     return [NSTreeNode treeNodeWithRepresentedObject:descriptor];
}


-(NSTreeNode*)addChildWithLabel:(NSString*)alabel identity:(NSString*)anIdentity descriptorType:(NSString*)aType group:(BOOL)isGroup{
    TPBaseDescriptor *descriptor = [[[TPBaseDescriptor alloc] initWithPluginID:[TPPlugin pluginID]
                                                                         label:alabel 
                                                                      identity:anIdentity
                                                                descriptorType:aType                                    
                                                                         group:isGroup] autorelease];
        
    
    NSTreeNode *node = [NSTreeNode treeNodeWithRepresentedObject:descriptor];
    
    [[self mutableChildNodes] addObject:node];
    return node;
}

-(NSTreeNode*)addChildWithLabel:(NSString*)alabel identity:(NSString*)anIdentity descriptorType:(NSString*)aType{
    return [self addChildWithLabel:alabel identity:anIdentity descriptorType:aType group:NO];
}



@end
