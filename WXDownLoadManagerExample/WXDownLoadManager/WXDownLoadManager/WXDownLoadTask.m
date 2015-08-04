//
//  WXDownLoadTask.m
//  WXDownLoadManager
//
//  Created by 周伟昕 on 15/7/21.
//  Copyright (c) 2015年 zwx. All rights reserved.
//
//下载路径
//#define WXDownLoadURL @"http://120.25.226.186:32812/resources/videos/minion_01.mp4"
#define WXDownLoadURL self.downLoanURL
//加密后的文件名
//#define WXDownLoadFileName WXDownLoadURL.md5String
#define WXDownLoadFileName  [NSString stringWithFormat:@"%@.%@",WXDownLoadURL.md5String,[[WXDownLoadURL componentsSeparatedByString:@"."] lastObject]]
//文件的存放路径
#define WXFilePath  [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:WXDownLoadFileName]
//已经下载文件的长度
#define WXDownLoadLength [[[NSFileManager defaultManager] attributesOfItemAtPath:WXFilePath error:nil][NSFileSize] integerValue]
//存储下载文件的总长度
#define WXDownLoadTotalLength [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"totalLength.wx"]

#import "WXDownLoadTask.h"
#import "NSString+Hash.h"
#import "WXDownLoadManager.h"

@interface WXDownLoadTask()<NSURLSessionDataDelegate>
//下载路径
@property (nonatomic,strong)NSString *downLoanURL;
//保存文件路径
@property (nonatomic,strong)NSString *downLoadFilePath;
//创建session
@property (nonatomic,strong)NSURLSession *session;
//下载任务
@property (nonatomic,strong)NSURLSessionDataTask *task;
//创建流
@property (nonatomic,strong)NSOutputStream *stream;
//文件总长度
@property (nonatomic,assign)NSInteger wx_totalLength;

//task的状态
@property (nonatomic,assign)NSInteger wx_state;
//taskName
@property (nonatomic,strong)NSString *wx_taskName;
//当前进度
@property (nonatomic,assign)float wx_CurProgress;

//通知WXDownLoadManager的代理方法
@property (nonatomic,weak) WXDownLoadManager<WXDownLoadTaskDelegate> *ManagerDelegate;

@end
@implementation WXDownLoadTask

#pragma mark - 初始化方法
+(instancetype)taskWithString:(NSString *)fileURL writeToFile:(NSString *)file
{
    return [[self alloc] initWithString:fileURL writeToFile:file];
}
-(instancetype)initWithString:(NSString *)fileURL writeToFile:(NSString *)file
{
    WXDownLoadTask *task=[[WXDownLoadTask alloc] init];
    
    task.downLoanURL = fileURL;
    //目前只支持nil
//    task.downLoadFilePath = file;
    //获得文件名称
    task.wx_taskName = [[fileURL componentsSeparatedByString:@"/"] lastObject];
    return task;
}
#pragma mark - 开始下载
-(void)start
{
    if(self.wx_state == 1) return;
    self.wx_state = 1;
    [self.task resume];
    if([_delegate respondsToSelector:@selector(WXDownLoadTaskDidBeginDownLoad:)])
    {
        [_delegate WXDownLoadTaskDidBeginDownLoad:self];
    }
    if([_ManagerDelegate respondsToSelector:@selector(WXDownLoadTaskDidBeginDownLoad:)])
    {
        [_ManagerDelegate WXDownLoadTaskDidBeginDownLoad:self];
    }
}
#pragma mark - 暂停下载
-(void)suspend
{
    if(self.wx_state == 2 || self.wx_state == 0) return;
    self.wx_state = 2;
    [self.task suspend];
    if([_delegate respondsToSelector:@selector(WXDownLoadTaskDidSuspendDownLoad:)])
    {
        [_delegate WXDownLoadTaskDidSuspendDownLoad:self];
    }
    if([_ManagerDelegate respondsToSelector:@selector(WXDownLoadTaskDidSuspendDownLoad:)])
    {
        [_ManagerDelegate WXDownLoadTaskDidSuspendDownLoad:self];
    }


}
#pragma mark - 取消下载
-(void)cancel
{
    
//    移除之前下载的文件
    [[NSFileManager defaultManager]removeItemAtPath:WXFilePath error:nil];
    
    self.wx_state = 3;
    [self.task cancel];
        if([_delegate respondsToSelector:@selector(WXDownLoadTaskDidCancelDownLoad:)])
    {
        [_delegate WXDownLoadTaskDidCancelDownLoad:self];
    }
    if([_ManagerDelegate respondsToSelector:@selector(WXDownLoadTaskDidCancelDownLoad:)])
    {
        [_ManagerDelegate WXDownLoadTaskDidCancelDownLoad:self];
    }
    
    
}
#pragma mark - 总长度
-(NSInteger)totalLength
{
    return [WXDownLoadTotalLength integerValue];
}
#pragma mark - 已经下载的大小
-(NSInteger)downLoadLength
{
    return [WXDownLoadTotalLength integerValue];
}

//获得task的状态
-(NSInteger)state
{
    return self.wx_state;
}
//获得taskNmae
-(NSString *)taskName
{
    return self.wx_taskName;
}
//获得真实路径
-(NSString *)filePath
{
//    return self.wx_filePath;
    return WXFilePath;
}
//获得文件的唯一标示名称
-(NSString *)fileName
{
    return WXDownLoadFileName;
}
//获得当前进度
-(float)CurProgress
{
    //获得文件总长度
    float totalLength = [[NSMutableDictionary dictionaryWithContentsOfFile:WXDownLoadTotalLength][WXDownLoadFileName] floatValue];
    if(totalLength == 0) return 0;
    _wx_CurProgress = WXDownLoadLength / totalLength;
    return _wx_CurProgress;
}
#pragma mark - 设置所属的WXDownLoadManager
-(void)setParManager:(WXDownLoadManager *)ParManager
{
    _ParManager = ParManager;
    self.ManagerDelegate = ParManager;
}

#pragma mark - 延时加载
//创建session
-(NSURLSession *)session
{
    if(!_session)
    {
        _session=[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    }
    return _session;
}
//创建任务
-(NSURLSessionDataTask *)task
{
    if(!_task)
    {
        //如果下载完毕，直接退出
        //获得总长度
        NSInteger totalLength = [[NSMutableDictionary dictionaryWithContentsOfFile:WXDownLoadTotalLength][WXDownLoadFileName] integerValue];
        if(totalLength && WXDownLoadLength == totalLength)
        {
            self.wx_state = 4;
            return nil;
        }
        //创建请求
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:WXDownLoadURL]];
        // 设置请求头
        // Range : bytes=xxx-xxx（bytes=%zd-:表示每次从这个位置开始写入）
        NSString *range = [NSString stringWithFormat:@"bytes=%zd-", WXDownLoadLength];
        [request setValue:range forHTTPHeaderField:@"Range"];
        //创建task
        _task=[self.session dataTaskWithRequest:request];
    }
    return _task;
}
//流
-(NSOutputStream *)stream
{
    if(!_stream)
    {
        _stream = [[NSOutputStream alloc] initToFileAtPath:WXFilePath append:YES];
    }
    return _stream;
}

#pragma mark - URLSession代理
//接收响应
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    //打开流
    [self.stream open];
    //获得文件总长度
    self.wx_totalLength = [response.allHeaderFields[@"Content-Length"] integerValue] + WXDownLoadLength;
    //存储文件总长度
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithContentsOfFile:WXDownLoadTotalLength];
    if(!dict) dict=[NSMutableDictionary dictionary];
    dict[WXDownLoadFileName] = @(self.wx_totalLength);
    //写入文件
    [dict writeToFile:WXDownLoadTotalLength atomically:YES];
    
    //允许接收
    completionHandler(NSURLSessionResponseAllow);
}
//接收数据
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    //写入数据
    [self.stream write:[data bytes] maxLength:data.length];
    //下载进度
    float progress=1.0 * WXDownLoadLength / self.wx_totalLength;
    
    if([_delegate respondsToSelector:@selector(WXDownLoadTask:didReceiveProgress:)])
    {
        [_delegate WXDownLoadTask:self didReceiveProgress:progress];
    }
    if([_ManagerDelegate respondsToSelector:@selector(WXDownLoadTask:didReceiveProgress:)])
    {
        [_ManagerDelegate WXDownLoadTask:self didReceiveProgress:progress];
    }
}
//接收完成
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    //下载完成或者取消会进来这个方法
    //关闭流
    [self.stream close];
    self.stream = nil;
    //清除任务
    self.task = nil;

    if(self.state != 3)
    {
        if([_delegate respondsToSelector:@selector(WXDownLoadTaskDidFinishDownLoad:)])
        {
            [_delegate WXDownLoadTaskDidFinishDownLoad:self];
        }
        if([_ManagerDelegate respondsToSelector:@selector(WXDownLoadTaskDidFinishDownLoad:)])
        {
            [_ManagerDelegate WXDownLoadTaskDidFinishDownLoad:self];
        }
    }
    if(self.wx_state == 3)
    {
        //修改进度值
        if([_delegate respondsToSelector:@selector(WXDownLoadTask:didReceiveProgress:)])
        {
            [_delegate WXDownLoadTask:self didReceiveProgress:0];
        }
        if([_ManagerDelegate respondsToSelector:@selector(WXDownLoadTask:didReceiveProgress:)])
        {
            [_ManagerDelegate WXDownLoadTask:self didReceiveProgress:0];
        }
    }
}

@end
