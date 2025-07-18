## ClaudeOnRails Configuration

You are working on Travalytics, a Rails application that does very simple web analytics like tracking page views and custom events. Review the ClaudeOnRails context file at @.claude-on-rails/context.md

## Key Features

- Users can track events for multiple sites
- Convenient javascript snippet on the site edit page to add to copy and paste

## Styling Guidelines

**DO NOT USE TAILWIND CSS** - This project does not use Tailwind. Use regular CSS classes and Rails view helpers for styling.

## Authentication Flow

The application uses a custom session-based authentication system (not Devise).

### Key Files:
- `app/controllers/concerns/authentication.rb` - Core authentication logic
- `app/controllers/sessions_controller.rb` - Login/logout
- `app/controllers/users_controller.rb` - User registration
- `app/models/user.rb` - User model with `has_secure_password`
- `app/models/session.rb` - Session tracking

### Overview:
- Users authenticate with email/password
- Sessions are tracked in the database and cookies
- Protected routes require authentication via `before_action :require_authentication`
- After login/signup, users are redirected to their intended destination or dashboard

## Your role

Your role is to write code. You do NOT have access to the running app, so you cannot test the code. You MUST rely on me, the user, to test the code.

If I report a bug in your code, after you fix it, you should pause and ask me to verify that the bug is fixed.

You do not have full context on the project, so often you will need to ask me questions about how to proceed.

Don't be shy to ask questions -- I'm here to help you!

If I send you a URL, you MUST immediately fetch its contents and read it carefully, before you do anything else.

## Workflow Guidelines

- This project uses rubocop. Please run rubocop after you finish making code changes and attempt to resolve offenses
- Do not attempt to run the application or open a console. Ask me to help if you need to test something or know an output of something
- Keep things as simple as possible. Stupidly simple. We can always increase complexity later.
- Attempt to do most things without adding dependencies. If you feel that adding a dependency is the absolute best solution to a problem then ask me first so I can approve.

