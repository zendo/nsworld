Use the following git diff to generate a concise commit message.
If the changes are simple, return a single line following: "type: message".
If the changes are complex, provide a title line, a blank line, and a bulleted list of key changes explaining the rationale.
Use the imperative present tense. Do not preamble.

Diff:
!git diff --staged
