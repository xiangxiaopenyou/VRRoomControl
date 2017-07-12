//
//  PrescriptionContentsCell.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/20.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PrescriptionContentsCellDelegate<NSObject>
@optional
- (void)didClickAddContent;
- (void)didDeleteContent:(NSArray *)contentsArray;
- (void)didSetContentCycle:(NSArray *)contentsArray;
@end

@interface PrescriptionContentsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;
//@property (copy, nonatomic) void (^addContentBlock)();
@property (weak, nonatomic) id<PrescriptionContentsCellDelegate> delegate;

- (void)resetContents:(NSArray *)contents;

@end
