#import "GTMSenTestCase.h"
#import "SVMainWindowController.h"
#import "SVAppDelegate.h"
#import "STIG.h"

@interface SVLoadDataAtStartupTest : SenTestCase {
     BOOL fetchFinishedIVar;    
  }
-(void) wait;
@end


@implementation SVLoadDataAtStartupTest
static NSTimeInterval kGiveUpInterval = 5.0;
static NSTimeInterval kRunLoopInterval = 0.01;


-(void)estLoadData{

    SVAppDelegate *appDelegate = [[SVAppDelegate alloc] init];
    [appDelegate loadMainWindow];
    
    NSTreeNode *rootNode =   [[appDelegate mainWindowController] rootNode];
    [self wait];    
        
    STAssertNotNil(rootNode, @"Main Window Controller not getting provisioned.");
    
    NSTreeNode *databasesNode = [rootNode descendantNodeAtIndexPath:[NSIndexPath indexPathWithIndex:0.0]];
    STAssertNotNil(databasesNode, @"NSIndexPath failed to return database");
    STIGDebug(@"Searched for node [%@] ", databasesNode);
    
    BOOL PASS = NO;
    // Can NSPredicates help here? 
    for(NSTreeNode *database in [databasesNode childNodes]){
        if([[[database representedObject] label] isEqual:@"test_suite_db"] ){
            PASS = YES;
            STIGDebug(@"Searched for and found test database [%@] ", [[database representedObject] label]);
        }
            
    }
    
    STAssertTrue(PASS, @"Failed to find test_suite_db in server fetch results");
    
    [appDelegate release], appDelegate = nil;
}


-(void) wait{
    STIGDebug(@"***** WAITING ");
    // Wait until we get the databack 
    NSDate* giveUpDate = [NSDate dateWithTimeIntervalSinceNow:kGiveUpInterval];
    fetchFinishedIVar = NO;
    while (!fetchFinishedIVar && [giveUpDate timeIntervalSinceNow] > 0) {
        NSDate* loopIntervalDate = [NSDate dateWithTimeIntervalSinceNow:kRunLoopInterval];
        [[NSRunLoop currentRunLoop] runUntilDate:loopIntervalDate];
    }     
    
     STIGDebug(@"***** DONE WAITING ");
}

@end
