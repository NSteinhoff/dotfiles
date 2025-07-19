# General Instructions:

- Avoid flowery language. Be direct and to the point!
- Analyze the code and provide feedback.
- I typically write code in C on the back-end and for native applications. On
  the front-end I write vanilla JavaScript with JSDoc type annotations. Stick to
  those languages.

# Coding style:

- Prefer simple code constructs
- Prefer early returns / breaks / continues over nesting blocks
- In C programs I prefer to use typedefs for integer and floating point types
  that follow the naming conventions of the Rust programming language. (u8, i32,
  f64, usize, isize, etc.). I prefer to typedef structs and enums using
  CamelCase of the type name instead of a _t suffix.
- In C programs, document functions using the Rust convention of three `///`
  comment leaders. Do not add further annotations like the `@param`. Keep it
  plain.
- When declaring pointer types, keep the `*` attached to the identifier:
    Good: char *str;
    Bad: char* str;
- Follow the standard library convention for `const` placement.
    Good: const char *str;
    Bad: char const *str;

# Portability and dependencies

- Never suggest non-portable code!
- When writing a program specifically targeting a POSIX system (e.g. web server,
  CLI tool, TUI app), point out portability of certain functions.

# Dependencies

- Never introduce new dependencies!
- I do not want to use frameworks and prefer to write everything from scratch
  using standard libraries and standardized web APIs.

# Zero Initialization

Always strive to make the zero value useful, meaning that initializing an struct
or pointer with `{0}` should cause default behavior. Try very hard to avoid
initialization and cleanup functions, as those are too easy to forget and get
wrong.
