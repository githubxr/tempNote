





****

****

0508

##### 分库分表垂直拆分

了解的原因是，项目中集成且使用在业务代码，得扫盲

要实现的注销功能也会设计涉及



\-reason：

\--垂直拆分

\---分库（localhost分databse性能没什么区别，一般是分到另一个主机）：

\---分表（按业务列把不常用列分出去）：比对“主表从表”的优势：若不分，就算我只select 指定的部分行，数据库在以“行”为单位 查询时，也会把那几千字节的“自我介绍”也加载 到内存

\--水平拆分：

\---分表：表存在不同db

\---分行：表拆为多表，每表存几万条之类的，按id（范围路由/hash取模）之类的取模







****

##### seata

- 结构上：分client/server


&#x09;	client：集成seata的微服务应用

&#x09;		（每个微服务数据库都得建立UNDO\_LOG的sql表脚本从github找对应版本）

&#x09;	server：单独下载的seata，通过seata-server.bat启动，http://localhost:7091访问管理

&#x09;		（如果使用默认的file模式而非db，就不需要配置使用seata-server\\script\\server\\db\\mysql.db建表 for seata server）

- 任务上，分注册和存储

  - 注册：推荐注册到nacos，这样其他微服务能找到（不注册的话，每个客户端都得yml指定seata server地址）
  - 存储：这个是默认file还是什么db，还会自动建立什么log什么什么表？（seata2.6.0为例）



项目中有可参考的，seata会和ShardingSphere搭配集成使用以保证分布式一致性



- Seata运行结构

┌─────────────────────────────────────────────────┐

│           Seata 分布式事务架构                    │

├─────────────────────────────────────────────────┤

│                                                  │

│  TC - Transaction Coordinator (事务协调器)       │ （seata server中）

│  ├─ 维护全局事务的运行状态                        │

│  ├─ 负责协调并驱动全局事务提交或回滚              │

│  └─ 独立部署的服务（Seata Server）                │

│                                                  │

│  TM - Transaction Manager (事务管理器)           │（发起方 下游微服务client）

│  ├─ 定义全局事务的范围                            │

│  ├─ 开启、提交或回滚全局事务                      │

│  └─ 应用中的 @GlobalTransactional 注解           │

│                                                  │

│  RM - Resource Manager (资源管理器)              │（下游微服务client）

│  ├─ 管理分支事务处理的资源                        │

│  ├─ 向 TC 注册分支事务                            │

│  └─ 接收 TC 的指令进行提交/回滚                   │

│                                                  │

└─────────────────────────────────────────────────┘



本地跑

本地调试自动覆盖地址（实现原理后面研究，这里记录用法）

&#x09;IDEA 启动配置：

&#x09;Run → Edit Configurations

&#x09;在 Environment Variables 中添加：

&#x09;	SPRING\_CLOUD\_NACOS\_SERVER\_ADDR=localhost:8848



\##0509

seata使用

\--不用file模式，db模式部署，

\---需要

&#x09;1 配置seata server 数据库：将  \[\\seata-server\\script\\server\\db\\mysql.sql] 部署到seata server主机的数据库，

&#x09;2 配置注册到nacos/读取nacos配置/db记录事务：

&#x09;	 \\seata-server\\conf\\application.yml配置nacos地址+ seata server 的db地址

&#x09;		（推荐用nacos中建立seataServer.properties统一配置）即可

&#x20;      	 	seata server的application.yml三个重要配置：config/registry/store

&#x09;	    client 也要指定seata注册到nacos的两个配置：config/register

&#x09;		其中，config指的是，nacos中seataServer.proerties的group，client的和seata server的要对的上，

&#x09;	    register，就是seata server的application.yml里写的  registry.nacos.group的值，也要对的上；

&#x09;	seata server独有的store是指定server存储事务方式

&#x09;	client独有的service.vgroup-mapping.default\_tx\_group指的则是client要使用的事务组

&#x09;3 nacos的seataServer.properties是导入同事的，所以无需折腾【seata-server\\script\\config-center\\config.txt】,否则可【手动生成：拿 Seata 安装包 script/config-center/config.txt 改参数后导入 Nacos 配置中心，命名为 seataServer.properties。】

&#x09;	如果想折腾，参照附录01

&#x09;  4 启动后，记得检查 use lock store mode: db / use session store mode: db /use store mode: db

&#x09;	是否是db，如还是默认的file说明没读到nacos配置

&#x09;  5 配置client表：每个微服务节点的db都得加undo\_log表；

&#x09;6



\--然后，在微服务项目， 建个简单分布式事务测试（用AT模式，and 必须至少2个微服务节点），手动触发下异常回滚看看



熟悉推客项目seata+ShardingSphere的用法（50%推进中）

熟悉在项目中【注销需求】涉及服务和边界（todo）

争取用【依葫芦画瓢】来加速【注销需求】的落地涉及的业务逻辑（todo）







##### Nacos

nacos命名空间
全方面隔离配置文件/注册服务

&#x09;yml中可空着namespace，默认就是public

nacos的配置文件可覆盖且优先级比resource下的yml高；

nacos不同环境配置文件指定方式

&#x09;项目resources目录下yml会有类似- optional:nacos:${spring.application.name}-${spring.profile.active}.yml

&#x09;其中的active也是在yml中配置的a.b.c.active变量

- 





##### 基础八股jdk

- **饭型：**
  - 特性：Java假泛型，饭型只在编译时检查，会在运行时擦除（不能instance of），不支持csharp，c++的new T；有说是为了兼容老版本jdk代码； 以及，不能向上转型
  - 
  - 写法：
    - ？：不能存只能取；T能复用，？不能；
    - <? extends T> 和 <? super T> ：限定为self or children； self or parent；
    - <T> List<T> test(T t)：返回类型为传入的T类型的List；
    -  public static <T> void func(T t）：
      - 表述：一种看似多此一举的，函数最前的奇怪写法
      - 合理性阐述：
        - 先看，类名上的<T>，是有两个作用【1：new时就传入限定类型】；【2：你说的泛型标记】
        - 同样的方法最前的，则是只有【2：你说的泛型标记】 如果没有泛型标记，读到形参的T t 就会有问题，T会被视为Class名；
  
- 

- Collections
  - 简单记录
    - TreeSet就是KV没有value的TreeMap； (hashMap和hashSet同理)
    - 
  
- 

- **Spring生命周期**
  - 实例化：new
  - 依赖注入：
    - @Autowired/Resource：注入其它instance / 集合注入； 
    - @Value注入：yaml参数；
    - 构造注入；
  - 初始化
    - Aware执行，将spring容器给Bean（获取spring容器信息 / 手动获取其它bean）
    - BeanPostProcessor 
    - PostConstruct 之类自定义操作
  - 销毁 
    - @PreDestroy / @Destroy 自定义’临终操作‘
    - spring容器销毁Bean
  
- 

- ##### Spring Append
  
  - @CahcheAble（16/0525）
  
    - 描述：不看源码我都能猜到是注解标记切入点 + 环绕前查缓存/前后存缓存...
    - 可选择缓存容器：
      - JVM（Simple模式）
      - Redis（分布式一致性）
    - 用法：
      - yaml中配置（缓存容器类别/缓存参数配置等等...）【spring.cache.type/caffeine(redis)...】
      - 相关pom依赖引入
  
    - 很简单，唯一补充说明的是，欸屁里k婶 得加@EnableCaching 开启
  
- 

- 基础 **Filter / FilterChain** 要点

  -  Filter：自行继承重写配置过滤操作
     -  配置方式1：
        -  通过具体的【@WebFilter("/admin/*") 】类似的写法，实现功能性拦截；
        -  通过【@Order(顺序整型)】控制先后顺序 （or xml配置顺序）
     -  配置方式2：
        -  通过springBoot的@Configuration + @Bean的形式 配置实例
        -  路由和顺序：通过 Bean方法返回的 return xx.pattern匹配路由.setOrder配置先后顺序...
     -  配置方法3（微服务）：
        -  spring.cloud.gateway.routes.【id/ uri/ predicates/ filter(-请求头过滤...；-裁剪路径...)】
     -  备注（不一定只用某一种，例如3可以和2搭配，3配路由，2配具体定制的鉴权/权限等骚操作）
  -  FilterChain：无需继承重写，拿出来拦截 or 可触发下一个Filter执行
  -  OncePerRequestFilter（http请求的filter基本都用这个）:
     -  含义：一个请求只会触发一次
     -  意义：避免可能的（重定向/转发）重复触发Filter
  -  






##### 分布式锁要点：**看门🐕**

- 最长等待时间为：Redisson 全局配置：`lockWatchdogTimeout`（默认 30s）
- 看门🐕：会在业务完成时自动释放🔒，**避免**死等到最大持有期限
- rLock.lock()：
  -  无参：自动加看门狗
  -  传参：只能传leaseTime，会写死释放时间，不推荐；
  -  
- rLock.tryLock()：推荐
  - waitTime：获取最多等多久🔒
  - leaseTime：固定释放🔒时间（会关看门狗）
  - 推荐写法：tryLock(waitTime, timeUnit)





##### 设计模式

- 责任链：
  - 类似filter / chain链
  - 



##### SQL进阶

- 联表提前过滤的注意事项：

- 压缩：

  ```
  INNER JOIN：
      随便放
  
  LEFT JOIN：
      左表条件放WHERE
      右表条件放ON
  
  RIGHT JOIN：
      左表条件放ON
      右表条件放WHERE
  ```

- 进阶：

```
（因为：on过滤 => 联表 => Left/Right补Null => Where 顺序）
- inner join 时，可以同时把左表右表过滤条件都写on内（推荐： 在联表前过滤）

- left join 时
  - 右表过滤条件：可无脑写On内，也应该写On内
    - 补充：若右表条件不写On内，会导致左连接变成类似‘内连接’
  - but 左表过滤条件：需特别注意，左表条件在On，只是 ‘筛选和右表连接的左表行’
    - 因左连接特性，筛选下来的，未和右表匹配的，也会保留。
    - 因此如果试图在左连接的on中过滤左表，意图会落空；

- right join时：
  （和左连接差不多反过来）
  - 右表过滤条件：如果试图在On过滤右表，意图会落空
  - 左表过滤条件：可无脑写On
    - 补充：若写Where中，会导致右连接变成类似‘内连接’
```

​      





