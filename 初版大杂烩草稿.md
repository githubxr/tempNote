==========================================================

\### 草稿区



apifox中，league令牌：afxp\_d6d08aM0cK7ZoiTAf4v4PpyK5Aoahf0BnnNp



mysql8 默认密码：zdwo\_MVPg5jk 重置为了123456；端口3308



后端导入成功后，默认管理员账号：

用户名: admin

密码: admin123

这个账号在 ruoyi-vue-pro.sql 中已经初始化好了。



重装mysql得先后执行

sc delete MySQL

sc.exe delete MySQL

&#x20;

如果连不上Nacos，可以在本地配置文件中直接配置数据库：

&#x20;application-local.yaml

spring:

&#x20; datasource:

&#x09;...



分库分表，mq都有集成，但是业务代码并没全用到



==========================================================

待办

seata日志后期解决：ELK（Elasticsearch + Logstash + Kibana）来收集日志



seata启动：分布式锁🔒的表未初始化先不管：ERROR --- \[lock.DataBaseDistributedLocker] : The distribute lock table is not config



今晚看情况是否可以：

自己折腾个自定义注解+aspect类做些上手







==========================================================

附录01

导入seata配置到nacos教程：

第一步：去你 本地 Seata 的 conf 文件夹

路径：

plaintext

D:\\workspace\\apache-seata-2.6.0-incubating-bin\\seata-server\\conf

第二步：找到这个文件

plaintext

nacos-config.sh

Windows 用：nacos-config.cmd

第三步：双击运行它！

它会自动把 Seata 需要的所有配置 → 导入本地 Nacos







==========================================================

杂项

项目快速上手的应该：先抄（会用）→ 再理解（为什么）

有时没时间给我：先理解（配置/原理）→ 再尝试用





原子更新函数IFNULL的写法：.setSql("balance = IFNULL(balance, 0) + " + sourceBalance)



项目雷点，member的balance用的integer而非bigdecimal

member的id 是long，parentid却是varchar。（两者有明确指向关系）





经典策略：选择型（选一个）

项目中：编排型（排好队全执行）



==========================================================

待处理笔记

Spring基础append

**集合依赖注入**

你是说，一个interface接口定义，作为List的泛型约束， Spring容器就会在看到@Reource和@Autowired的时候， 自动建立一个List instance，并把上面的interface接口的实现类都放到这个List容器里面？



strem操作

&#x09;.mapToInt(()=>)

&#x09;.sum()

.stream().map(Member::getId).collect(Collectors.toList())



==============================================================================



其他本地操作（League模块内）:

RelationshipMergeStrategy: 更新会员关系链

BalanceMergeStrategy: 合并余额、清零源账户

AccountDisableStrategy: 注销源会员账号





1011->101

1012->101



10111->1011

10112->1011



1012->101



10111->101

10112->101



==============================================================================



现有的Member相关表（约15个）

核心表：

member - 会员主表

member\_relationship - 会员上下级关系表

member\_change\_record - 上级会员变更记录表

业务记录表：

member\_merge\_balance\_record - 会员合并余额变动记录表 ⭐

member\_withdraw\_record - 提现记录表

member\_adjustment\_record - 手动调账记录表

member\_withdraw\_batch\_record - 提现打款批次记录表

功能表：

member\_bank\_card - 银行卡信息

member\_message / member\_read\_message - 消息相关

member\_product\_collection - 商品收藏

member\_product\_footprint - 商品足迹

member\_fans\_nickname - 粉丝昵称

配置表：

member\_benefit\_config - 会员权益配置

member\_upgrade\_config - 会员升级配置







==============================================================================

###### **注销笔记**

**目前就把登录堵死即可，也就是memberAuthServiceImpl中的几个登录相关方法：**

&#x09;**verifyLoginUser**

&#x09;**loginCode**

&#x09;**refreshToken （排除）**

&#x09;**authPhone（排除，这是已登录的情况下进行无关操作（绑定手机号））**



**待定：MemberAuthServiceImpl中：**

&#x09;refreshtoken 那里，需要查一下，以实现把注销了的挤下去吗？感觉都是可有可无，并不影响

&#x09;

###### 

###### **注销其他部分考虑待定**



&#x20;其他需要注意的地方（不在当前文件）

MemberRelationshipServiceImpl.java 第172行

使用 memberMapper.selectById() 查询会员

建议加上 isLogOff 检查，避免与已注销会员建立关系

GroupCompanyServiceImpl.java 第226行

使用 memberMapper.selectBatchIds() 批量查询

建议过滤掉已注销会员

各种业务 Service 中通过 SecurityFrameworkUtils.getLoginUserId() 获取用户后的操作

理论上不需要改，因为登录时已经拦截

但为了安全，建议在关键业务操作前校验





# **============================**

###### **邀功部分：**

member的loginCode部分：【

&#x09;	// @remark 两次查询并不稳妥，在并发场景下仍可能插入重复 openId 用户

&#x20;               // 考虑增加 openId 唯一约束，并通过捕获唯一键冲突保证幂等

】



# **============================**

###### **测试模板**



现在业务把‘注销’通过‘is\_log\_off’来标记而非deleted，

注销了的用的deleted也是0不用管deleted；

然后，测试前，插入的数据是【 】

然后，执行了请求【http://localhost:38080/app-api/league/member/disable】 (token用的是id为1011的用户的token)



随后执行sql 1【】

查到的数据是【 】

执行SQL2【】

查到的数据是【】

你认为从测试数据来看，\[RelationShipRelinkStrategy]里的逻辑是否正确？





###### **测试记录**

\-注销顶层101，正常 √

\-重复注销顶层101，第二次提示用户不存在 √

\-注销中层1011，√

\-重复注销中层1011，第二次提示用户不存在 √

\-注销底层10111，√

\-重复注销底层10111，第二次提示用户不存在 √



\--不同顺序重复一次，简单尽可能多覆盖边界； √？



# **============================**

备份代码

&#x20;   ///////////



&#x20;   void oldExecute(DisableContext context) {

&#x20;       Member disableMember = context.getDisableMember();



&#x20;       log.info("开始执行关系重组策略: 注销会员ID={}", disableMember.getId());



&#x20;       // 查询 Member 表中所有 parentId = disableMemberId 的下级会员

&#x20;       List<Member> subMembers = memberService.list(new LambdaQueryWrapper<Member>()

&#x20;               .eq(Member::getParentId, disableMember.getId())

&#x20;               .eq(Member::getDeleted, 0)); // 仅查询未删除的会员



&#x20;       //是否存在下级

&#x20;       final boolean hasSubMembers = CollUtil.isNotEmpty(subMembers);

&#x20;       //若注销会员无上级，那其下级的上级 会被设为null

&#x20;       final Long grandPaId = StrUtil.isEmpty(disableMember.getParentId())

&#x20;               ? null

&#x20;               : Long.valueOf(disableMember.getParentId());

&#x20;       //统一三表修改时间便于查询

&#x20;       final Date disableDate = new Date();



&#x20;       //如果有下级关系，member和relationship都得更新

&#x20;       if (hasSubMembers) {

&#x20;           List<Long> subMemberIds = subMembers.stream().map(Member::getId).collect(Collectors.toList());

&#x20;           log.info("查询到下级会员数量: {}, ID列表: {}", subMemberIds.size(), subMemberIds);



&#x20;           // 更新 grandson上级为grandpa

&#x20;           LambdaUpdateWrapper<Member> memberUpdateWrapper = new LambdaUpdateWrapper<>();

&#x20;           memberUpdateWrapper.in(Member::getId, subMemberIds)

&#x20;                   .eq(Member::getParentId, grandPaId)

&#x20;                   .set(Member::getParentId, grandPaId)

&#x20;                   .set(Member::getUpdater, context.getOperator())

&#x20;                   .set(Member::getParentUpgradeTime, new Date());

&#x20;           memberService.update(memberUpdateWrapper);

&#x20;           log.info("注销会员下级的上级重新链接到注销会员的上级，更新完成: 影响行数={}", subMemberIds.size());



&#x20;           // 解除下级旧关系

&#x20;           releaseSubRelationship(disableMember, subMemberIds, disableDate);

&#x20;       }



&#x20;       if(grandPaId != null) {

&#x20;           // 解除上级旧关系

&#x20;           releaseParentRelationship(disableMember,  disableDate);

&#x20;           if (hasSubMembers) {

&#x20;               // 插入新绑定关系（指向注销会员的上级）

&#x20;               bindNewRelationShip(grandPaId, subMembers, disableDate);

&#x20;           }

&#x20;       }



&#x20;       log.info("关系链重连完成: 目标会员ID={}", disableMember.getId());

&#x20;   }



&#x20;   ///////







&#x20;   private void handleOldRelationship(Member disableMember, List<Member> subMembers, Date now) {



&#x20;       if(StrUtil.isNotEmpty(disableMember.getParentId())) {

&#x20;           LambdaUpdateWrapper<MemberRelationship> releaseParentWrapper = new LambdaUpdateWrapper<>();

&#x20;           releaseParentWrapper.eq(MemberRelationship::getChildMemberId, disableMember.getId())

&#x20;                   .in(MemberRelationship::getStatus,

&#x20;                           MemberRelationshipStatusEnum.COOLING.getStatus(),

&#x20;                           MemberRelationshipStatusEnum.CONFIRMED.getStatus())

&#x20;                   .set(MemberRelationship::getStatus, MemberRelationshipStatusEnum.RELEASED.getStatus())

&#x20;                   .set(MemberRelationship::getReleaseTime, now)

&#x20;                   .set(MemberRelationship::getRemark, "下级会员注销自动解除");

&#x20;           Boolean releasedParCount = relationshipService.update(releaseParentWrapper);

&#x20;           log.info("旧上级关系解除结果: {}", releasedParCount);

&#x20;       }



&#x20;       if(CollUtil.isNotEmpty(subMembers)) {

&#x20;           List<Long> subMemberIds = subMembers.stream().map(Member::getId).collect(Collectors.toList());



&#x20;           LambdaUpdateWrapper<MemberRelationship> releaseSubWrapper = new LambdaUpdateWrapper<>();

&#x20;           releaseSubWrapper.in(MemberRelationship::getChildMemberId, subMemberIds)

&#x20;                   .eq(MemberRelationship::getParentMemberId, disableMember.getId())

&#x20;                   .in(MemberRelationship::getStatus,

&#x20;                           MemberRelationshipStatusEnum.COOLING.getStatus(),

&#x20;                           MemberRelationshipStatusEnum.CONFIRMED.getStatus())

&#x20;                   .set(MemberRelationship::getStatus, MemberRelationshipStatusEnum.RELEASED.getStatus())

&#x20;                   .set(MemberRelationship::getReleaseTime, now)

&#x20;                   .set(MemberRelationship::getRemark, "上级会员注销自动解除");

&#x20;           Boolean  releasedCount = relationshipService.update(releaseSubWrapper);

&#x20;           log.info("旧下级关系解除结果: {}", releasedCount);

&#x20;       }



&#x20;   }









