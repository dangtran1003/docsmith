# Generic agent adapter

For agents you build yourself with any model (Qwen, GPT, MiniMax, DeepSeek, Llama, etc.) using any framework (LangChain, LlamaIndex, custom loop, OpenAI-compatible API).

docsmith doesn't care which model you use. It needs three things from your agent:

1. The agent can **read files** from the docsmith-universal `core/` directory.
2. The agent can **write/edit files** in a working directory.
3. The agent follows a **system prompt** that points it at the index.

## Minimal system prompt

Put this in your agent's system prompt (or prepend to the first user message). It's deliberately tiny — it just tells the model how to find and load docsmith on demand.

```
You have access to docsmith, a documentation-automation skill stored as files.

The index is at: <CORE_PATH>/AGENTS.md
Read it FIRST when the user mentions docsmith or asks to create/update/
review/publish documentation.

AGENTS.md is a small index. It maps each command to a file in
<CORE_PATH>/commands/. When the user invokes a command, read ONLY that
command file, then follow it. Load files from <CORE_PATH>/references/,
<CORE_PATH>/templates/, and <CORE_PATH>/fpt/ ONLY when a command file
explicitly tells you to. Never load the whole skill at once — it wastes
context and degrades quality.

You have file read/write tools. Use them to read docsmith files and to
create the documentation workspace under ./documentation/.

Replace <CORE_PATH> with the actual absolute path to docsmith-universal/core.
```

## Why this works on small-context models

docsmith-universal uses progressive disclosure (the 2026 standard for large skills). The index is ~1,200 tokens. A typical command file is ~500 tokens. So a real task loads roughly 1,700-2,500 tokens of instructions — not the full ~48,000 tokens of the complete skill.

This is the whole point: a model with a modest context window can run docsmith because it only ever holds the index plus the one command it's currently executing, plus whatever single reference that command pulls in.

## Tool/function definitions your agent needs

At minimum, expose these to the model (names are examples — match your framework):

```json
[
  {
    "name": "read_file",
    "description": "Read a file's contents",
    "parameters": { "path": "string" }
  },
  {
    "name": "write_file",
    "description": "Create or overwrite a file",
    "parameters": { "path": "string", "content": "string" }
  },
  {
    "name": "edit_file",
    "description": "Replace a string in a file",
    "parameters": { "path": "string", "old": "string", "new": "string" }
  },
  {
    "name": "list_dir",
    "description": "List a directory",
    "parameters": { "path": "string" }
  }
]
```

Optional (enable more commands):
- `run_shell` / `exec` — for git (deploy/publish), ffmpeg (record)
- `browser_navigate` + `browser_screenshot` — for walkthrough/record
- `http_fetch` — for fetch from URLs/APIs

Commands degrade gracefully: with only file tools, the agent can init / module / plan / voice / draft / edit / verify / score. walkthrough, record, deploy need the extra tools.

## Example conversation loop (pseudocode)

```python
system = open(f"{CORE}/AGENTS.md").read()  # or the minimal prompt above
messages = [{"role": "system", "content": SYSTEM_PROMPT}]

while True:
    user = input("> ")
    messages.append({"role": "user", "content": user})

    while True:
        resp = model.chat(messages, tools=TOOLS)
        if resp.tool_calls:
            for call in resp.tool_calls:
                result = dispatch(call)   # read_file/write_file/etc.
                messages.append(tool_result(call, result))
        else:
            print(resp.content)
            messages.append({"role": "assistant", "content": resp.content})
            break
```

When the user says "docsmith init", the model will call `read_file(<CORE>/AGENTS.md)`, see init maps to `commands/init.md`, call `read_file(<CORE>/commands/init.md)`, then follow those instructions using `write_file`/`list_dir` to scaffold `./documentation/`.

## Tips

- If your model tends to over-load files, reinforce in the system prompt: "Read ONE command file per task. Do not read reference or template files unless the command file names them."
- Point `<CORE_PATH>` at a local clone so reads are instant and free.
- For repeatable workflows, you can hardcode "docsmith run" as the first user turn.
- Smaller models follow the index better if you keep your working directory clean (fewer distracting files in list_dir output).
