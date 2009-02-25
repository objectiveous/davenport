//
//  NSTreeNode+SVDavenport.m
//  
//
//  Created by Robert Evans on 12/27/08.
//  Copyright 2008 South And Valley. All rights reserved.
//

#import "NSTreeNode+SVDavenport.h"
#import "SVJSONDescriptor.h"
#import "SVBaseNavigationDescriptor.h"
#import "DPContributionNavigationDescriptor.h"

@interface  NSTreeNode (Private)

-(NSDictionary*)convertJSONObjectToDictionary:(NSTreeNode*)treeNode;
-(NSArray*)convertJSONArrayToDictionary:(NSTreeNode*)treeNode;


@end

@implementation NSTreeNode (SVDavenport)

-(NSTreeNode *) addCouchServerSection:(NSString *)sectionName{
    SVBaseNavigationDescriptor *section = [[[SVBaseNavigationDescriptor alloc] initWithLabel:sectionName andIdentity:sectionName type:DPDescriptorCouchServer] autorelease];
    [section setGroupItem:YES];
    return [self addChildNodeWithObject:section]; 
}

-(NSTreeNode *) addSection:(NSString *)sectionName{
    SVBaseNavigationDescriptor *section = [[[SVBaseNavigationDescriptor alloc] initWithLabel:sectionName andIdentity:sectionName type:DPDescriptorSection] autorelease];
    [section setGroupItem:YES];
    return [self addChildNodeWithObject:section];    
}

-(NSTreeNode *) addDatabase:(NSString *)databaseName{
    SVBaseNavigationDescriptor *database = [[[SVBaseNavigationDescriptor alloc] initWithLabel:databaseName andIdentity:databaseName type:DPDescriptorCouchDatabase] autorelease];
    return [self addChildNodeWithObject:database];
}

-(NSTreeNode *) addChildNodeWithObject:(id)object{
    NSTreeNode *node = [[[NSTreeNode alloc] initWithRepresentedObject:object] autorelease];
    [[self mutableChildNodes] addObject:node];
    return node;
}

-(NSDictionary *)asDictionary{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:[[self childNodes] count]];
    
    for(NSTreeNode *node in [self childNodes]){
        SVJSONDescriptor *jsonDesc = [node representedObject];

        if(jsonDesc.jsonType == JSON_TYPE_OBJECT){
            NSDictionary *childDictionary = [self convertJSONObjectToDictionary:node];
            [dict setObject:childDictionary forKey:jsonDesc.label];
        }else if(jsonDesc.jsonType == JSON_TYPE_ARRAY){
            
        }else if(jsonDesc.jsonType == JSON_TYPE_SCALAR){
            [dict setObject:[jsonDesc value] forKey:[jsonDesc label]];
        }
    }    
    return dict;
}

-(NSDictionary*)convertJSONObjectToDictionary:(NSTreeNode*)treeNode{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:[[treeNode childNodes] count]];

    for(NSTreeNode *node in [treeNode childNodes]){
        SVJSONDescriptor *jsonDesc = [node representedObject];
        
        if(jsonDesc.jsonType == JSON_TYPE_OBJECT){
            NSDictionary *childDictionary = [treeNode convertJSONObjectToDictionary:node];
            [dict setObject:childDictionary forKey:[jsonDesc label]];
        }else if(jsonDesc.jsonType == JSON_TYPE_ARRAY){
            NSArray *childArray = [treeNode convertJSONArrayToDictionary:node];
            [dict setObject:childArray forKey:jsonDesc.label];
        }else if(jsonDesc.jsonType == JSON_TYPE_SCALAR){
            [dict setObject:[jsonDesc value] forKey:jsonDesc.label];
        }                
    }    
    return dict;
}


-(NSArray*)convertJSONArrayToDictionary:(NSTreeNode*)treeNode{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[[treeNode childNodes] count]];
    
    for(NSTreeNode *node in [treeNode childNodes]){
        SVJSONDescriptor *jsonDesc = [node representedObject];
                
        if(jsonDesc.jsonType == JSON_TYPE_OBJECT){
            NSDictionary *childDictionary = [treeNode convertJSONObjectToDictionary:node];
            [array insertObject:childDictionary atIndex:[jsonDesc.label integerValue]];
        }else if(jsonDesc.jsonType == JSON_TYPE_ARRAY){
            NSArray *childArray = [treeNode convertJSONArrayToDictionary:node];
            [array insertObject:childArray atIndex:[jsonDesc.label integerValue]];
        }else if(jsonDesc.jsonType == JSON_TYPE_SCALAR){
            [array insertObject:jsonDesc.value atIndex:[jsonDesc.label integerValue]];
        }                
    }    
    return array;
    
}

#pragma mark - 
#pragma mark Descriptor Magic

-(NSString*) deriveDatabaseName{    
    id <DPContributionNavigationDescriptor> desc = [self representedObject];
    if([desc type] == DPDescriptorCouchDatabase){
        return [desc identity];    
    }else{
        return [[self parentNode] deriveDatabaseName];
    }
}

 
-(NSString*) deriveDesignDocumentPath{
    SVBaseNavigationDescriptor *desc = [self representedObject];
    if(desc.type == DPDescriptorCouchView){
        //NSMutableString *viewPathPart = [NSMutableString stringWithString:desc.identity];
        SVBaseNavigationDescriptor *designDesc = [[self parentNode] representedObject];
        NSMutableString *urlPath = [NSMutableString stringWithFormat:@"_design/%@",designDesc.label];
        return urlPath;
    }    
        
    return nil;    
}

-(NSString*) deriveDocumentIdentity{
    id <DPContributionNavigationDescriptor> desc = [self representedObject];
    if([desc type] == DPDescriptorCouchView){ 
        NSMutableString *viewPathPart = [NSMutableString stringWithString:[desc identity]];
        // The parent of a view is a design doc. 
        id <DPContributionNavigationDescriptor> designDesc = [[self parentNode] representedObject];
        
        // sofa-blog/_view/datacenter/hardware
        // database/_view/domain/view
        NSMutableString *urlPath = [NSMutableString stringWithFormat:@"_view/%@/%@",[designDesc label],viewPathPart];        
        return urlPath;       
    }else if([desc type] == DPDescriptorCouchDatabase){
        return @"_all_docs";
    }else{        
        return [desc identity];
    }
    
}


-(void)logTree{
    NSLog(@"%@", [self prettyPrint]);
    
    for(NSTreeNode *node in [self childNodes]){
        [node prettyPrint];
        [node logTree];
    }
    
}

-(NSString*) prettyPrint{    
    id object = [self representedObject];
    if(object == NULL){
        NSString *plainDescription = [super description];
        return [NSString stringWithFormat:@"No represented Object (root) : %@", plainDescription];
    }
        
    
    if([object conformsToProtocol:@protocol(DPContributionNavigationDescriptor)])
        return [object label];
    
    if([object isKindOfClass:[SVBaseNavigationDescriptor class]])
        return [object label];
    
    return @"No idea what this tree node is";
}

@end
