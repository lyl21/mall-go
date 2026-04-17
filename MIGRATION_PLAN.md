# Ry + Mall 业务系统迁移方案

> 将 ry（眼镜行业智能验光管理系统）和 mall（微信小程序商城）两个 Java Spring Boot 项目的全部业务功能，迁移到 gin-vue-admin（Go + Gin + GORM + Vue3 + Element Plus）平台。

---

## 一、项目概述

### 源系统

| 项目 | 技术栈 | 说明 |
|------|--------|------|
| **ry** | Java Spring Boot + MyBatis + Vue2 + Element UI | 眼镜行业智能验光管理系统，含门店管理、验光记录、设备激活等功能 |
| **mall** | Java Spring Boot + MyBatis-Plus + Vue3 + Element Plus | 微信小程序商城后台，含商品、订单、微信用户、门锁等 |

### 目标平台

| 组件 | 技术 |
|------|------|
| 后端 | Go 1.24 + Gin + GORM + Casbin + JWT |
| 前端 | Vue 3 + Composition API + Element Plus + Pinia + Vue Router 4 |
| 数据库 | MySQL（复用现有库，不迁移数据，只建 GORM 模型对接） |
| 框架 | gin-vue-admin（已内置用户/角色/菜单/字典/日志/JWT 等） |

### 框架功能对照（不迁移，直接复用）

| ry/mall 框架功能 | gin-vue-admin 对应 |
|---|---|
| sys_user 用户管理 | sys_users（已内置） |
| sys_role 角色管理 | sys_authority + Casbin（已内置） |
| sys_menu 菜单管理 | sys_base_menu（已内置） |
| sys_dict 字典管理 | sys_dictionary（已内置） |
| sys_config 参数配置 | sys_params（已内置） |
| sys_oper_log 操作日志 | sys_operation_record（已内置） |
| sys_logininfor 登录日志 | sys_login_log（已内置） |
| JWT 认证 + Spring Security | JWT + Casbin（已内置） |
| 文件上传 | 多存储后端支持（已内置） |

---

## 二、业务模块清单

### ry 业务模块（11 张表）

| 模块 | 表名 | 说明 |
|------|------|------|
| 门店管理 | mx_store | 门店 CRUD、品牌编号、门店编号 |
| 门店成员 | mx_store_member | 店长/验光师/顾客角色绑定 |
| 用户管理 | mx_user | 20+ 个人信息字段、手机号唯一索引 |
| 验光记录 | optometry_records | 事务写入、跨表关联、远程同步到 mall |
| 验光数据 | optometry_data | 球镜/柱镜/轴位/ADD/瞳距等、SAC 统计图表 |
| 视图验光 | vision_test_results | 30+ 视功能检查字段 |
| 试戴验光 | try_optometry | 试戴度数记录 |
| 用户流程 | mx_user_flow | 验光流程追踪 |
| 设备激活 | mx_activation_code | MD5 激活码生成 |
| 安装包管理 | installing_packages | 版本管理、强制更新 |
| 视图图片 | mx_picture | 验光图片管理 |

### mall 业务模块（16 张表）

| 模块 | 表名 | 说明 |
|------|------|------|
| 商品分类 | goods_category | 树形结构 |
| 商品 SPU | goods_spu | 含轮播图 |
| 商品轮播图 | goods_spu_banners | SPU 关联 |
| 试戴图片 | spu_try_on_img_url / try_on_glass_img_url | 商品试戴 |
| 购物车 | shopping_cart | 小程序端 |
| 订单管理 | order_info + order_item | 状态机、微信支付 |
| 订单物流 | order_logistics | 物流信息 |
| 用户地址 | user_address | 收货地址 |
| 微信用户 | wx_user | 小程序/公众号登录、session_key |
| 微信消息 | wx_msg | 消息记录 |
| 微信菜单 | wx_menu | 自定义菜单配置 |
| 自动回复 | wx_auto_reply | 关键词/关注回复 |
| 门锁管理 | door_lock + door_lock_history | 智能门锁 |

---

## 三、核心设计决策

### 1. 数据库字段一致性

gin-vue-admin 内置 `GVA_MODEL` 使用 `created_at`/`updated_at`，而 ry/mall 使用 `create_time`/`update_time`。业务模型 **不嵌入 GVA_MODEL**，使用自定义 `BizModel`：

```go
// model/common/biz_model.go
type BizModel struct {
    CreateTime time.Time `json:"createTime" gorm:"column:create_time;autoCreateTime"`
    UpdateTime time.Time `json:"updateTime" gorm:"column:update_time;autoUpdateTime"`
}
```

### 2. 主键策略

- ry 表：`int64` + `gorm:"primaryKey;autoIncrement;column:原主键名"`
- mall 表：`string` + `gorm:"primaryKey;type:varchar(32);column:id"`（雪花 ID）

### 3. 逻辑删除策略

- ry 使用 `is_delete int(1)`，业务层过滤 `WHERE is_delete=0`
- mall 使用 `del_flag char(2)`，业务层过滤 `WHERE del_flag='0'`
- 不使用 GORM 默认软删

### 4. 架构分层

```
server/
├── model/{模块名}/          # GORM 模型（精确字段映射）
│   └── request/             # 请求参数结构体
├── api/v1/{模块名}/         # HTTP handler
├── service/{模块名}/        # 业务逻辑
├── router/{模块名}/         # 路由注册
└── initialize/router_biz.go # 业务路由入口
```

---

## 四、目录结构

### 后端

```
gin-vue-admin-main/server/
├── model/common/biz_model.go              # 业务基础模型
├── model/optometry/                        # 验光模块（4 模型）
├── model/store/                            # 门店用户模块（7 模型）
├── model/mall/                             # 商城模块（13 模型）
├── model/wechat/                           # 微信模块（4 模型）
├── api/v1/optometry/                       # 验光 API handler
├── api/v1/store/                           # 门店 API handler
├── api/v1/mall/                            # 商城 API handler
├── api/v1/wechat/                          # 微信 API handler
├── service/optometry/                      # 验光 Service
├── service/store/                          # 门店 Service
├── service/mall/                           # 商城 Service
├── service/wechat/                         # 微信 Service
├── router/optometry/                       # 验光路由
├── router/store/                           # 门店路由
├── router/mall/                            # 商城路由
├── router/wechat/                          # 微信路由
└── initialize/router_biz.go                # 业务路由入口
```

### 前端

```
gin-vue-admin-main/web/src/
├── api/optometry/                          # 验光 API 请求
├── api/store/                              # 门店 API 请求
├── api/mall/                               # 商城 API 请求
├── api/wechat/                             # 微信 API 请求
└── view/
    ├── optometry/                          # 验光管理页面
    ├── store/                              # 门店管理页面
    ├── mall/                               # 商城管理页面
    └── wechat/                             # 微信管理页面
```

---

## 五、Java → Go 关键转换

| Java/Spring | Go/Gin |
|---|---|
| `@Transactional` | `global.GVA_DB.Transaction(func(tx *gorm.DB) error {...})` |
| MyBatis Mapper XML | GORM 链式调用 `db.Where().Find()` |
| `OkHttp` 同步 mall | `net/http` 或 `resty` |
| `MessageDigest MD5` | `crypto/md5` |
| WxJava SDK | `github.com/silenceper/wechat` |
| `PageHelper` | GORM `Limit().Offset()` |
| `@Scheduled` | `github.com/robfig/cron/v3` |

---

## 六、实施计划与进度

### 阶段一：基础设施 ✅ 已完成

- [x] 创建 `model/common/biz_model.go` 业务基础模型
- [x] 创建各模块目录结构
- [x] 创建 `initialize/router_biz.go` 路由入口

### 阶段二：ry 门店+验光模型 ✅ 已完成

- [x] `model/store/` — 7 个 GORM 模型（mx_store, mx_store_member, mx_user, mx_user_flow, mx_activation_code, mx_picture, installing_package）
- [x] `model/optometry/` — 4 个 GORM 模型（optometry_record, optometry_data, vision_test_result, try_optometry）
- [x] `model/store/request/` + `model/optometry/request/` — 请求参数结构体

### 阶段三：mall 商城+微信模型 ✅ 已完成

- [x] `model/mall/` — 13 个 GORM 模型（goods_category, goods_spu, goods_spu_banner, spu_try_on_img_url, try_on_glass_img_url, shopping_cart, order_info, order_item, order_logistics, user_address, door_lock, door_lock_history）
- [x] `model/wechat/` — 4 个 GORM 模型（wx_user, wx_msg, wx_menu, wx_auto_reply）
- [x] `model/mall/request/` + `model/wechat/request/` — 请求参数结构体

### 阶段四：ry 门店+验光 API ✅ 已完成

- [x] `service/store/` — 7 个 Service（含事务创建门店+成员、MD5 激活码生成）
- [x] `service/optometry/` — 4 个 Service
- [x] `api/v1/store/` — 7 个 Handler
- [x] `api/v1/optometry/` — 4 个 Handler
- [x] `router/store/` — 7 个 Router
- [x] `router/optometry/` — 4 个 Router
- [x] 编译验证 + 路由注册到 router_biz.go

### 阶段五：mall 商城+微信 API ✅ 已完成

- [x] `service/mall/` — 12 个 Service（含订单状态机、事务创建订单、设置默认地址）
- [x] `service/wechat/` — 4 个 Service（微信用户/消息/菜单/自动回复）
- [x] `api/v1/mall/` — 12 个 Handler
- [x] `api/v1/wechat/` — 4 个 Handler
- [x] `router/mall/` — 12 个 Router
- [x] `router/wechat/` — 4 个 Router
- [x] 路由注册到 router_biz.go
- [x] 编译验证通过

### 阶段六：前端页面 ✅ 已完成

**API 文件（5个）：**
- [x] `api/store.js` — 门店 + 门店成员 API
- [x] `api/mxuser.js` — 用户 + 流程 + 激活码 + 安装包 + 图片 API
- [x] `api/optometry.js` — 验光记录/数据/视功能/试戴 API
- [x] `api/mall.js` — 商品/订单/购物车/地址/门锁 API
- [x] `api/wechat.js` — 微信用户/消息/菜单/自动回复 API

**页面文件（18个）：**

门店模块（7个）：
- [x] `view/store/storeManager.vue` — 门店管理（CRUD + 查看成员）
- [x] `view/store/storeMember.vue` — 门店成员管理
- [x] `view/store/mxUser.vue` — 用户/客户管理（20+字段表单）
- [x] `view/store/activation.vue` — 激活码管理
- [x] `view/store/packages.vue` — 安装包管理

验光模块（4个）：
- [x] `view/optometry/records.vue` — 验光记录列表 + 详情（验光单/视功能切换 + 打印）
- [x] `view/optometry/optometryData.vue` — 验光数据查看（电脑验光仪/验光头/最终配镜表格）
- [x] `view/optometry/visionTest.vue` — 视功能检查数据

商城模块（5个）：
- [x] `view/mall/category.vue` — 商品分类管理
- [x] `view/mall/spu.vue` — 商品SPU管理
- [x] `view/mall/order.vue` — 订单管理（状态筛选 + 详情）
- [x] `view/mall/cart.vue` — 购物车管理
- [x] `view/mall/address.vue` — 用户地址管理
- [x] `view/mall/doorLock.vue` — 门锁管理 + 操作记录

微信模块（4个）：
- [x] `view/wechat/wxUser.vue` — 微信用户列表
- [x] `view/wechat/wxMsg.vue` — 消息管理
- [x] `view/wechat/wxMenu.vue` — 菜单配置
- [x] `view/wechat/wxAutoReply.vue` — 自动回复规则

**技术特点：**
- 全部使用 Vue 3 Composition API + `<script setup>`
- 遵循 gin-vue-admin 的 `service` 请求模式
- 使用 Element Plus 组件（el-table, el-form, el-dialog, el-pagination）
- 从 ry Vue2 Options API 重写为 Vue3 Composition API

### 阶段七：集成联调 ⏳ 待开始

- [ ] ry → mall 验光数据同步接口对接
- [ ] 微信小程序 API 对接（登录/支付/模板消息）
- [ ] 菜单权限配置
- [ ] 端到端测试

---

## 七、关键技术点

### MD5 激活码生成

```go
KEY := "uujjljkaahhznzkkassndasn,hasgsjadkasjkjxbz,,kajdl1shak1"
packageName := "com.dongdialog.ks"
hash := md5.Sum([]byte(KEY + packageName + equipment))
code := hex.EncodeToString(hash[:])[:8]
```

### 门店创建事务

```go
global.GVA_DB.Transaction(func(tx *gorm.DB) error {
    if err := tx.Create(&store).Error; err != nil {
        return err
    }
    member := MxStoreMember{StoreId: store.ID, Post: "store_manager", ...}
    return tx.Create(&member).Error
})
```

### 订单状态机

```
待支付(0) → 已支付(1) → 待发货(2) → 已发货(3) → 已完成(4)
                                         ↘ 已取消(5)
已支付(1) → 退款中(6) → 已退款(7)
```

---

## 八、系统架构图

```
┌─────────────────────────────────────────────────────────┐
│                 gin-vue-admin-main 统一平台               │
│                                                         │
│  ┌──────────────────────────────────────────────────┐   │
│  │  前端 Vue3 + Element Plus                        │   │
│  │  ┌────┐ ┌────┐ ┌────┐ ┌────┐                    │   │
│  │  │验光│ │门店│ │商城│ │微信│                    │   │
│  │  └──┬─┘ └──┬─┘ └──┬─┘ └──┬─┘                    │   │
│  └─────┼──────┼──────┼──────┼───────────────────────┘   │
│        │      │      │      │                           │
│  ┌─────▼──────▼──────▼──────▼───────────────────────┐   │
│  │  后端 Go + Gin + GORM                            │   │
│  │  router_biz.go → api/v1 → service → model       │   │
│  ├──────────────────────────────────────────────────┤   │
│  │  已有框架功能（不迁移）                            │   │
│  │  用户/角色/权限 | 菜单/字典/日志 | JWT/文件上传    │   │
│  └──────────────────────┬───────────────────────────┘   │
│                         │                               │
└─────────────────────────┼───────────────────────────────┘
                          │
                    ┌─────▼─────┐
                    │   MySQL    │
                    │  业务数据库  │
                    └───────────┘
```

---

*文档生成时间：2026-04-08*
