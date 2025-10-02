# LazyCAT Custom Modifications

本文档记录了相对于上游社区版本的所有定制化修改。

## 配置文件修改

### 1. public/config.js (新增文件)

**修改类型**: 新增文件

**修改原因**:
- 为 LazyCAT Cloud Platform 提供运行时配置注入能力
- 在容器启动时由 init service 动态生成此文件
- 支持多租户部署时无需重新构建应用即可注入不同的配置（如 Rekor 服务器 URL、API 端点等）

**变更内容**:
- 创建占位符配置文件
- 实际配置将在运行时由 init service 覆盖写入

---

### 2. src/pages/_document.tsx

**修改类型**: 修改现有文件

**修改原因**:
- 在应用启动前加载运行时配置
- 确保配置在所有组件加载之前可用
- 支持平台特定配置的动态注入

**变更内容**:
- 在 `<Head>` 中添加 `<script src="/config.js"></script>`
- 添加 eslint-disable 注释以允许同步脚本加载（必须同步以确保配置优先加载）

**原始代码**:
```tsx
<Head></Head>
```

**修改后**:
```tsx
<Head>
    {/* eslint-disable-next-line @next/next/no-sync-scripts */}
    <script src="/config.js"></script>
</Head>
```

---

### 3. next.config.js

**修改类型**: 修改现有文件

**修改原因**:
- 适配静态导出模式 (`output: "export"`)
- Next.js 的图片优化 API 不支持静态导出
- 需要禁用图片优化以确保应用在 LazyCAT Cloud Platform 上正常运行

**变更内容**:
- 添加 `images.unoptimized: true` 配置项

**原始代码**:
```javascript
const nextConfig = {
    reactStrictMode: true,
    output: "export",
};
```

**修改后**:
```javascript
const nextConfig = {
    reactStrictMode: true,
    output: "export",
    images: {
        unoptimized: true,
    },
};
```

---

---

## 维护说明

在合并上游更新时，请特别注意以下文件的冲突：
1. `next.config.js` - 确保保留 `images.unoptimized: true`
2. `src/pages/_document.tsx` - 确保保留 config.js 加载脚本
3. `public/config.js` - 此文件为 LazyCAT 特有，不要删除

## 同步上游

```bash
# 添加上游仓库（如果还未添加）
git remote add upstream https://github.com/sigstore/rekor-search-ui.git

# 获取上游更新
git fetch upstream

# 合并上游主分支
git merge upstream/main

# 解决冲突后，参考本文档确保 LazyCAT 修改未被覆盖
```
