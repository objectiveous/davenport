#import "GTMSenTestCase.h"
#import "SVAbstractIntegrationTest.h"
#import "SVDavenport.h"
#import "NSDictionary+SVDavenport.h"
#import "NSTreeNode+SVDavenport.h"
#import <CouchObjC/CouchObjC.h>

@interface SVCouchDocumentTreeNodeTest : SVAbstractIntegrationTest{
}
@end


@implementation SVCouchDocumentTreeNodeTest

-(void)testXXX{
    //asl_set_filter(NULL, ASL_FILTER_MASK_UPTO(ASL_LEVEL_DEBUG) );
    NSLog(@" START WTF WTF");
    SVDebug(@"WTF");
    NSLog(@" END WTF WTF");
    SBCouchDatabase *couchDatabase = [couchServer database:@"sofa-blog"];

    NSEnumerator *resultSet = [couchDatabase allDocsInBatchesOf:10];
    NSDictionary *document;
    while ((document = [resultSet nextObject])) {
        SVDebug(@"--> %@", document);
        
        NSString *documentIdentity = [document objectForKey:@"id"];
        
       SBCouchDocument *couchDocument = [couchDatabase getDocument:documentIdentity 
                                                 withRevisionCount:YES 
                                                           andInfo:YES 
                                                          revision:nil];
        SVDebug(@"CouchDocument %@", couchDocument);
        NSTreeNode *rootNode = [couchDocument asNSTreeNode];
        STAssertNotNil(rootNode, nil);
        NSDictionary *dict = [rootNode asDictionary];
        STAssertNotNil(dict, nil);
        SVDebug(@"DICT DUMP %@", dict);
        SVDebug(@"JSON DUMP %@", [dict JSONFragment]);
    }   
}

@end
