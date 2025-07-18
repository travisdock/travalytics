## ClaudeOnRails Configuration

You are working on Travalytics, a Rails application. Review the ClaudeOnRails context file at @.claude-on-rails/context.md

## Important: Styling Guidelines

**DO NOT USE TAILWIND CSS** - This project does not use Tailwind. Use regular CSS classes and Rails view helpers for styling.

## Authentication Flow

The application uses a custom authentication system (not Devise):

### Key Components:
- **Authentication Module** (`app/controllers/concerns/authentication.rb`): Provides authentication helpers
  - `authenticate`: Requires login, redirects to login page if not authenticated
  - `authenticated?`: Checks if user is logged in
  - `current_user`: Returns the current authenticated user
  - `start_new_session_for(user)`: Creates a new session for a user
  - `after_authentication_url`: Determines where to redirect after login (stored URL or root)

### Controllers:
- **SessionsController** (`app/controllers/sessions_controller.rb`): Handles login/logout
  - `new`: Login form
  - `create`: Authenticates user and redirects to `after_authentication_url`
  - `destroy`: Logs out user

- **UsersController** (`app/controllers/users_controller.rb`): Handles user registration
  - `new`: Signup form
  - `create`: Creates user, starts session, redirects to `after_authentication_url`

### Session Management:
- Sessions are stored in cookies using Rails' encrypted session store
- Session key: `:user_id`
- Users are automatically logged in after signup via `start_new_session_for`

### Redirect Flow:
- Unauthenticated users trying to access protected pages are redirected to login
- After login/signup, users go to their original destination or dashboard (`root_url`)
- The `store_location` helper saves the intended destination before redirecting to login
