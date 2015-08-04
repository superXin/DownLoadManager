//
//  WXTaskViewController.m
//  wxdownLoad测试
//
//  Created by 周伟昕 on 15/8/3.
//  Copyright (c) 2015年 zwx. All rights reserved.
//

#import "WXTaskViewController.h"
#import "WXDownLoadTask.h"

@interface WXTaskViewController ()<WXDownLoadTaskDelegate>
@property (weak, nonatomic) IBOutlet UIProgressView *ProgressView;
//url地址
@property (weak, nonatomic) IBOutlet UITextField *URLText;
//进度百分比
@property (weak, nonatomic) IBOutlet UILabel *curPro;

@property (nonatomic,strong)WXDownLoadTask *task;
@end

@implementation WXTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加下载任务
    [self WXDownLoadTask];
}


//直接通过任务实现单个下载
-(void)WXDownLoadTask
{
    //创建任务：传入url路径
    self.task=[WXDownLoadTask taskWithString:self.URLText.text writeToFile:nil];
    
    //设置代理，用来监听下载状态和获得下载进度
    self.task.delegate = self;
    self.ProgressView.progress = self.task.CurProgress;
    self.curPro.text = [NSString stringWithFormat:@"%.2f%%",self.task.CurProgress * 100];

    //文件存放的唯一路径
    NSLog(@"%@",self.task.filePath);
}
#pragma mark - WXDownLoadTaskDelegate
-(void)WXDownLoadTask:(WXDownLoadTask *)task DidBeginDownLoad:(NSString *)taskName
{
    NSLog(@"开始");
}
-(void)WXDownLoadTask:(WXDownLoadTask *)task DidSuspendDownLoad:(NSString *)taskName
{
    NSLog(@"暂停");
}
-(void)WXDownLoadTask:(WXDownLoadTask *)task DidCancelDownLoad:(NSString *)taskName
{
    NSLog(@"取消");
}
-(void)WXDownLoadTask:(WXDownLoadTask *)task DidFinishDownLoad:(NSString *)taskName
{
    NSLog(@"完成");
}
-(void)WXDownLoadTask:(WXDownLoadTask *)task didReceiveProgress:(float)progress
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        
        self.curPro.text = [NSString stringWithFormat:@"%.2f%%",progress * 100];
        self.ProgressView.progress=progress;
    });
}

#pragma mark - 按钮点击
//开始下载
- (IBAction)startClick:(UIButton *)sender {
    self.URLText.enabled = NO;
    [self.task start];
}
//暂定下载
- (IBAction)suspendClick:(UIButton *)sender {
    [self.task suspend];
}
//取消下载
- (IBAction)cancelClick:(UIButton *)sender {
    self.URLText.enabled = YES;
    [self.task cancel];
}

-(void)dealloc
{
    [self.task suspend];
}
@end
