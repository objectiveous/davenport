//
//  SVPluginContributionLoader.m
//  Davenport
//
//  Created by Robert Evans on 2/13/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import "SVPluginContributionLoader.h"
#import "SVContributionNav.h"

@implementation SVPluginContributionLoader

@synthesize instances;
@synthesize ext;
@synthesize appSupportSubpath;


- (void)main{
    self.ext = @"plugin";
    self.appSupportSubpath = @"Application Support/Davenport/PlugIns";
    self.instances = [[NSMutableArray alloc] init];
    [self loadAllPlugins];

    SVDebug(@"Lets' load them plugins. ");
}

-(void)dealloc{
    [instances release];
    [super dealloc];
}

#pragma mark - 
- (void)loadAllPlugins{
    
    //NSMutableArray *instances;
 
    Class currPrincipalClass;
    id currInstance;
    
    NSMutableArray *bundlePaths = [NSMutableArray array];
            
    [bundlePaths addObjectsFromArray:[self allBundles]];        
    NSEnumerator *pathEnum = [bundlePaths objectEnumerator];    

    NSBundle *currBundle;
    NSString *currPath;
    while(currPath = [pathEnum nextObject]){        
        currBundle = [NSBundle bundleWithPath:currPath];
        
        if(currBundle){
            currPrincipalClass = [currBundle principalClass];
            if(currPrincipalClass && [self plugInClassIsValid:currPrincipalClass]){
                currInstance = [[currPrincipalClass alloc] init];
                if(currInstance){
                    [self.instances addObject:[currInstance autorelease]];
                }
            }
        }
    }
}

- (NSMutableArray *)allBundles{
    
    //NSArray *librarySearchPaths;    
    NSEnumerator *searchPathEnum;    
    NSString *currPath;    
    NSMutableArray *bundleSearchPaths = [NSMutableArray array];    
    NSMutableArray *allBundles = [NSMutableArray array];
    
    NSArray *librarySearchPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSAllDomainsMask - NSSystemDomainMask, YES);
    searchPathEnum = [librarySearchPaths objectEnumerator];
    
    while(currPath = [searchPathEnum nextObject]){        
        [bundleSearchPaths addObject:[currPath stringByAppendingPathComponent:appSupportSubpath]];        
    }
    
    [bundleSearchPaths addObject:[[NSBundle mainBundle] builtInPlugInsPath]];
            
    searchPathEnum = [bundleSearchPaths objectEnumerator];
    
    while(currPath = [searchPathEnum nextObject]){        
        NSDirectoryEnumerator *bundleEnum;
        NSString *currBundlePath;
        bundleEnum = [[NSFileManager defaultManager] enumeratorAtPath:currPath];
        
        if(bundleEnum){
            while(currBundlePath = [bundleEnum nextObject]){
                if([[currBundlePath pathExtension] isEqualToString:ext]){
                    [allBundles addObject:[currPath stringByAppendingPathComponent:currBundlePath]];
                }
            }
        }
    }
    return allBundles;    
}

- (BOOL)plugInClassIsValid:(Class)plugInClass{    
    if([plugInClass conformsToProtocol:@protocol(SVContributionNav)]){        
        // The following check is nice and all but it slows down development by 
        // requiring us to update both the protocol header and this method whenenver 
        // we change a signature. Once the protocol starts firming up, these 
        // checks will become more appropriate. For now, we won't perform them. 
        /*
        if([plugInClass instancesRespondToSelector:@selector(helloWorld)]){
            return YES;
        }
         */
        return YES;
    }
   return NO;           
}
@end
