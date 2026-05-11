# atlisp-agent 使用指南

## 功能介绍

atlisp-agent 是 @lisp 生态的 AI Agent 工具，通过 MCP（Model Context Protocol）协议连接 CAD（AutoCAD/ZWCAD/GStarCAD/BricsCAD），为用户提供 AI 辅助操作能力。

### 核心能力

- **AI 对话**：使用大语言模型与 Agent 进行自然语言交互
- **CAD 操作**：自动执行 CAD 命令、查询信息、操作图形对象
- **AutoLISP 编程**：编写、调试、执行 AutoLISP 代码
- **包管理**：搜索、安装、更新 @lisp 包

### 工作原理

```
用户输入 → atlisp-agent → MCP Server → CAD
                     ↓
              大语言模型 (LLM)
```

1. 用户发送自然语言指令
2. atlisp-agent 调用 LLM 理解用户意图
3. LLM 返回工具调用（如 `eval_lisp`）
4. atlisp-agent 通过 MCP 执行工具
5. 返回结果给 LLM 生成最终回复

---

## 安装

### 方式一：PowerShell 自动安装（推荐）

```powershell
iwr -useb https://atlisp.cn/install.ps1 | iex
```

此命令会安装 @lisp 核心及 atlisp-agent。

### 方式二：npm 全局安装

```bash
npm i -g @atlisp/agent
```

---

## 运行

### 1. 交互模式 - chat

启动持续对话，可多次输入：

```bash
atlisp-agent chat
# 或
atlisp-agent chat "初始消息"
```

### 2. 单次执行 - exec

执行单条指令后退出：

```bash
atlisp-agent exec "查询 CAD 版本"
```

### 3. 列出工具 - tools

查看 MCP 所有可用工具：

```bash
atlisp-agent tools
```

### 4. HTTP 服务模式

启动 REST API 服务：

```bash
atlisp-agent-server
# 或
npm run server

# 启动在 http://0.0.0.0:8110
```

---

## 配置

### 配置文件位置

- `~/.atlisp/atlisp.json`（JSON 格式）
- `~/.atlisp/atlisp.yaml`（YAML 格式）

首次运行时会自动创建默认配置。

### 配置项说明

#### Agent 配置

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| enabled | boolean | true | 是否启用 agent |
| maxSteps | number | 500 | 最大执行步数（单次对话中最大工具调用次数） |
| verbose | boolean | false | 调试模式，输出详细信息 |

#### LLM 配置

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| provider | string | deepseek | LLM 提供商：deepseek、vllm、openai、ollama |
| baseURL | string | - | API 地址（不同 provider 有不同默认值） |
| model | string | - | 模型名称 |
| apiKey | string | - | API Key |
| temperature | number | 0.7 | 温度参数（0-2，越高越有创造力） |
| maxTokens | number | 65536 | 最大 token 数 |

#### MCP 配置

| 配置项 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| mode | string | stdio | 连接模式：http 或 stdio |
| url | string | http://localhost:8110 | HTTP 模式端点 |
| command | string | atlisp-mcp | stdio 模式命令 |
| args | array | ["--stdio"] | stdio 模式参数 |

### 配置示例

#### 使用 DeepSeek（默认）

```json
{
  "llm": {
    "provider": "deepseek",
    "model": "deepseek-v4-flash",
    "apiKey": "sk-xxxxx"
  }
}
```

#### 使用本地 Ollama

```json
{
  "llm": {
    "provider": "openai",
    "baseURL": "http://localhost:11434/v1",
    "model": "qwen2.5:3b",
    "apiKey": "ollama"
  }
}
```

#### 使用 vLLM

```json
{
  "llm": {
    "provider": "vllm",
    "baseURL": "http://192.168.1.8:8001/v1",
    "model": "deepseek-ai/DeepSeek-R1",
    "apiKey": "EMPTY"
  }
}
```

### 环境变量覆盖

配置可被环境变量覆盖（优先级最高）。

```bash
# LLM 配置
export LLM_PROVIDER=deepseek
export LLM_BASE_URL=https://api.deepseek.com
export LLM_MODEL=deepseek-v4-flash
export LLM_API_KEY=sk-xxxxx

# MCP 配置
export MCP_MODE=stdio
export MCP_URL=http://localhost:8110
```

或在 `~/.atlisp/.env` 文件中配置：

```env
LLM_PROVIDER=deepseek
LLM_API_KEY=sk-xxxxx
LLM_MODEL=deepseek-v4-flash
```

---

## 使用示例

### 示例 1：查询 CAD 版本

```bash
atlisp-agent exec "查询当前 CAD 版本"
```

返回示例：
```
当前 CAD 是 AutoCAD 24.1s (LMS Tech)
```

### 示例 2：执行 AutoLISP 代码

```bash
atlisp-agent exec "获取当前图层名称"
```

返回示例：
```
当前图层是 "0"
```

### 示例 3：列出已安装的 @lisp 包

```bash
atlisp-agent exec "列出已安装的包"
```

### 示例 4：安装 @lisp 包

```bash
atlisp-agent exec "安装 @lisp/core 包"
```

### 示例 5：多轮交互

```bash
atlisp-agent chat
# 然后输入：
# 1. 先查询 CAD 版本
# 2. 列出所有图层
# 3. 创建新图层叫 "AI-TEST"
```

### 示例 6：Ollama 本地模型

确保 Ollama 已运行，然后配置：

```json
{
  "llm": {
    "provider": "openai",
    "baseURL": "http://localhost:11434/v1",
    "model": "qwen2.5:7b",
    "apiKey": "ollama"
  }
}
```

运行：

```bash
atlisp-agent exec "你好"
```

---

## MCP 工具参考

| 工具名 | 说明 |
|--------|------|
| connect_cad | 连接到 CAD |
| eval_lisp | 执行 LISP 代码（无返回） |
| eval_lisp_with_result | 执行 LISP 代码（返回结果） |
| get_cad_info | 获取 CAD 信息 |
| list_packages | 列出已安装包 |
| search_packages | 搜索包 |
| install_package | 安装包 |
| get_platform_info | 获取平台信息 |
| at_command | 执行 @lisp 命令 |

---

## HTTP API

启动服务后可用以下端点：

### 端点列表

| 方法 | 路径 | 说明 |
|------|------|------|
| POST | /chat | AI 对话 |
| POST | /exec | 单次执行 |
| GET | /tools | 列出工具 |
| GET | /health | 健康检查 |
| GET | /history | 获取历史 |
| DELETE | /history | 清除历史 |

### 调用示例

```bash
curl -X POST http://localhost:8110/chat \
  -H "Content-Type: application/json" \
  -d '{"message": "查询 CAD 版本"}'
```

---

## 常见问题

### Q: 连接不上 CAD 怎么办？

1. 确认 CAD 已启动并加载 @lisp
2. 检查 MCP 模式配置（stdio 或 http）
3. 查看 CAD 命令行是否有错误信息

### Q: LLM API 调用失败？

1. 检查 apiKey 是否正确
2. 确认 baseURL 网络可达
3. 查看账户余额是否充足

### Q: 响应速度慢？

1. 尝试使用更小的模型
2. 减少 maxSteps 值
3. 使用本地 Ollama 模型

### Q: 如何切换 LLM Provider？

修改配置文件的 `llm.provider` 字段，或设置环境变量 `LLM_PROVIDER`。

---

## 相关文档

- [[ollama-token-free]] - 用 Ollama 实现 Token 自由
- [[@lisp 文档首页]]