# Follow the person's theme

**Confidence:** Source.

## Problem

A mod's colors must read well in both light and dark themes.

## API calls

- `$.config.list()` returns the settings rows; the `theme` row names the theme.

## Code sketch

```tsx
const rows = await $.config.list()
const theme = rows.find(r => r.key === 'theme')?.value
const palette = isDarkTheme(theme) ? DARK : LIGHT
```

## Minimum Claude Code version

2.1.296 (the types this pattern was read against).

## Gotchas

- A `ConfigRow` has `key`, `label`, `kind`, `value`, and `provider`. `isDarkTheme` is the mod's own function.

## Sources

- patheonsceo/claudinator (Source): `hooks/register.ts` near L110, with an `isDarkTheme` check. <https://github.com/patheonsceo/claudinator>
