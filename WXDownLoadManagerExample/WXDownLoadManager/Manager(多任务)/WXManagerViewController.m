//
//  WXManagerViewController.m
//  wxdownLoad测试
//
//  Created by 周伟昕 on 15/8/4.
//  Copyright (c) 2015年 zwx. All rights reserved.
//

#import "WXManagerViewController.h"
#import "WXDownLoadManager.h"

@interface WXManagerViewController ()<WXDownLoadManagerDelegate,WXDownLoadTaskDelegate>
/**
 *  任务1
 */
@property (weak, nonatomic) IBOutlet UITextField *URL1;
@property (weak, nonatomic) IBOutlet UILabel *ProLabel1;
@property (weak, nonatomic) IBOutlet UIProgressView *ProView1;
@property (nonatomic,strong)WXDownLoadTask *task1;


@property (weak, nonatomic) IBOutlet UIButton *addTaskBtn1;
@property (weak, nonatomic) IBOutlet UIButton *startTaskBtn1;
@property (weak, nonatomic) IBOutlet UIButton *suspendTaskBtn1;
@property (weak, nonatomic) IBOutlet UIButton *cancelTaskBtn1;

/**
 *  任务2
 */
@property (weak, nonatomic) IBOutlet UITextField *URL2;
@property (weak, nonatomic) IBOutlet UILabel *ProLabel2;
@property (weak, nonatomic) IBOutlet UIProgressView *ProView2;
@property (nonatomic,strong)WXDownLoadTask *task2;


@property (weak, nonatomic) IBOutlet UIButton *addTaskBtn2;
@property (weak, nonatomic) IBOutlet UIButton *startTaskBtn2;
@property (weak, nonatomic) IBOutlet UIButton *suspendTaskBtn2;
@property (weak, nonatomic) IBOutlet UIButton *cancelTaskBtn2;
/**
 *  任务3
 */
@property (weak, nonatomic) IBOutlet UITextField *URL3;
@property (weak, nonatomic) IBOutlet UILabel *ProLabel3;
@property (weak, nonatomic) IBOutlet UIProgressView *ProView3;
@property (nonatomic,strong)WXDownLoadTask *task3;


@property (weak, nonatomic) IBOutlet UIButton *addTaskBtn3;
@property (weak, nonatomic) IBOutlet UIButton *startTaskBtn3;
@property (weak, nonatomic) IBOutlet UIButton *suspendTaskBtn3;
@property (weak, nonatomic) IBOutlet UIButton *cancelTaskBtn3;

/**
 *  任务4
 */
@property (weak, nonatomic) IBOutlet UITextField *URL4;
@property (weak, nonatomic) IBOutlet UILabel *ProLabel4;
@property (weak, nonatomic) IBOutlet UIProgressView *ProView4;
@property (nonatomic,strong)WXDownLoadTask *task4;


@property (weak, nonatomic) IBOutlet UIButton *addTaskBtn4;
@property (weak, nonatomic) IBOutlet UIButton *startTaskBtn4;
@property (weak, nonatomic) IBOutlet UIButton *suspendTaskBtn4;
@property (weak, nonatomic) IBOutlet UIButton *cancelTaskBtn4;

/**
 *  Manager
 */
@property (weak, nonatomic) IBOutlet UILabel *AllTaskLabel;
@property (weak, nonatomic) IBOutlet UILabel *DownLoadLabel;
@property (weak, nonatomic) IBOutlet UILabel *SuspendsLabel;
@property (weak, nonatomic) IBOutlet UILabel *FinishedLabel;

@property (nonatomic,strong)WXDownLoadManager *manager;


@property (weak, nonatomic) IBOutlet UIButton *AllStartBtn;
@property (weak, nonatomic) IBOutlet UIButton *AllSuspendBtn;
@property (weak, nonatomic) IBOutlet UIButton *AllCancelBtn;

@end

@implementation WXManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpLabels];
}

-(WXDownLoadManager *)manager
{
    if(!_manager)
    {
        _manager = [WXDownLoadManager sharedManager];
        _manager.delegate = self;
    }
    return _manager;
}

#pragma mark - 任务1 按钮点击
//添加任务
- (IBAction)addTaskClick:(UIButton *)sender {
    //创建任务：传入url路径
    self.task1=[WXDownLoadTask taskWithString:self.URL1.text writeToFile:nil];
    //设置代理，用来监听下载状态和获得下载进度
    self.task1.delegate = self;
    self.ProView1.progress = self.task1.CurProgress;
    self.ProLabel1.text = [NSString stringWithFormat:@"%.2f%%",self.task1.CurProgress * 100];
    //文件存放的唯一路径
//    NSLog(@"%@",self.task1.filePath);
    
    //将任务添加到manager中
    [self.manager addTask:self.task1];
    
    //修改按钮状态
    self.addTaskBtn1.enabled = NO;
    self.startTaskBtn1.enabled = YES;
    self.suspendTaskBtn1.enabled = YES;
    self.cancelTaskBtn1.enabled = YES;
    
}
//开始任务
- (IBAction)startTaskClick:(UIButton *)sender {
    [self.task1 start];
}
//暂停任务
- (IBAction)suspendTaskClick:(UIButton *)sender {
    [self.task1 suspend];
}
//取消任务
- (IBAction)cancelTaskClick:(UIButton *)sender {
    [self.task1 cancel];
    //修改按钮状态
    self.addTaskBtn1.enabled = YES;
    self.startTaskBtn1.enabled = NO;
    self.suspendTaskBtn1.enabled = NO;
    self.cancelTaskBtn1.enabled = NO;

}
#pragma mark - 任务2 按钮点击

//添加任务
- (IBAction)addTaskClick2:(UIButton *)sender {
    //创建任务：传入url路径
    self.task2=[WXDownLoadTask taskWithString:self.URL2.text writeToFile:nil];
    //设置代理，用来监听下载状态和获得下载进度
    self.task2.delegate = self;
    self.ProView2.progress = self.task2.CurProgress;
    self.ProLabel2.text = [NSString stringWithFormat:@"%.2f%%",self.task2.CurProgress * 100];
    //文件存放的唯一路径
    //    NSLog(@"%@",self.task2.filePath);
    
    //将任务添加到manager中
    [self.manager addTask:self.task2];
    
    //修改按钮状态
    self.addTaskBtn2.enabled = NO;
    self.startTaskBtn2.enabled = YES;
    self.suspendTaskBtn2.enabled = YES;
    self.cancelTaskBtn2.enabled = YES;
    
}
//开始任务
- (IBAction)startTaskClick2:(UIButton *)sender {
    [self.task2 start];
}
//暂停任务
- (IBAction)suspendTaskClick2:(UIButton *)sender {
    [self.task2 suspend];
}
//取消任务
- (IBAction)cancelTaskClick2:(UIButton *)sender {
    [self.task2 cancel];
    //修改按钮状态
    self.addTaskBtn2.enabled = YES;
    self.startTaskBtn2.enabled = NO;
    self.suspendTaskBtn2.enabled = NO;
    self.cancelTaskBtn2.enabled = NO;
}


#pragma mark - 任务3 按钮点击

//添加任务
- (IBAction)addTaskClick3:(UIButton *)sender {
    //创建任务：传入url路径
    self.task3=[WXDownLoadTask taskWithString:self.URL3.text writeToFile:nil];
    //设置代理，用来监听下载状态和获得下载进度
    self.task3.delegate = self;
    self.ProView3.progress = self.task3.CurProgress;
    self.ProLabel3.text = [NSString stringWithFormat:@"%.2f%%",self.task3.CurProgress * 100];
    //文件存放的唯一路径
    //    NSLog(@"%@",self.task3.filePath);
    
    //将任务添加到manager中
    [self.manager addTask:self.task3];
    
    //修改按钮状态
    self.addTaskBtn3.enabled = NO;
    self.startTaskBtn3.enabled = YES;
    self.suspendTaskBtn3.enabled = YES;
    self.cancelTaskBtn3.enabled = YES;
    
}
//开始任务
- (IBAction)startTaskClick3:(UIButton *)sender {
    [self.task3 start];
}
//暂停任务
- (IBAction)suspendTaskClick3:(UIButton *)sender {
    [self.task3 suspend];
}
//取消任务
- (IBAction)cancelTaskClick3:(UIButton *)sender {
    [self.task3 cancel];
    //修改按钮状态
    self.addTaskBtn3.enabled = YES;
    self.startTaskBtn3.enabled = NO;
    self.suspendTaskBtn3.enabled = NO;
    self.cancelTaskBtn3.enabled = NO;
}
#pragma mark - 任务4 按钮点击
//添加任务
- (IBAction)addTaskClick4:(UIButton *)sender {
    //创建任务：传入url路径
    self.task4=[WXDownLoadTask taskWithString:self.URL4.text writeToFile:nil];
    //设置代理，用来监听下载状态和获得下载进度
    self.task4.delegate = self;
    self.ProView4.progress = self.task4.CurProgress;
    self.ProLabel4.text = [NSString stringWithFormat:@"%.2f%%",self.task4.CurProgress * 100];
    //文件存放的唯一路径
    //    NSLog(@"%@",self.task4.filePath);
    
    //将任务添加到manager中
    [self.manager addTask:self.task4];
    
    //修改按钮状态
    self.addTaskBtn4.enabled = NO;
    self.startTaskBtn4.enabled = YES;
    self.suspendTaskBtn4.enabled = YES;
    self.cancelTaskBtn4.enabled = YES;
    
}
//开始任务
- (IBAction)startTaskClick4:(UIButton *)sender {
    [self.task4 start];
}
//暂停任务
- (IBAction)suspendTaskClick4:(UIButton *)sender {
    [self.task4 suspend];
}
//取消任务
- (IBAction)cancelTaskClick4:(UIButton *)sender {
    [self.task4 cancel];
    //修改按钮状态
    self.addTaskBtn4.enabled = YES;
    self.startTaskBtn4.enabled = NO;
    self.suspendTaskBtn4.enabled = NO;
    self.cancelTaskBtn4.enabled = NO;
}
#pragma mark - Manager 按钮点击
//开始所有任务
- (IBAction)startAllTaskClick:(UIButton *)sender {
    [self.manager startAllTask];
}
//暂停所有任务
- (IBAction)suspendAllTaskClick:(UIButton *)sender {
    [self.manager suspendAllTask];
}
//取消所有任务
- (IBAction)cancelAllTaskClick:(UIButton *)sender {
    [self.manager cancelAllTask];
    
    //修改按钮状态
    self.addTaskBtn1.enabled = YES;
    self.startTaskBtn1.enabled = NO;
    self.suspendTaskBtn1.enabled = NO;
    self.cancelTaskBtn1.enabled = NO;
    
    self.addTaskBtn2.enabled = YES;
    self.startTaskBtn2.enabled = NO;
    self.suspendTaskBtn2.enabled = NO;
    self.cancelTaskBtn2.enabled = NO;

    self.addTaskBtn3.enabled = YES;
    self.startTaskBtn3.enabled = NO;
    self.suspendTaskBtn3.enabled = NO;
    self.cancelTaskBtn3.enabled = NO;

    self.addTaskBtn4.enabled = YES;
    self.startTaskBtn4.enabled = NO;
    self.suspendTaskBtn4.enabled = NO;
    self.cancelTaskBtn4.enabled = NO;


}


#pragma mark - WXDownLoadTaskDelegate
//接收数据
-(void)WXDownLoadTask:(WXDownLoadTask *)task didReceiveProgress:(float)progress
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        if(task == self.task1)
        {
            self.ProLabel1.text = [NSString stringWithFormat:@"%.2f%%",progress * 100];
            self.ProView1.progress=progress;
        }
        if(task == self.task2)
        {
            self.ProLabel2.text = [NSString stringWithFormat:@"%.2f%%",progress * 100];
            self.ProView2.progress=progress;
        }
        if(task == self.task3)
        {
            self.ProLabel3.text = [NSString stringWithFormat:@"%.2f%%",progress * 100];
            self.ProView3.progress=progress;
        }
        if(task == self.task4)
        {
            self.ProLabel4.text = [NSString stringWithFormat:@"%.2f%%",progress * 100];
            self.ProView4.progress=progress;
        }

    });

}

#pragma mark - WXDownLoadManagerDelegate
//向manager添加某个task的时候
-(void)WXDownLoadManager:(WXDownLoadManager *)manager addTask:(WXDownLoadTask *)task
{
    [self setUpLabels];
}
//当某个任务开始的时候
-(void)WXDownLoadManager:(WXDownLoadManager *)manager BeginLoadTask:(WXDownLoadTask *)task
{
    [self setUpLabels];
}
//当暂停某个任务的时候
-(void)WXDownLoadManager:(WXDownLoadManager *)manager SuspendTask:(WXDownLoadTask *)task
{
    [self setUpLabels];
}
//当取消某个任务的时候
-(void)WXDownLoadManager:(WXDownLoadManager *)manager CancelTask:(WXDownLoadTask *)task
{
    [self setUpLabels];
}
//当完成某个任务的时候
-(void)WXDownLoadManager:(WXDownLoadManager *)manager FinishLoadTask:(WXDownLoadTask *)task
{
    //刷新界面，需要在主线程中执行
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self setUpLabels];
    });
}


#pragma mark - 刷新label
-(void)setUpLabels
{
    self.AllTaskLabel.text = [NSString stringWithFormat:@"%zd",self.manager.taskArray.count];
    self.DownLoadLabel.text = [NSString stringWithFormat:@"%zd",self.manager.downLoadArray.count];
    self.SuspendsLabel.text = [NSString stringWithFormat:@"%zd",self.manager.suspendArray.count];
    self.FinishedLabel.text = [NSString stringWithFormat:@"%zd",self.manager.finishArray.count];
    
    //修改按钮的状态
    self.AllStartBtn.enabled = (self.manager.taskArray.count > 0);
    self.AllSuspendBtn.enabled = (self.manager.taskArray.count > 0);
    self.AllCancelBtn.enabled = (self.manager.taskArray.count > 0);
}
@end
