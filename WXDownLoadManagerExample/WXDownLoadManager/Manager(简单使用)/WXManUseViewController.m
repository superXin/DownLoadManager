//
//  WXManUseViewController.m
//  wxdownLoad测试
//
//  Created by 周伟昕 on 15/8/4.
//  Copyright (c) 2015年 zwx. All rights reserved.
//

#import "WXManUseViewController.h"
#import "WXDownLoadManager.h"

@interface WXManUseViewController ()

@end

@implementation WXManUseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
- (IBAction)BtnClick:(UIButton *)sender {
    WXDownLoadManager *man = [WXDownLoadManager sharedManager];
    //添加多任务
    [man addTask:[WXDownLoadTask taskWithString:@"http://120.25.226.186:32812/resources/videos/minion_02.mp4" writeToFile:nil]];
    [man addTask:[WXDownLoadTask taskWithString:@"http://120.25.226.186:32812/resources/videos/minion_03.mp4" writeToFile:nil]];
    [man addTask:[WXDownLoadTask taskWithString:@"http://120.25.226.186:32812/resources/videos/minion_04.mp4" writeToFile:nil]];
    [man addTask:[WXDownLoadTask taskWithString:@"http://120.25.226.186:32812/resources/videos/minion_05.mp4" writeToFile:nil]];
    
    //开始下载
    [man startAllTask];

}

-(void)dealloc
{
    [[WXDownLoadManager sharedManager] cancelAllTask];
}
@end
