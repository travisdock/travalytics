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

        // Check for developer exclusion URL params
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('travalytics_exclude_me') === 'true') {
          localStorage.setItem('travalytics_developer_mode', 'true');
          console.log('Travalytics: Developer mode enabled - tracking disabled');
        } else if (urlParams.get('travalytics_include_me') === 'true') {
          localStorage.removeItem('travalytics_developer_mode');
          console.log('Travalytics: Developer mode disabled - tracking enabled');
        }

        // Skip all tracking if developer mode is enabled
        if (localStorage.getItem('travalytics_developer_mode') === 'true') {
          console.log('Travalytics: Developer mode - tracking disabled');
          return;
        }

        class Analytics {
          constructor(trackingId) {
            this.trackingId = trackingId;
            this.endpoint = null; // Will be set during initialization
            this.pageStartTime = Date.now();
            this.visitorUuid = this.getOrCreateVisitorUuid();
          }

          // Generate UUID v4
          generateUuid() {
            return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
              const r = Math.random() * 16 | 0;
              const v = c === 'x' ? r : (r & 0x3 | 0x8);
              return v.toString(16);
            });
          }

          // Get or create visitor UUID with 2-week expiration
          getOrCreateVisitorUuid() {
            const storageKey = `travalytics_visitor_${this.trackingId}`;
            const storedData = localStorage.getItem(storageKey);
      #{'      '}
            if (storedData) {
              try {
                const data = JSON.parse(storedData);
                // Check if UUID has expired (2 weeks = 1209600000 ms)
                if (data.expires && data.expires > Date.now()) {
                  return data.uuid;
                }
              } catch (e) {
                // Invalid data, regenerate
              }
            }

            // Generate new UUID with 2-week expiration
            const newUuid = this.generateUuid();
            const expirationTime = Date.now() + (14 * 24 * 60 * 60 * 1000); // 2 weeks
            
            try {
              localStorage.setItem(storageKey, JSON.stringify({
                uuid: newUuid,
                expires: expirationTime
              }));
            } catch (e) {
              console.warn('Travalytics: Unable to save visitor UUID to localStorage');
            }

            return newUuid;
          }

          init() {
            // Auto-track page views
            this.trackPageView();

            // Track page duration on unload
            window.addEventListener('beforeunload', () => {
              this.trackPageDuration();
            });
          }

          trackPageView() {
            this.track('page_view', {
              url: window.location.href,
              path: window.location.pathname,
              title: document.title,
              referrer: document.referrer,
              timestamp: new Date().toISOString()
            });
          }

          trackPageDuration() {
            const duration = Date.now() - this.pageStartTime;
            this.track('page_duration', {
              url: window.location.href,
              path: window.location.pathname,
              duration_ms: duration
            });
          }

          track(eventName, properties = {}) {
            const body = {
              event: {
                event_name: eventName,
                properties: properties,
                visitor_uuid: this.visitorUuid
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
          analytics.init();
          window.TravalyticsAnalytics = analytics;
        } else {
          console.error('Travalytics: No tracking ID provided');
        }
      })();
    JS
  end
end
