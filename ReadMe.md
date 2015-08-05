## WXDownLoadManager
### 用于任何文件的下载，对下载任务统一化管理，实时监控任务状态，通过客户端实现断点下载

![试例](http://ww3.sinaimg.cn/large/9ac1c132gw1euqu0fhemjg20aa0j2hdu.gif)

### 包含两个类

- WXDownLoadTask:下载任务，创建时传入url生成一个独立的下载任务，可以直接通过start等方法进行任务的开始，暂停等操作。同时也可以通过state等属性获得该任务当前的状态，下载进度等。
- WXDownLoadManager:任务管理器，是一个单粒对象。里面放的都是WXDownLoadTask任务。可以通过addTask方法添加Task对象。通过Manager可以对已加入的所有Task进行统一的管理监控。能通过属性直接获取当前各种状态的任务对象。也能通过startAllTask等方法对任务进行统一的开始，暂停等操作.
- WXdownLoadTaskDelegate:WXDownLoadTask的代理方法，通过代理方法监听任务的开始，暂停，结束等状态变化。
- WXDownLoadManagerDelegate:WXDownLoadManager的代理方法，通过代理方法可以监听Manager中各个任务的状态变化。

###使用方法

 - WXDownLoadTask:
 
 初始化方法
  
  ```objc
  /**
 *  初始化方法
 *  @param ufileURL  文件的url路径
 *  @param file      文件保存的路径，可以传nil，表示保存在Library/Caches中 --- !!!(目前只支持nil)!!!
 */
+(instancetype)taskWithString:(NSString *)fileURL writeToFile:(NSString *)file;
-(instancetype)initWithString:(NSString *)fileURL writeToFile:(NSString *)file;

  ```
  
  属性
  
  ```objc
  /**
 *  下载任务的状态(默认是0)
 *  0 ---- 等待中的任务（首次添加还没有开始下载的任务）
 *  1 ---- 正在下载的任务
 *  2 ---- 暂停的任务
 *  3 ---- 取消下载的任务
 *  4 ---- 已经完成的任务
 */
@property (nonatomic,readonly)NSInteger state;

//下载文件的名称（文件在服务器的名称）
@property (nonatomic,readonly)NSString *taskName;
//文件的真实路径（文件在手机中真实存储的路径（包括文件在手机中真实存储的名称，名称是唯一编码，跟文件在服务器的名称不一致））
@property (nonatomic,readonly)NSString *filePath;
//文件存在手机中的名称（唯一标识名称）
@property (nonatomic,readonly)NSString *fileName;

//当前的下载进度
@property (nonatomic,assign,readonly)float CurProgress;

//文件所属的WXDownLoadManager，如果是直接通过WXDownLoadTask进行下载，则为nil
@property (nonatomic,weak)WXDownLoadManager *ParManager;

/** 文件总大小和已经下载的大小必须在启动下载任务后才有值 */
//文件总大小
@property (nonatomic,readonly)NSInteger totalLength;
//已经下载的大小
@property (nonatomic,readonly)NSInteger downLoadLength;
  
  ```
  
  方法
  
  ```objc
  //开始下载
-(void)start;
//暂停下载
-(void)suspend;
//取消下载（对已完成的任务会同时删除下载的文件）
-(void)cancel;
  
  ```
  
  代理方法
  
  ```objc
  //完成下载时
-(void)WXDownLoadTaskDidFinishDownLoad:(WXDownLoadTask *)task;
//任务开始
-(void)WXDownLoadTaskDidBeginDownLoad:(WXDownLoadTask *)task;
//任务暂停
-(void)WXDownLoadTaskDidSuspendDownLoad:(WXDownLoadTask *)task;
//任务取消
-(void)WXDownLoadTaskDidCancelDownLoad:(WXDownLoadTask *)task;

  ```
  
  -WXDownLoadManager
  
  初始化方法
  
  ```objc
  //获取默认对象(单粒)
+ (instancetype)sharedManager;

  ```
  
  属性
  
  ```objc
  /**
 *  存放WXDownLoadTask对象的数组,用来管理下载任务，可以批量修改下载任务的状态
 * 所有任务
 */
@property (nonatomic,strong)NSArray *taskArray;
//正在下载的任务
@property (nonatomic,strong)NSArray *downLoadArray;
//暂停的任务
@property (nonatomic,strong)NSArray *suspendArray;
//已经完成的任务
@property (nonatomic,strong)NSArray *finishArray;

  ```
  
  方法 
  
  ```objc
  //添加任务(添加后需要调用startAllTask开始下载)
-(void)addTask:(WXDownLoadTask *)task;

//开始下载
-(void)startAllTask;
//暂停下载
-(void)suspendAllTask;
//取消下载
-(void)cancelAllTask;

  ```
  
  代理方法
  
  ```objc
  //当添加某个task的时候
-(void)WXDownLoadManager:(WXDownLoadManager *)manager addTask:(WXDownLoadTask *)task;

//当某个任务下载完成的时候
/**
 * 此方法的调用不一定会在主线程中，如果在此方法中需要刷新ui界面，需将刷新ui界面的代码放在主线程中调用。
 */
-(void)WXDownLoadManager:(WXDownLoadManager *)manager FinishLoadTask:(WXDownLoadTask *)task;


//当某个任务开始的时候
-(void)WXDownLoadManager:(WXDownLoadManager *)manager BeginLoadTask:(WXDownLoadTask *)task;
//当某个任务暂停的时候
-(void)WXDownLoadManager:(WXDownLoadManager *)manager SuspendTask:(WXDownLoadTask *)task;
//当某个任务取消的时候
-(void)WXDownLoadManager:(WXDownLoadManager *)manager CancelTask:(WXDownLoadTask *)task;


//所有任务下载完毕的时候
-(void)WXDownLoadManagerFinishLoadAllTask:(WXDownLoadManager *)manager;
//所有任务暂停的时候
-(void)WXDownLoadManagerSuspendAllTask:(WXDownLoadManager *)manager;
//所有任务取消的时候
-(void)WXDownLoadManagerCancelAllTask:(WXDownLoadManager *)manager;

  ```
  
  
    

