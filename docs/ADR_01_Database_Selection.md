# OneCoffee — 数据库选型：Drift vs sqlite3

> **调研日期**: 2026-03-06 · **数据来源**: Web 搜索 (pub.dev, Medium, Reddit, 官方文档)
> **结论**: ✅ 选择 **Drift** · 相关架构文档: [01_Architecture.md](./01_Architecture.md)

---

## 1. 背景

[Product Brief](./00_Product_Brief.md) 中提到 "采用 **Local-First (纯本地离线优先)** 存储策略（如 SQLite/Isar 数据库）"，初版架构选择了 Isar 4.x。

经人工验证发现 **Isar 已约两年未更新**（社区有 isar_community 分支但非官方），构成代码仓库停滞风险。因此重新评估两个活跃替代方案：

- **Drift** — 基于 SQLite 的类型安全 ORM / Reactive 持久化库
- **sqlite3** — SQLite 的原生 Dart FFI 绑定（底层驱动）

---

## 2. 关键事实

| 维度 | Drift | sqlite3 |
|---|---|---|
| **本质** | 基于 SQLite 的**类型安全 ORM** (Reactive 持久化库) | SQLite 的**原生 Dart FFI 绑定** (底层驱动) |
| **抽象层级** | 高层 — Dart API 操作数据库，少写/不写 SQL | 低层 — 直接写 SQL，手动映射数据 |
| **关系** | Drift **内部使用 sqlite3** 作为底层驱动 | 独立使用，也可被 Drift 包装 |
| **维护状态** | 活跃 — 每 2-4 周发布新版 | 活跃 — v3.x 正在推进 (v2.x 支持到 2026 初) |
| **作者** | Simon Binder (simonbinder.eu) | Simon Binder (**同一作者**) |

> ⚠️ **重要发现**：Drift 和 sqlite3 是同一个作者维护的上下游项目。Drift 构建在 sqlite3 之上。选择 Drift = 获得 sqlite3 的性能 + 上层的安全性和便利。

---

## 3. 详细对比

### 3.1 类型安全

| | Drift ✅ | sqlite3 ⬜ |
|---|---|---|
| **编译时 SQL 校验** | ✅ Dart 代码定义 Schema，编译时检查 | ❌ 原生 SQL 字符串，错误仅在运行时暴露 |
| **查询结果类型** | 自动生成强类型 Dart 类 | `List<Map<String, Object?>>` 需手动解析 |
| **SQL 注入防护** | ✅ 内建 | ❌ 需自行参数化 |
| **重构安全** | 改字段名 → 编译器报所有用到的地方 | 改字段名 → 只能搜字符串，容易漏 |

**结论**：对于 OneCoffee 这种多实体关联（BrewRecord ↔ Bean ↔ Equipment ↔ Rating）的项目，Drift 的类型安全优势极其显著。

### 3.2 性能

| | Drift | sqlite3 |
|---|---|---|
| **读性能** | 好 — 有内置缓存机制 | 极好 — 最接近原生 SQLite，零抽象开销 |
| **写性能** | 好 — 事务和批量操作支持完善 | 极好 — 直接 FFI 调用 |
| **实际差异** | 对 OneCoffee 的数据量级（几百~几千条记录），**差异不可感知** | 同上 |

**结论**：在 OneCoffee 的数据量级下，两者性能差异完全可以忽略。

### 3.3 开发体验

| | Drift ✅ | sqlite3 ⬜ |
|---|---|---|
| **样板代码** | 极少 — Schema 定义后自动生成 CRUD | 大量 — 手写 SQL + 手动映射 |
| **Reactive Support** | ✅ 内建 Stream API，数据变化自动推送到 UI | ❌ 需自行实现监听 |
| **迁移系统** | ✅ 内置版本管理、迁移器 | ❌ 需手动管理 |
| **DAO 支持** | ✅ 内建 Data Access Objects | ❌ 完全手写 |
| **代价** | 需要 build_runner 代码生成 | 无需代码生成 |

### 3.4 跨平台支持

两者相当：移动端 ✅ / 桌面端 ✅ / Web (Wasm) ✅ / 纯 Dart Server ✅

### 3.5 与 OneCoffee 项目适配度

| 项目需求 | Drift | sqlite3 |
|---|---|---|
| **多实体关联** (Brew ↔ Bean ↔ Equipment ↔ Rating) | ✅ Joins, 关系建模极其自然 | ⚠️ 手写 JOIN SQL，手动映射 |
| **渐进式 Schema** (GrindMode 枚举、可空字段多) | ✅ 枚举映射内置，nullable 类型安全 | ⚠️ 手动处理枚举转换 |
| **复制昨日参数/再冲一次** | ✅ 类型安全查询 + copyWith | ⚠️ 手写 SELECT + 手动构建 Map |
| **历史过滤** (按豆种/评分/器具筛选) | ✅ Dart 链式 Query Builder | ⚠️ 拼接 WHERE 字符串 |
| **Reactive UI** (数据墙实时更新) | ✅ Stream 自动推送变化 | ❌ 需自行实现 |
| **未来迁移** (v2.0 云端同步) | ✅ 内置版本迁移工具 | ⚠️ 手动迁移脚本 |
| **OKR 测试覆盖率 ≥90%** | ✅ 类型安全 → 编译器即测试 | ⚠️ 需更多测试覆盖 SQL 字符串正确性 |

---

## 4. 决策

### ✅ 选择 Drift

**核心理由**：
1. **类型安全贯穿全链路** — 从 Schema 定义到查询到 UI，编译时保障数据正确性
2. **Reactive Stream** — 天然适配 "数据墙" 的实时更新需求
3. **与 sqlite3 不矛盾** — Drift 底层就是 sqlite3，选 Drift = 获得 sqlite3 的性能 + 安全性
4. **同一作者** — 两个包由同一人维护，Drift 不会偏离 sqlite3 的发展路线
5. **活跃维护** — 每 2-4 周更新一次
6. **代码生成代价可接受** — 项目已经在用 build_runner (freezed + riverpod_generator)

### ⚠️ 被否决的方案

| 方案 | 否决理由 |
|---|---|
| **Isar** | 约两年未更新，社区版非官方，维护风险高 |
| **sqlite3 (直接使用)** | 无类型安全，大量手动映射，不适合多实体关联项目 |
| **sqflite** | 12 个月未更新，且不提供类型安全 |

---

## 5. 架构影响

### 依赖变更

| 原 (Isar) | 替换为 (Drift) |
|---|---|
| `isar` + `isar_flutter_libs` | `drift` + `sqlite3_flutter_libs` |
| `isar_generator` | `drift_dev` |
| Isar Collection 注解 | Drift Table 定义类 |
| Isar 异步查询 API | Drift Stream/Future API |

### 代码层面

- `datasources/` 和 `models/` 目录职责不变，内部代码从 Isar Schema 改为 Drift Table 定义
- `core/database/isar_database.dart` → `core/database/drift_database.dart`
- 原 Isar 的嵌入式对象 (如 BrewRating) 改为标准的 SQL 关联表

> 详见 [01_Architecture.md](./01_Architecture.md) 中的更新。

---

## 6. 知识来源声明

本文档的依赖评估来源：
- **Drift 信息**: Web 搜索 (pub.dev, Medium, simonbinder.eu, Reddit 社区讨论)
- **sqlite3 信息**: Web 搜索 (pub.dev, GitHub changelog, 官方文档)
- **Isar 状态**: 用户在 pub.dev 的人工验证
- **sqflite 状态**: 用户在 pub.dev 的人工验证
