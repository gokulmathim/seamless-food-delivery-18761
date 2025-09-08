# Contributing

- Use Provider for state and keep API calls in `src/services`.
- Public interfaces should be documented with the PUBLIC_INTERFACE comment.
- Avoid using BuildContext after an `await`; update primitive state only and trigger UI via state flags as needed.
- Do not hardcode configuration; use environment variables loaded via `.env`.
- When adding dependencies, update `pubspec.yaml` first.
