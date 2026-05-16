

#注销需求相关数据库变动
#权限（waiting）
#...

#注销记录表
CREATE TABLE `member_disabled_record` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `creator` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted` tinyint NOT NULL DEFAULT '0' COMMENT '逻辑删除：0-未删除，1-已删除',
  `tenant_id` bigint NOT NULL DEFAULT '0' COMMENT '租户ID',
  `updater` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '更新者',
  `disabled_member_id` bigint CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '注销会员id',
  `disabled_member_no` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '注销会员编号',
  `disabled_member_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '注销会员名称',
  `disabled_nick_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '注销会员昵称',
  `balance_before` int DEFAULT NULL COMMENT '注销会员注销前余额（分）',  
  `remark` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注说明',
  `operator_name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '操作人姓名',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会员注销记录表'
;

#成员测试数据
INSERT INTO member (id,member_no,balance,nickname,deleted, tenant_id,parent_id) VALUES
	 (101,'xq test no1',100,'xq测试成员1',0,1,NULL),
	 (1011,'xq test no11',200,'xq测试成员11',0,1,'101'),
	 (1012,'xq test no12',300,'xq测试成员12',0,1,'101'),
	 (10111,'xq test no111',400,'xq测试成员111',0,1,'1011'),
	 (10112,'xq test no112',500,'xq测试成员112',0,1,'1011')
;


#关系测试数据
INSERT INTO member_relationship (id,child_member_id,parent_member_id,status,confirm_type,
  bind_time,cooling_end_time,create_time,update_time,deleted,tenant_id) 
VALUES
	 (1101,1011,101,1,1,'2026-04-01 00:00:00','2026-04-16 00:00:00','2026-04-01 00:00:00','2026-04-01 00:00:00',0,1),
	 (1201,1012,101,1,1,'2026-04-01 00:00:00','2026-04-16 00:00:00','2026-04-01 00:00:00','2026-04-01 00:00:00',0,1),
	 (111011,10111,1011,1,1,'2026-04-01 00:00:00','2026-04-16 00:00:00','2026-04-01 00:00:00','2026-04-01 00:00:00',0,1),
	 (112011,10112,1011,1,1,'2026-04-01 00:00:00','2026-04-16 00:00:00','2026-04-01 00:00:00','2026-04-01 00:00:00',0,1)
;


#菜单权限
INSERT INTO system_menu (name,permission,`type`,sort,parent_id,`path`,icon,component,component_name,
  status,visible,keep_alive,always_show,creator,create_time,updater,update_time,deleted) 
  VALUES
	 ('会员注销','league:member:merge',3,0,0,'','#',NULL,NULL,0,1,1,1,'','2026-05-14 17:45:15',
   '','2026-05-14 17:45:15',0);

#给超级管理员角色（role_id=1）分配这个测试权限
INSERT INTO system_role_menu (role_id, menu_id, creator)
  VALUES (1, 5047？？, '1');