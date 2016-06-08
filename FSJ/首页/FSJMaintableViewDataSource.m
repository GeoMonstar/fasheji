//
//  FSJMaintableViewDataSource.m
//  FSJ
//
//  Created by Monstar on 16/5/31.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJMaintableViewDataSource.h"
@interface FSJMaintableViewDataSource ()
@property (nonatomic, copy)TableViewCellConfigureBlock configureCellBlock;
@property (nonatomic, strong) Class Cellclass;
@property (nonatomic, strong) NSArray * modelArray;
@end
@implementation FSJMaintableViewDataSource
- (instancetype) init {
    
    if (self = [super init]) {
        
    }
    return self;
}
- (instancetype)initWithItems:(NSArray *)dataArray cellClass:(Class)cellClass configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock{
    if (self = [super init]) {
        self.modelArray = dataArray;
        self.Cellclass = cellClass;
        self.configureCellBlock = [aConfigureCellBlock copy];
    }
    return self;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [[self.Cellclass class]cellAllocWithTableView:tableView];
    self.configureCellBlock(cell,self.modelArray[indexPath.row]);
    return cell;
}
@end
