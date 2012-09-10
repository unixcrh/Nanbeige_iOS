//
//  CPCommentPostElement.m
//  nbg_iOS
//
//  Created by ZongZiWang on 12-8-16.
//  Copyright (c) 2012年 wuhaotian. All rights reserved.
//

#import "CPCommentPostElement.h"

@implementation CPCommentPostElement

- (UITableViewCell *)getCellForTableView:(QuickDialogTableView *)tableView controller:(QuickDialogController *)controller {
    QTableViewCell *cell = (QTableViewCell *) [super getCellForTableView:tableView controller:controller];
    
	UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:cell.contentView.frame];
	UIImageView *selectedBgImgView = [[UIImageView alloc] initWithFrame:cell.contentView.frame];
	NSInteger rowNumber = [[[self parentSection] elements] count];
	NSInteger row = [[[self parentSection] elements] indexOfObject:self];
	if (rowNumber == 1) {
		bgImgView.image = [[UIImage imageNamed:@"cell-btn-full"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
		selectedBgImgView.image = [[UIImage imageNamed:@"cell-btn-pressed-full"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
	} else if (row == 0) {
		bgImgView.image = [[UIImage imageNamed:@"cell-btn-top"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
		selectedBgImgView.image = [[UIImage imageNamed:@"cell-btn-pressed-top"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
	} else if (row == rowNumber - 1) {
		bgImgView.image = [[UIImage imageNamed:@"cell-btn-bottom"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
		selectedBgImgView.image = [[UIImage imageNamed:@"cell-btn-pressed-bottom"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
	} else {
		bgImgView.image = [[UIImage imageNamed:@"cell-btn-middle"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
		selectedBgImgView.image = [[UIImage imageNamed:@"cell-btn-pressed-middle"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
	}
	cell.selectedBackgroundView = selectedBgImgView;
	cell.backgroundView = bgImgView;
	
	cell.textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
	cell.textLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
	cell.textLabel.shadowOffset = CGSizeMake(0.0, 1.0);
	cell.textLabel.highlightedTextColor = cell.textLabel.textColor;
	cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
	cell.detailTextLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
	cell.detailTextLabel.shadowOffset = CGSizeMake(0.0, 1.0);
	cell.detailTextLabel.highlightedTextColor = cell.detailTextLabel.textColor;
	
	return cell;
}

@end
