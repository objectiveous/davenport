//
//  SVAbstractDescriptor.m
//  
//
//  Created by Robert Evans on 12/27/08.
//  Copyright 2008 South And Valley. All rights reserved.
//

#import "SVBaseNavigationDescriptor.h"
#import "DPContributionNavigationDescriptor.h"
#import "DPSharedController.h"

@interface SVBaseNavigationDescriptor (Private)

- (void) contributeToMenu:(NSMenu*)menu forItem:(NSTreeNode*)item;
- (void) activateMenuItemsForDatabase:(NSMenu*)menu forItem:(NSTreeNode*)item;
- (void) activateMenuItemsForDesignDocument:(NSMenu*)menu forItem:(NSTreeNode*)item;
- (void) removeAllMenuItems:(NSMenu*)menu; 

- (IBAction) refreshAction:(NSMenuItem*)sender;
- (IBAction) newDesignAction:(NSMenuItem*)sender;
- (IBAction) newDatabaseAction:(NSMenuItem*)sender;
- (IBAction) deleteItemAction:(NSMenuItem*)sender;


@end


@implementation SVBaseNavigationDescriptor

@synthesize label;
@synthesize nodeIcon;
@synthesize identity;
@synthesize groupItem;
@synthesize type;
@synthesize couchDatabase;
@synthesize resourceFactory;
@synthesize contributed;

NSString *MenuItemDeleteItem = @"Delete Item";

NSString *MenuItemNewDatabase    = @"Database New"; 
NSString *MenuItemDeleteDatabase = @"Database Delete"; 

NSString *MenuItemNewDesignDoc    = @"Design New";
NSString *MenuItemDeleteDesignDoc = @"Design Delete";

NSString *MenuItemRefresh         = @"Refresh";



+ (NSMutableDictionary *) createUserInfoDictionary:(id) couchObject  {
    //XXX why not a capcity of 1? 
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:2];
    [userInfo setObject:couchObject forKey:@"couchobject"];
    return userInfo;
}
+(id) serverDescriptor:(SBCouchServer*)couchServer resourceFactory:(id <DPResourceFactory>)factory{
    NSString *serverName = [NSString stringWithFormat:@"%@:%u", couchServer.host, couchServer.port];
    
    SVBaseNavigationDescriptor *descriptor = [[SVBaseNavigationDescriptor alloc] initWithLabel:serverName
                                                                                   andIdentity:serverName
                                                                                          type:DPDescriptorCouchServer
                                                                                      userInfo:[self createUserInfoDictionary:couchServer]];

    descriptor.resourceFactory = factory;
    descriptor.groupItem = YES;
    return [descriptor autorelease];
}

+(id) databaseDescriptor:(SBCouchDatabase*)couchDatabase resourceFactory:(id <DPResourceFactory>)factory{
    
    SVBaseNavigationDescriptor *databaseDescriptor = [[SVBaseNavigationDescriptor alloc] initWithLabel:couchDatabase.name
                                                                                           andIdentity:couchDatabase.name
                                                                                                  type:DPDescriptorCouchDatabase
                                                                                              userInfo:[self createUserInfoDictionary:couchDatabase]];
    databaseDescriptor.resourceFactory = factory;
    databaseDescriptor.couchDatabase = couchDatabase;
    return [databaseDescriptor autorelease];
}

+(id) designDescriptor:(SBCouchDesignDocument*)couchDesignDoc resourceFactory:(id <DPResourceFactory>)factory{
    SVBaseNavigationDescriptor *designDescriptor = [[SVBaseNavigationDescriptor alloc] initWithLabel:[couchDesignDoc.identity lastPathComponent]
                                                                                         andIdentity:couchDesignDoc.identity
                                                                                                type:DPDescriptorCouchDesign
                                                                                            userInfo:[self createUserInfoDictionary:couchDesignDoc]];
    designDescriptor.resourceFactory = factory;
    designDescriptor.couchDatabase = couchDesignDoc.couchDatabase;
    return [designDescriptor autorelease];    
}

+(id) viewDescriptor:(SBCouchView*)couchView resourceFactory:(id <DPResourceFactory>)factory{
    SVBaseNavigationDescriptor *viewDescriptor = [[SVBaseNavigationDescriptor alloc] initWithLabel:couchView.name
                                                                                         andIdentity:couchView.identity
                                                                                                type:DPDescriptorCouchView
                                                                                            userInfo:[self createUserInfoDictionary:couchView]];
    viewDescriptor.resourceFactory = factory;
    viewDescriptor.couchDatabase = couchView.couchDatabase;
    return [viewDescriptor autorelease]; 
}
#pragma mark -

-(id)initWithLabel:(NSString*)nodeLabel andIdentity:(NSString*)nodeIdentity type:(DPNavigationDescriptorTypes)aType userInfo:(NSMutableDictionary*)info{
    self = [self initWithLabel:nodeLabel andIdentity:nodeIdentity type:aType];
    if(self){
        userInfo = [info copy];
        [userInfo retain];
    }
    return self;
}

-(id)initWithLabel:(NSString*)nodeLabel andIdentity:(NSString*)nodeIdentity type:(DPNavigationDescriptorTypes)aType{
    self = [super init];
    if(self){
        self.label = nodeLabel;
        self.identity = nodeIdentity;
        self.groupItem = NO;
        self.type = aType;        
    }
    return self;
}

-(void)dealloc{
    [userInfo release], userInfo = nil;
    [super dealloc];
}

-(BOOL)isGroupItem{
    return self.groupItem;
}
- (NSViewController*) contributionInspectorViewController{
    return nil;
}

// XXX Now that we've introduced userinfo as a way of passing around couch objects, this entire 
//     method should be rethought. 
- (NSViewController*) contributionMainViewController{    
    if(self.type == DPDescriptorCouchDatabase){
        NSEnumerator *couchResults = [self.couchDatabase allDocsInBatchesOf:10];
        // This call will set self as the data source to the NSOutlineView. This may or may not be 
        // a good approach. 
        id <DPSharedController> sharedController = [self.resourceFactory namedResource:DPSharedViewContollerNamedViewResults];
        [sharedController provision:couchResults];
        return (NSViewController*) sharedController; 
    }else if(self.type == DPDescriptorCouchView){
        SBCouchView *view = [userInfo objectForKey:@"couchobject"];
        SBCouchQueryOptions *queryOptions = [[SBCouchQueryOptions new] autorelease];

        if(view.reduce){
            queryOptions.group = YES;
        }else{
            queryOptions.group = NO;            
        }

        view.queryOptions = queryOptions;
        
        NSLog(@"ID %@", view.identity);
        NSEnumerator *couchResults = [view viewEnumerator];
        
        id <DPSharedController> sharedController = [self.resourceFactory namedResource:DPSharedViewContollerNamedViewResults];
        [sharedController provision:couchResults];
        return (NSViewController*) sharedController;         
    }
        
    return nil;
}

- (NSString*)pluginID{
    return nil;
}
-(NSDictionary*)userInfo{
    return userInfo;
}

#pragma mark -
#pragma mark Context Menu Support
- (void)menuNeedsUpdate:(NSMenu *)menu forItem:(NSTreeNode*)item{
    [self removeAllMenuItems:menu];
    [self contributeToMenu:menu forItem:(NSTreeNode*)item];

    switch (self.type) {
        case DPDescriptorCouchDatabase:
            [self activateMenuItemsForDatabase:menu forItem:item];
            break;
            
        case DPDescriptorCouchDesign:
            [self activateMenuItemsForDesignDocument:menu forItem:item];
            break;            
            
        default:
            [self removeAllMenuItems:menu];
            break;
    }
}

- (void)contributeToMenu:(NSMenu*)menu forItem:(NSTreeNode*)item{
    

    
    // REFRESH
    if(![menu itemWithTitle:MenuItemRefresh]){
        NSMenuItem *menuItem = [menu addItemWithTitle:MenuItemRefresh action:@selector(refreshAction:) keyEquivalent:@""];
        [menuItem setTarget:self];
        [menuItem setRepresentedObject:item];
    }
    // DELETE ITEM
    if(![menu itemWithTitle:MenuItemDeleteItem]){
        NSMenuItem *menuItem = [menu addItemWithTitle:MenuItemDeleteItem action:@selector(deleteItemAction:) keyEquivalent:@""];
        [menuItem setTarget:self];
        [menuItem setRepresentedObject:item];
    }   
    
    
    if(![menu itemWithTitle:@"sep"]){
        NSMenuItem *seperator = [NSMenuItem separatorItem];
        [seperator setEnabled:YES];
        [seperator setTitle:@"sep"];
        [menu addItem:seperator];
    }
    
    // NEW DESIGN
    if(![menu itemWithTitle:MenuItemNewDesignDoc]){
        NSMenuItem *menuItem = [menu addItemWithTitle:MenuItemNewDesignDoc action:@selector(newDesignAction:) keyEquivalent:@""];
        [menuItem setTarget:self];
        [menuItem setRepresentedObject:item];
    }
    

    
    // NEW DATABASE
    if(![menu itemWithTitle:MenuItemNewDatabase]){
        NSMenuItem *menuItem = [menu addItemWithTitle:MenuItemNewDatabase action:@selector(newDatabaseAction:) keyEquivalent:@""];
        [menuItem setTarget:self];
        [menuItem setRepresentedObject:item];
    }   
    
    // DELETE DATABASE
    /*
    if(![menu itemWithTitle:MenuItemDeleteDatabase]){
        NSMenuItem *menuItem = [menu addItemWithTitle:MenuItemDeleteDatabase action:@selector(deleteDatabaseAction:) keyEquivalent:@""];
        [menuItem setTarget:self];
        [menuItem setRepresentedObject:item];
    }      
    */
}

- (void) activateMenuItemsForDatabase:(NSMenu*)menu forItem:(NSTreeNode*)item{
    [[menu itemWithTitle:MenuItemNewDatabase] setHidden:NO];
    [[menu itemWithTitle:MenuItemDeleteDatabase] setHidden:NO];

    
    [[menu itemWithTitle:MenuItemNewDesignDoc] setHidden:NO];
    [[menu itemWithTitle:MenuItemDeleteDesignDoc] setHidden:NO];
}

- (void) activateMenuItemsForDesignDocument:(NSMenu*)menu forItem:(NSTreeNode*)item{
    [[menu itemWithTitle:MenuItemNewDesignDoc] setHidden:NO];
    [[menu itemWithTitle:MenuItemDeleteDesignDoc] setHidden:NO];
}

- (void) removeAllMenuItems:(NSMenu*)menu{
    for(NSMenuItem *item in [menu itemArray]){
        [menu removeItem:item];
    }
}

- (IBAction) refreshAction:(NSMenuItem*)sender{
    NSTreeNode *treeNode = [sender representedObject];
    [[NSNotificationCenter defaultCenter] postNotificationName:DPRefreshNotification object:treeNode];
}

- (IBAction) newDesignAction:(NSMenuItem*)sender{
    
}
- (IBAction) newDatabaseAction:(NSMenuItem*)sender{
    NSTreeNode *treeNode = [sender representedObject];
    [[NSNotificationCenter defaultCenter] postNotificationName:DPCreateDatabaseAction object:treeNode];
}
- (IBAction) deleteItemAction:(NSMenuItem*)sender{
    NSTreeNode *treeNode = [sender representedObject];
    [[NSNotificationCenter defaultCenter] postNotificationName:DPDeleteItemAction object:treeNode];
}

@end
