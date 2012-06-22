//
//  EZTableSelector.h
//  SqueezitProto
//
//  Created by Apple on 12-6-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EZTableSelector;
@protocol EZTableSelectorDelegate<NSObject>

- (NSInteger) getSection:(EZTableSelector*)selector; 
- (NSInteger) getRow:(EZTableSelector*)selector;

- (UITableViewCell*) tableSelector:(EZTableSelector*)selector getCell:(NSIndexPath*)indexPath;

- (void) tableSelector:(EZTableSelector*)selector selected:(NSIndexPath*)indexPath;

- (void) doneClicked:(EZTableSelector*)selector;

- (void) cancelClicked:(EZTableSelector*)selector;

@end


@interface EZTableSelector : UITableViewController

@property (strong, nonatomic) id<EZTableSelectorDelegate> selectorDelegate;

//Will deselect the rest of the cell.
//The issue with this is that for all visible cell,
//I will turn the check off, only keep this one.
//Why visible?
//Because the nonvisible will go throught the get cell process. 
//This will make sure the checkMark show correctly.
- (void) selectOnly:(NSIndexPath*)indexPath;

//Just add a check mark to the correct cell.
- (void) selectAdd:(NSIndexPath*)indexPath;

//Set the checkMark to none
- (void) selectNot:(NSIndexPath*)indexPath;

//Return the index of the current selected cell
- (NSIndexPath*) getSelectedRow;

- (UITableViewCell*) getCellByIndexPath:(NSIndexPath*)indexPath;

@end
