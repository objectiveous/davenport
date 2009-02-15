//
//  SVAppDelegate.m
//  
//
//  Created by Robert Evans on 12/29/08.
//  Copyright 2008 South And Valley. All rights reserved.
//

#import "SVAppDelegate.h"
#import "SVMainWindowController.h"
#import "SVFetchServerInfoOperation.h"
#import "SVPluginContributionLoader.h"
#import "DPContributionPlugin.h"

@interface SVAppDelegate (Private)
-(void)taskTerminated:(NSNotification *)note;
-(void)launchCouchDB;
-(void)appendData:(NSData *)data;
-(void)cleanup;
@end


@implementation SVAppDelegate

int LOCAL_PORT = 5984;
@synthesize mainWindowController;
@synthesize couchServer;
@synthesize pluginRegistry;

- (id)init{
    // This is used to control how verbose logging is. 
    asl_set_filter(NULL, ASL_FILTER_MASK_UPTO(ASL_LEVEL_DEBUG) );
    
    if (![super init]) return nil;
    
    queue = [[NSOperationQueue alloc] init];
    lock = [[NSLock alloc] init];
    self.pluginRegistry = [[NSMutableDictionary alloc] init];
    [self setCouchServer:[[SBCouchServer alloc] initWithHost:@"localhost" port:LOCAL_PORT]];
    return self;
}
- (void)dealloc{
    [queue release], queue = nil;
    [lock release], lock = nil;
    [couchServer release], couchServer = nil;
    [pluginRegistry release], pluginRegistry = nil;
    [super dealloc];
}

- (void) performFetchServerInfoOperation {
    SVDebug(@"Queue'ing up a fetch operation"); 
    SVFetchServerInfoOperation *fetchOperation = [[SVFetchServerInfoOperation alloc] initWithCouchServer:couchServer];
    
   
    
    [fetchOperation addObserver:self
                     forKeyPath:@"isFinished" 
                        options:0
                        context:nil];
    
    [queue addOperation:fetchOperation];

    
    
        
    [fetchOperation release];
   
}

-(void) loadMainWindow{
    SVDebug(@"loading MainWindow nib.");
    
    mainWindowController = [[SVMainWindowController alloc] initWithWindowNibName:@"MainWindow"];
   	[mainWindowController showWindow:self];
    if(LOCAL_PORT == 5983)
        [self launchCouchDB];
    else
         [self performFetchServerInfoOperation];     
}


- (void)applicationDidFinishLaunching:(NSNotification*)notification{
    [self loadMainWindow];        
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication*)sender{
	return YES;
}
- (void)observeValueForKeyPath:(NSString*)keyPath 
                      ofObject:(id)object 
                        change:(NSDictionary*)change 
                       context:(void*)context{

    if([keyPath isEqual:@"isFinished"] && [object isKindOfClass:[SVFetchServerInfoOperation class]]){
     
        id sourceViewModelRootNode = [(SVFetchServerInfoOperation*)object rootNode];
        if(sourceViewModelRootNode == nil){
            [self performFetchServerInfoOperation];            
        }else{
            // This logic should not exist here. The navigation loading operations should be chained such 
            // that once davenport loads the database(s) navigation information, plugin loading operations 
            // kick off. 
            SVPluginContributionLoader *contributionLoader = [[SVPluginContributionLoader alloc] init];
            [contributionLoader start];            
            SVDebug(@"Contribution loader %@", contributionLoader.instances );
                         
            for( id plugin in contributionLoader.instances){
                // Register the plugin for future lookup. We assume that all instanaces 
                // have been fully vetted and that by the time we start interacting with 
                // them here, they are what they claim to be. That is to say, they fully 
                // implement the plugin protocol. 
                
                //Might want to include version number in the key at some point. 
                            
                NSString *uid = [plugin pluginID];                                                                       
                [self.pluginRegistry setObject:plugin forKey:uid];
                
                NSTreeNode *contributionRootNode = [plugin navigationContribution];
                [[sourceViewModelRootNode mutableChildNodes] addObjectsFromArray:[contributionRootNode childNodes]];
            }
            
            [contributionLoader release];                                                
            [lock lock];
            [mainWindowController setRootNode:sourceViewModelRootNode];
            //[[mainWindowController sourceView] reloadData];
            [lock unlock];
        }
    } 
}

#pragma mark -
#pragma mark CouchDB Startup 
-(void)launchCouchDB{        
    
    in = [[NSPipe alloc] init];
    out = [[NSPipe alloc] init];
    task = [[NSTask alloc] init];
    
    NSMutableString *launchPath = [[NSMutableString alloc] init];
    [launchPath appendString:[[NSBundle mainBundle] resourcePath]];
    [launchPath appendString:@"/CouchDb"];
    [task setCurrentDirectoryPath:launchPath];
    
    [launchPath appendString:@"/startCouchDb.sh"];
    [task setLaunchPath:launchPath];
    [task setStandardInput:in];
    [task setStandardOutput:out];
    
    NSFileHandle *fileHandle = [out fileHandleForReading];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    // MainWindow will write data to the log view
    [notificationCenter addObserver:[self mainWindowController]
           selector:@selector(dataReady:)
               name:NSFileHandleReadCompletionNotification
             object:fileHandle];    
    
    [notificationCenter addObserver:self
           selector:@selector(performFetch:)
               name:NSFileHandleReadCompletionNotification
             object:fileHandle];

    [notificationCenter addObserver:self
           selector:@selector(taskTerminated:)
               name:NSTaskDidTerminateNotification
             object:task];
  	[task launch];
	
    // Read from the fileHandle in order to trigger the GET Databases Operation as wells as logging. 
  	[fileHandle readInBackgroundAndNotify];
    [launchPath release];
    
}

/* performFetch exists to kick of the data fetching notification loop. It does this by observing NSFileHandleReadCompletionNotification on a NSFileHandle. That is to say, it watches for output from the couchDB startup script (executed via an NSTask) and kicks of an NSOperation that will HTTP GET a list of databases from the couchDB server. This method is only called once as it imediatley removes its self from the notification center. 
 
    Is calls dataReady in order to log the 
*/
- (void)performFetch:(NSNotification *)notification{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
    [self performFetchServerInfoOperation];    
    
     //if (task)
         [[out fileHandleForReading] readInBackgroundAndNotify];

     
}

-(void)taskTerminated:(NSNotification *)notification{
    [task release], task = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 
#pragma mark Plugin Support 
- (id) lookupPlugin:(NSString*)pluginID{
    return [self.pluginRegistry objectForKey:pluginID];
}
@end
