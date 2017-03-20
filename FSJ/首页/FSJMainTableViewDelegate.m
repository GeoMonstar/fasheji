//
//  FSJMainTableViewDelegate.m
//  FSJ
//
//  Created by Monstar on 16/5/31.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJMainTableViewDelegate.h"
@interface FSJMainTableViewDelegate ()
@property (nonatomic, copy)TableViewDidSelectRowAtIndexPath tableViewDidSelectRowAtIndexPath;

@end
@implementation FSJMainTableViewDelegate

- (instancetype) init {
    
    self = [super init];
    
    if (self) {
        
    }
    return self;
}
- (instancetype) initWithDidSelectRowAtIndexPath:(TableViewDidSelectRowAtIndexPath)tableViewDidSelectRowAtIndexPath {
    
    self = [super init];
    
    if (self) {
        self.tableViewDidSelectRowAtIndexPath = [tableViewDidSelectRowAtIndexPath copy];
        
    }
    return self;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return PopviewCellheight;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.tableViewDidSelectRowAtIndexPath) {
        self.tableViewDidSelectRowAtIndexPath(indexPath);
    }
}


@end
