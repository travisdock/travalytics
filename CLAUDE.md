## ClaudeOnRails Configuration

You are working on Travalytics, a Rails application that does very simple web analytics like tracking page views and custom events.

## Key Features

- Users can track events for multiple sites
- Convenient javascript snippet on the site edit page to add to copy and paste

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

## Workflow Guidelines

- This project uses rubocop. Please run rubocop after you finish making code changes and attempt to resolve offenses
- Keep things as simple as possible. Stupidly simple. We can always increase complexity later.
- Attempt to do most things without adding dependencies. If you feel that adding a dependency is the absolute best solution to a problem then ask me first so I can approve.

