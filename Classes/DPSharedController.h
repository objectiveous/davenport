//
//  DPSharedContorller.m
//  Davenport
//
//  Created by Robert Evans on 3/1/09.
//  Copyright 2009 South And Valley. All rights reserved.
//


@protocol DPSharedController

/*!
this method name sucks but its meant to convey the idea that shared resources 
 need data provided by the calling navigation descriptor
 
 
*/
-(void)provision:(id)configurationData;
-(void)setDelegate:(id)delegate;
@end
