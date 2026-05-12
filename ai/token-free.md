# 用 Ollama 实现 Token 自由

在 AI 应用中，Token 费用是一笔不小的开支。无论是调用 ChatGPT、Claude 还是 DeepSeek，每一次请求都在消耗真金白银。对于个人开发者、小团队甚至企业来说，每月几千甚至几万元的 Token 费用并不罕见。

如何实现「Token 自由」？答案是：**在本地运行大模型**。

---

## 什么是 Ollama？

Ollama 是一个轻量级的本地大模型运行框架，让你在个人电脑上轻松运行各种开源大模型。

### 核心特点

| 特点 | 说明 |
|------|------|
| 一键运行 | 一条命令即可启动模型 |
| OpenAI 兼容 | 提供 `/v1/chat/completions` 接口，现有应用无需修改即可接入 |
| 多平台支持 | Windows、macOS、Linux 都能运行 |
| 模型丰富 | 支持 Llama、Mistral、Gemma、Qwen、DeepSeek 等主流模型 |

---

## 开始使用 Ollama

### 1. 安装

**方式一：winget（推荐 Windows 用户）**

```bash
winget install Ollama.Ollama
```

**方式二：手动下载**

访问 [ollama.com/download](https://ollama.com/download)，下载对应系统的安装包。

安装完成后，验证安装：

```bash
ollama --version
```

### 2. 下载模型

选择一个适合你硬件的模型：

| 模型 | 参数量 | 最低显存 | 推荐场景 |
|------|--------|----------|----------|
| Qwen2.5:0.5b | 5 亿 | 无需 GPU | 笔记本办公 |
| Qwen2.5:3b | 30 亿 | 4GB | 性价比之选 |
| Phi-4 | 140 亿 | 8GB | 质量不错 |
| Llama3.3:70b | 700 亿 | 32GB | 性能最强 |

下载模型：

```bash
ollama pull qwen2.5:3b
```

### 3. 启动服务

Ollama 默认在 `http://localhost:11434` 提供 API 服务：

```bash
# 交互式聊天
ollama run qwen2.5:3b

# 查看已安装的模型
ollama list
```

---

## 在 @lisp Agent 中使用 Ollama

修改 `~/.atlisp/atlisp.json` 配置文件：

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

或使用环境变量：

```bash
set LLM_PROVIDER=openai
set LLM_BASE_URL=http://localhost:11434/v1
set LLM_MODEL=qwen2.5:3b
set LLM_API_KEY=ollama
```

然后运行：

```bash
atlisp-agent exec "你好"
```

---

## 推荐配置

### 办公电脑（无独立显卡）

- **推荐模型**：Qwen2.5:0.5b / Qwen2.5:1.5b
- **体验**：CPU 推理，速度稍慢但完全可用

### 游戏本（8GB+ 显存）

- **推荐模型**：Qwen2.5:7b / Phi-4:14b
- **体验**：日常对话和代码生成都能流畅运行

### 台式机（16GB+ 显存）

- **推荐模型**：Qwen2.5:14b / DeepSeek-R1:14b
- **体验**：接近云端大模型的水平

---

## 进阶：多模型管理

Ollama 支持同时运行多个模型，通过标签管理：

```bash
# 给模型打标签
ollama tag qwen2.5:3b qwen-work

# 使用标签运行
ollama run qwen-work
```

---

## 关于 Tool Calling

### 什么是 Tool Calling？

Tool Calling（工具调用）是 LLM 的一种能力，允许模型在生成回复时主动调用外部工具或 API。对于 @lisp Agent 来说，这项能力至关重要：

- **执行 CAD 命令**：让 AI 直接操作 AutoCAD/ZWCAD
- **运行 AutoLISP 代码**：自动编写和执行代码
- **查询/管理包**：搜索、安装 @lisp 包

没有 Tool Calling，AI 只能进行普通对话，无法操作 CAD。

### 模型支持情况

| 模型 | Tool Calling 支持 | 推荐场景 |
|------|-------------------|----------|
| Qwen2.5:14b 及以上 | ✅ 支持 | 生产环境 |
| DeepSeek-R1 | ✅ 支持 | 推理任务 |
| Llama3.3 | ✅ 支持 | 通用场景 |
| Gemma 4 | ✅ 支持 | Google 模型 |
| Qwen2.5:7b 及以下 | ❌ 不支持 | 仅聊天 |

### 如果模型不支持 Tool Calling

可以选择更大的模型（如 Qwen2.5:14b），或者接受仅使用纯对话模式。@lisp Agent 会自动检测并提示。

---

## 常见问题

**Q: 本地模型响应慢怎么办？**
A: 选择更小的量化版本（如 qwen2.5:3b），或升级硬件（增加显存）。

**Q: 中文效果不好怎么办？**
A: 推荐使用 Qwen 系列模型，对中文优化更好。

**Q: 如何只让特定应用使用 Ollama？**
A: 修改该应用的 LLM 配置，将 baseURL 指向 `http://localhost:11434/v1`。

---

## 总结

通过 Ollama，你可以：

- ✅ 零成本运行无限量的 AI 对话
- ✅ 数据完全本地化，隐私安全有保障
- ✅ 摆脱 API 配额和速率限制

对于 CAD 自动化、代码生成等场景，本地模型已经足够使用。配合 @lisp 的 MCP 工具链，即使在离线环境下也能完成大部分 AI 辅助工作。

**Token 自由，从今天开始。**

---

*本文档可通过 atlisp-agent 的 docs 命令查看最新版本。*