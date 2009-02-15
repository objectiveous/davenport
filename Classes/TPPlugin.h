//
//  TNavContribution.h
//  DPTestPlugin
//
//  Created by Robert Evans on 2/13/09.
//  Copyright 2009 South And Valley. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DPContributionPlugin.h"

@interface TPPlugin : NSObject <DPContributionPlugin>{


}

+(NSString*)pluginID;
-(NSString*)pluginID;

@end
