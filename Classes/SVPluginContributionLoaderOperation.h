//
//  SVPluginContributionLoader.h
//  Davenport
//
//  Created by Robert Evans on 2/13/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SVPluginContributionLoaderOperation : NSOperation {
    NSString       *ext;
    NSString       *appSupportSubpath;
    NSMutableArray *instances;
}

@property (retain) NSString       *ext;
@property (retain) NSString       *appSupportSubpath;
@property (retain) NSMutableArray *instances;


- (void)loadAllPlugins;
- (NSMutableArray *)allBundles;
- (BOOL)plugInClassIsValid:(Class)plugInClass;

@end
