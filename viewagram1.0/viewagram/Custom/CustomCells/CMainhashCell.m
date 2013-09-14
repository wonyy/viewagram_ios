//
//  CMainhashCell.m
//  viewagram
//
//  Created by wonymini on 7/3/13.
//  Copyright (c) 2013 odeh. All rights reserved.
//

#import "CMainhashCell.h"

@implementation CMainhashCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_m_labelHashTag release];
    [super dealloc];
}
@end
