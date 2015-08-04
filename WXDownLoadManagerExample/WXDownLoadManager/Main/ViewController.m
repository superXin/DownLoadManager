//
//  ViewController.m
//  wxdownLoad测试
//
//  Created by 周伟昕 on 15/7/22.
//  Copyright (c) 2015年 zwx. All rights reserved.
//

#import "ViewController.h"

#import "WXDownLoadManager.h"
#import "WXDownLoadTask.h"

@interface ViewController ()<WXDownLoadTaskDelegate,WXDownLoadManagerDelegate>
@property (weak, nonatomic) IBOutlet UIProgressView *progressV;
@property WXDownLoadTask *task;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self WXDownLoadTask];
    
    
}

//通过WXDownLoadManager实现多任务下载
-(void)WXDownLoadManager
{
    //创建WXDownLoadManager(Manager为单粒对象)
    WXDownLoadManager *manage=[WXDownLoadManager sharedManager];
    
    //添加任务1
    [manage addTask:[WXDownLoadTask taskWithString:@"http://120.25.226.186:32812/resources/videos/minion_01.mp4" writeToFile:nil]];
    //添加任务2
    [manage addTask:[WXDownLoadTask taskWithString:@"http://120.25.226.186:32812/resources/videos/minion_01.mp4" writeToFile:nil]];
    //添加任务3
    [manage addTask:[WXDownLoadTask taskWithString:@"http://120.25.226.186:32812/resources/videos/minion_01.mp4" writeToFile:nil]];
    //设置代理。监听下载状态的变化
    manage.delegate = self;
    //开始下载
    [manage startAllTask];
}

@end
