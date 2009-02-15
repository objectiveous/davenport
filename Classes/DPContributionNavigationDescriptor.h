//
//  DPContributionNavigationDescriptor.h
//  Davenport
//
//  Created by Robert Evans on 2/14/09.
//  Copyright 2009 South And Valley. All rights reserved.
//



@protocol DPContributionNavigationDescriptor

-(NSString*)getLabel;
-(NSString*)getIdentity;
-(NSString*)getPluginID;
            

// If set to true, the NSOutlineView row will be drawn in the “group row” style
// See NSOutlineView outlineView:isGroupItem: for more information
-(BOOL)isGroupItem;


@end
