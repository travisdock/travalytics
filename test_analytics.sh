#!/bin/bash

# Replace this with your actual tracking ID from the Sites page
TRACKING_ID="f3f2b933-ef4e-423b-86dd-dfb6848d3fdf"
BASE_URL="http://localhost:3000"

echo "Testing Analytics API"
echo "===================="
echo ""
echo "Make sure to replace YOUR_TRACKING_ID_HERE with an actual tracking ID from your Sites page!"
echo ""

# Test 1: Page View Event
echo "1. Testing page view event..."
curl -X POST "$BASE_URL/track/$TRACKING_ID/events" \
  -H "Content-Type: application/json" \
  -H "Origin: http://localhost" \
  -d '{
    "event": {
      "event_name": "page_view",
      "properties": {
        "path": "/home",
        "title": "Home Page",
        "referrer": "https://google.com",
        "timestamp": "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'"
      }
    }
  }' \
  -w "\nHTTP Status: %{http_code}\n"

echo ""
echo ""

# Test 2: Button Click Event
echo "2. Testing button click event..."
curl -X POST "$BASE_URL/track/$TRACKING_ID/events" \
  -H "Content-Type: application/json" \
  -H "Origin: http://localhost" \
  -d '{
    "event": {
      "event_name": "button_click",
      "properties": {
        "button_text": "Subscribe",
        "path": "/pricing",
        "timestamp": "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'"
      }
    }
  }' \
  -w "\nHTTP Status: %{http_code}\n"

echo ""
echo ""

# Test 3: Form Submit Event
echo "3. Testing form submit event..."
curl -X POST "$BASE_URL/track/$TRACKING_ID/events" \
  -H "Content-Type: application/json" \
  -H "Origin: http://localhost" \
  -d '{
    "event": {
      "event_name": "form_submit",
      "properties": {
        "form_name": "contact",
        "path": "/contact",
        "timestamp": "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'"
      }
    }
  }' \
  -w "\nHTTP Status: %{http_code}\n"

echo ""
echo ""

# Test 4: Invalid tracking ID
echo "4. Testing invalid tracking ID (should return 401)..."
curl -X POST "$BASE_URL/track/invalid-tracking-id/events" \
  -H "Content-Type: application/json" \
  -H "Origin: http://localhost" \
  -d '{
    "event": {
      "event_name": "test_event"
    }
  }' \
  -w "\nHTTP Status: %{http_code}\n"

echo ""
echo "Done! Check your dashboard to see the tracked events."
