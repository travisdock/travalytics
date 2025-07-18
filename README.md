# Travalytics

A lightweight, privacy-focused web analytics platform built with Ruby on Rails. Track website visitor behavior without compromising user privacy.

## Features

- **Simple Integration**: Add analytics to any website with a single script tag
- **Real-time Tracking**: Monitor page views and user interactions as they happen
- **Privacy-First**: No cookies, no personal data collection
- **Multi-Site Support**: Track multiple websites from a single dashboard
- **Event Tracking**: Track custom events like button clicks, form submissions, etc.

### Tracking Custom Events

Once the script is loaded, you can track custom events:

```javascript
// Track a custom event
window.TravalyticsAnalytics.track('button_click', {
  button_id: 'signup',
  page: '/pricing'
});
```

