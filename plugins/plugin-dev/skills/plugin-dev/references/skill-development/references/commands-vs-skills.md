# Commands vs Skills: When to Use Each

## Same Mechanism, Different Complexity

Both commands and skills:

- Are invoked via the Skill tool
- Support $ARGUMENTS and `[BANG]` bash execution
- Support frontmatter (description, allowed-tools, model)
- Can control invocability (disable-model-invocation)

## Decision Matrix

| Need                    | Use     | Location               |
| ----------------------- | ------- | ---------------------- |
| Simple reusable prompt  | Command | commands/foo.md        |
| Dynamic arguments only  | Command | commands/foo.md        |
| Scripts for validation  | Skill   | skills/foo/            |
| Reference documentation | Skill   | skills/foo/references/ |
| Working examples        | Skill   | skills/foo/examples/   |
| Progressive disclosure  | Skill   | skills/foo/            |

## Invocation Control

| Setting                             | User (/) | Claude (Skill tool) |
| ----------------------------------- | -------- | ------------------- |
| Default                             | Yes      | Yes                 |
| disable-model-invocation: true      | Yes      | No                  |
| user-invocable: false (skills only) | No       | Yes                 |

## Migration: Command to Skill

When a command grows complex:

1. Create `skills/name/SKILL.md`
2. Move command content to SKILL.md body (frontmatter fields like `description`, `allowed-tools`, and `model` carry over). For `model`, the skill reference lists `inherit` as the default value, while the command docs and `check-frontmatter.sh` cover only `haiku`/`sonnet`/`opus` or a full model ID and treat omitting `model` as "use the conversation's model". When moving in either direction, omit `model` to keep the conversation's model rather than writing `inherit`
3. Add `references/` for detailed docs
4. Add `scripts/` for utilities
5. Delete original command file
