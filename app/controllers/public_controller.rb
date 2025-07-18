class PublicController < ApplicationController
  allow_unauthenticated_access
  skip_before_action :verify_authenticity_token

  def analytics_script
    # Set content type for JavaScript
    response.headers["Content-Type"] = "application/javascript"

    # Render the analytics JavaScript
    render plain: analytics_js_content
  end

  private

  def analytics_js_content
    <<~JS
      // Travalytics Analytics Tracking Script
      (function() {
        'use strict';

        class Analytics {
          constructor(trackingId) {
            this.trackingId = trackingId;
            this.endpoint = null; // Will be set during initialization
            this.pageStartTime = Date.now();

            // Auto-track page views
            this.trackPageView();

            // Track page duration on unload
            window.addEventListener('beforeunload', () => {
              this.trackPageDuration();
            });
          }

          trackPageView() {
            this.track('page_view', {
              path: window.location.pathname,
              title: document.title,
              referrer: document.referrer,
              timestamp: new Date().toISOString()
            });
          }

          trackPageDuration() {
            const duration = Date.now() - this.pageStartTime;
            this.track('page_duration', {
              path: window.location.pathname,
              duration_ms: duration
            });
          }

          track(eventName, properties = {}) {
            const body = {
              event: {
                event_name: eventName,
                properties: properties
              }
            };

            fetch(this.endpoint, {
              method: 'POST',
              headers: {
                'Content-Type': 'application/json',
              },
              body: JSON.stringify(body)
            }).catch(error => {
              console.error('Analytics tracking error:', error);
            });
          }
        }

        // Auto-initialize if tracking ID is provided
        const script = document.currentScript;
        const trackingId = script.getAttribute('data-tracking-id');
        const endpoint = script.getAttribute('data-endpoint') || 'https://travserve.net';

        if (trackingId) {
          const analytics = new Analytics(trackingId);
          analytics.endpoint = `${endpoint}/track/${trackingId}/events`;
          window.TravalyticsAnalytics = analytics;
        } else {
          console.error('Travalytics: No tracking ID provided');
        }
      })();
    JS
  end
end
