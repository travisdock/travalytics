/**
 * Format a date string for display
 * @param {string} dateString - ISO date string
 * @param {string} timezone - User's timezone (e.g., 'America/New_York')
 * @returns {string} Formatted date string
 */
export function formatDate(dateString, timezone = 'UTC') {
  if (!dateString) return ''

  const date = new Date(dateString)

  try {
    return date.toLocaleDateString('en-US', {
      timeZone: timezone,
      year: 'numeric',
      month: 'short',
      day: 'numeric'
    })
  } catch {
    // Fallback if timezone is invalid
    return date.toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric'
    })
  }
}

/**
 * Format a date with time
 * @param {string} dateString - ISO date string
 * @param {string} timezone - User's timezone
 * @returns {string} Formatted date and time string
 */
export function formatDateTime(dateString, timezone = 'UTC') {
  if (!dateString) return ''

  const date = new Date(dateString)

  try {
    return date.toLocaleString('en-US', {
      timeZone: timezone,
      year: 'numeric',
      month: 'short',
      day: 'numeric',
      hour: 'numeric',
      minute: '2-digit'
    })
  } catch {
    return date.toLocaleString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
      hour: 'numeric',
      minute: '2-digit'
    })
  }
}
