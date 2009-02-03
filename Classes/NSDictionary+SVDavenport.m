//
//  NSDictionary+SVDavenport.m
//  Davenport
//
//  Created by Robert Evans on 2/1/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import "NSDictionary+SVDavenport.h"
#import "SVJSONDescriptor.h"

@implementation NSDictionary (SVDavenport)

-(NSTreeNode *)asNSTreeNode{
    NSTreeNode *rootNode = [[[NSTreeNode alloc] init] autorelease];
    
    // Add the top Most keys. 
    for(NSString *key in [self allKeys]){
        id someValue = [self objectForKey:key];
        //SVDebug(@"KEY/VALUE        ::        %@/%@", key, ourHashValue);
        
        if([someValue isKindOfClass:[NSDictionary class]]){
            NSTreeNode *convertedHash = [someValue convertHash:someValue forKey:key];
            [[rootNode mutableChildNodes] addObject:convertedHash];            
        }else if([someValue isKindOfClass:[NSArray class]]){
            NSTreeNode *convertedHash = [self convertArray:someValue forKey:key];            
            [[rootNode mutableChildNodes] addObject:convertedHash];  
        }else{                    
            SVJSONDescriptor *jsonDescriptor = [[[SVJSONDescriptor alloc] init] autorelease];
            [jsonDescriptor setLabel:key];
            [jsonDescriptor setValue:[self objectForKey:key]];      
            [jsonDescriptor setJsonType:JSON_TYPE_SCALAR];      
            
            NSTreeNode *childNode = [NSTreeNode treeNodeWithRepresentedObject:jsonDescriptor];
            [[rootNode mutableChildNodes] addObject:childNode];
        }
    }    
    return rootNode;
}


-(NSTreeNode*)convertHash:(NSDictionary*)dictionary forKey:(NSString*)keyName{
    NSTreeNode *rootNode = [[[NSTreeNode alloc] init] autorelease];
    
    SVJSONDescriptor *rootDescriptor = [[[SVJSONDescriptor alloc] init] autorelease];
    [rootDescriptor setLabel:keyName];
    [rootDescriptor setValue:[NSString stringWithFormat:@"%i key/value Pairs", [[dictionary allKeys] count] ]];
    [rootDescriptor setJsonType:JSON_TYPE_OBJECT];
    [rootNode initWithRepresentedObject:rootDescriptor];
    
    // Add the top Most keys. 
    for(id key in [dictionary allKeys]){
        //SVDebug(@"key %@", key);
        id someValue = [dictionary objectForKey:key];
        
        if([someValue isKindOfClass:[NSDictionary class]]){
            NSTreeNode *convertedHash = [someValue convertHash:someValue forKey:key];            
            [[rootNode mutableChildNodes] addObject:convertedHash];            
        }else if([someValue isKindOfClass:[NSArray class]]){
            NSTreeNode *convertedHash = [self convertArray:someValue forKey:key];            
            [[rootNode mutableChildNodes] addObject:convertedHash];  
        }else{                    
            SVJSONDescriptor *jsonDescriptor = [[[SVJSONDescriptor alloc] init] autorelease];
            [jsonDescriptor setLabel:key];
            [jsonDescriptor setValue:[dictionary objectForKey:key]];
            [jsonDescriptor setJsonType:JSON_TYPE_SCALAR]; 
            NSTreeNode *childNode = [NSTreeNode treeNodeWithRepresentedObject:jsonDescriptor];
            
            [[rootNode mutableChildNodes] addObject:childNode];
        }
    }
    return rootNode;
}

-(NSTreeNode*)convertArray:(NSArray*)array forKey:(NSString*)keyName{
    NSTreeNode *rootNode = [[[NSTreeNode alloc] init] autorelease];
    
    SVJSONDescriptor *rootDescriptor = [[[SVJSONDescriptor alloc] init] autorelease];
    [rootDescriptor setLabel:keyName];
    [rootDescriptor setValue:[NSString stringWithFormat:@"Array count %i ", [array count] ]];
    [rootDescriptor setJsonType:JSON_TYPE_ARRAY];
    [rootNode initWithRepresentedObject:rootDescriptor];

    // Process each elment in the array 
    for(id element in array){
        if([element isKindOfClass:[NSDictionary class]]){
            NSTreeNode *convertedHash = [element convertHash:element forKey:[NSString stringWithFormat:@"%i", [array indexOfObject:element]]];  
            [[rootNode mutableChildNodes] addObject:convertedHash];         
            
        }else if([element isKindOfClass:[NSArray class]]){        
            NSTreeNode *convertedArray = [self convertArray:element forKey:[NSString stringWithFormat:@"%i", [array indexOfObject:element]]];  
            [[rootNode mutableChildNodes] addObject:convertedArray]; 
        }else{
            SVJSONDescriptor *jsonDescriptor = [[[SVJSONDescriptor alloc] init] autorelease];
            [jsonDescriptor setLabel:[NSString stringWithFormat:@"%i", [array indexOfObject:element]]];
            [jsonDescriptor setValue:element];       
            [jsonDescriptor setJsonType:JSON_TYPE_SCALAR];       
            
            NSTreeNode *childNode = [NSTreeNode treeNodeWithRepresentedObject:jsonDescriptor];
            [[rootNode mutableChildNodes] addObject:childNode];
        }               
    }
    return rootNode;
}

@end
