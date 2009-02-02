//
//  JsonTest.m
//  
//
//  Created by Robert Evans on 1/19/09.
//  Copyright 2009 South And Valley. All rights reserved.
//



#import "GTMSenTestCase.h"
#import "SVDavenport.h"
#import <CouchObjC/CouchObjC.h>
#import <JSON/JSON.h>
#import "NSDictionary+SVDavenport.h"
#import "SVJSONDescriptor.h"
@interface SVJsonTest : SenTestCase{
    NSMutableDictionary *dictionary;
    NSTreeNode          *rootNode;
    NSMutableString     *spacer;
}
-(void) prettyPrint:(NSTreeNode*)treeNode;
@end

@implementation SVJsonTest

-(void)testArraySupport{
    SVDebug(@"------------------------------------------------- BEGIN");

    NSArray *array = [NSArray arrayWithObjects:@"objective-c", @"java", @"perl", nil];
    [dictionary setObject:array forKey:@"List of languages"];
    NSTreeNode *node = [dictionary asNSTreeNode];
    [self prettyPrint:node];
    SVDebug(@"------------------------------------------------- END");
}

-(void)estHashSupport{
    SVDebug(@"------------------------------------------------- BEGIN");
    NSMutableDictionary *peopleDictionary = [[NSMutableDictionary alloc] init];
    [peopleDictionary setObject:@"24" forKey:@"Robert"];
    [peopleDictionary setObject:@"38" forKey:@"Julia"];
    [peopleDictionary setObject:@"65" forKey:@"Cher"];
    [dictionary setObject:peopleDictionary forKey:@"People"];    

    NSMutableDictionary *petsDictionary = [[NSMutableDictionary alloc] init];
    [petsDictionary setObject:@"dog" forKey:@"Mac"];
    [petsDictionary setObject:@"cat" forKey:@"Louie"];
    [petsDictionary setObject:@"Not sure" forKey:@"Max"];
    [dictionary setObject:petsDictionary forKey:@"Pets"]; 

    NSMutableDictionary *otherDictionary = [[NSMutableDictionary alloc] init];
    [otherDictionary setObject:@"You are on commision" forKey:@"Sales"];
    [otherDictionary setObject:@"You are build things" forKey:@"Engineering"];
    [otherDictionary setObject:@"You spend money"      forKey:@"Management"];
    [petsDictionary  setObject:otherDictionary forKey:@"Other Stuff"]; 
    
    NSTreeNode *node = [dictionary asNSTreeNode];

    // I had some assertions but I ripped them out and check the value by eye. 
    // Bad I know... Technical debt. 
    [self prettyPrint:node];
            
    [peopleDictionary release];
    SVDebug(@"------------------------------------------------- END");
}

-(void) prettyPrint:(NSTreeNode*)treeNode{
    
    if([treeNode parentNode] != nil){
        SVJSONDescriptor *descriptor = [treeNode representedObject];        
        if(! descriptor.jsonType == JSON_TYPE_OBJECT){
            //SVDebug(@"%@ key [%@] : value [%@]", spacer, descriptor.label, descriptor.value);        
        }            
    }
    
    for(id grandChild in [treeNode childNodes]){
        SVJSONDescriptor *childDescriptor = [grandChild representedObject];               
         SVDebug(@"-->%@ key [%@] : value [%@]", spacer, childDescriptor.label, childDescriptor.value);
        if(childDescriptor.jsonType == JSON_TYPE_OBJECT){
            [spacer appendString:@"     "];
            [self prettyPrint:grandChild];
            [spacer deleteCharactersInRange:NSMakeRange(0, 5)];
        }else if(childDescriptor.jsonType == JSON_TYPE_ARRAY){
            [spacer appendString:@"     "];
            [self prettyPrint:grandChild];
            [spacer deleteCharactersInRange:NSMakeRange(0, 5)];
        }
    }
}

- (void)estJsonToTreeNodeHasKeysAndValue{   
    //NSTreeNode *rootNode = [dictionary asNSTreeNode];
    STAssertNotNil(rootNode, @"NSDictionary not returning");
    
    STAssertNotNil([rootNode childNodes], @"RootNode is missing children");
    STAssertTrue( [[rootNode childNodes] count] == 1, @"Missing children");
    
    for(NSTreeNode *child in [rootNode childNodes]){
        STAssertTrue([[child representedObject] isKindOfClass:[SVJSONDescriptor class]], @"TreeNode is holding the wrong type of object");
        SVJSONDescriptor *descriptor = [child representedObject];

        STAssertTrue( [[dictionary allKeys] containsObject:[descriptor label]], @"Missing label" );
        STAssertTrue( [[dictionary allValues] containsObject:[descriptor value]], @"Missing value");     
    }
    
}

#pragma mark -
-(void)setUp{
    spacer = [NSMutableString stringWithString:@" "];
    dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:@"I give it a big bunch of Fail. " forKey:@"Top Level Key A"];    
    [dictionary setObject:@"I give it a big bunch of Fail. " forKey:@"Top Level Key B"];    
    [dictionary setObject:@"I give it a big bunch of Fail. " forKey:@"Top Level Key C"];    
    [dictionary setObject:@"I give it a big bunch of Fail. " forKey:@"Top Level Key D"];    
    NSString *json =[dictionary JSONRepresentation];
    STAssertNotNil(json, nil);
    //rootNode = [dictionary asNSTreeNode];
    //[rootNode retain];
}

-(void)tearDown{
    [dictionary release];
    //[rootNode release];
}

@end
