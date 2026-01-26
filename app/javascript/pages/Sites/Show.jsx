import { usePage, router } from '@inertiajs/react'
import React, { useState } from 'react'
import Layout from '../../components/Layout'
import PageViewsChart from '../../components/PageViewsChart'
import { formatDateTime } from '../../utils/formatters'

function SitesShow() {
  const {
    site,
    startDate,
    endDate,
    totalEvents,
    totalPageViews,
    uniqueVisitors,
    chartLabels,
    chartData,
    externalEvents,
    topPaths,
    topReferrers,
    topCountries,
    events,
    userTimezone
  } = usePage().props

  const [customStartDate, setCustomStartDate] = useState(startDate)
  const [customEndDate, setCustomEndDate] = useState(endDate)
  const [expandedEvents, setExpandedEvents] = useState(new Set())

  const toggleEventExpanded = (eventId) => {
    setExpandedEvents(prev => {
      const next = new Set(prev)
      if (next.has(eventId)) {
        next.delete(eventId)
      } else {
        next.add(eventId)
      }
      return next
    })
  }

  const applyDateRange = (start, end) => {
    router.get(`/sites/${site.id}`, { start_date: start, end_date: end }, { preserveState: true })
  }

  const applyPreset = (days) => {
    const end = new Date()
    const start = new Date()
    start.setDate(start.getDate() - days + 1)
    applyDateRange(start.toISOString().split('T')[0], end.toISOString().split('T')[0])
  }

  const applyCustomRange = () => {
    applyDateRange(customStartDate, customEndDate)
  }

  const formatNumber = (num) => {
    return new Intl.NumberFormat().format(num)
  }

  const truncate = (str, length) => {
    if (!str) return ''
    return str.length > length ? str.substring(0, length) + '...' : str
  }

  return (
    <div>
      {/* Page header */}
      <div className="flex justify-between items-start mb-8">
        <div>
          <h1 className="text-2xl font-semibold text-gray-900">{site.name}</h1>
          <p className="mt-1 text-gray-600">{site.domain}</p>
        </div>
        <div className="flex flex-wrap gap-2">
          <a
            href={`/sites/${site.id}/weekly_summary`}
            className="inline-flex items-center px-3 py-1.5 bg-gray-100 text-gray-700 text-sm font-medium rounded-md hover:bg-gray-200"
          >
            Weekly Summary
          </a>
          <a
            href={`/sites/${site.id}/page_durations`}
            className="inline-flex items-center px-3 py-1.5 bg-gray-100 text-gray-700 text-sm font-medium rounded-md hover:bg-gray-200"
          >
            Page Durations
          </a>
          <a
            href={`/sites/${site.id}/edit`}
            className="inline-flex items-center px-3 py-1.5 bg-gray-100 text-gray-700 text-sm font-medium rounded-md hover:bg-gray-200"
          >
            Edit Site
          </a>
          <a
            href="/sites"
            className="inline-flex items-center px-3 py-1.5 border border-gray-300 text-gray-700 text-sm font-medium rounded-md hover:bg-gray-50"
          >
            ← Back to Sites
          </a>
        </div>
      </div>

      {/* Date filters */}
      <div className="bg-white shadow-sm rounded-lg border border-gray-200 p-4 mb-8">
        <div className="flex flex-wrap items-center gap-4">
          <span className="text-sm font-medium text-gray-700">Date Range:</span>
          <div className="flex flex-wrap gap-2">
            <button
              onClick={() => applyPreset(7)}
              className="px-3 py-1.5 text-sm rounded-md border border-gray-300 hover:bg-gray-50"
            >
              Last 7 days
            </button>
            <button
              onClick={() => applyPreset(30)}
              className="px-3 py-1.5 text-sm rounded-md border border-gray-300 hover:bg-gray-50"
            >
              Last 30 days
            </button>
            <button
              onClick={() => applyPreset(90)}
              className="px-3 py-1.5 text-sm rounded-md border border-gray-300 hover:bg-gray-50"
            >
              Last 90 days
            </button>
          </div>
          <div className="flex items-center gap-2 ml-auto">
            <input
              type="date"
              value={customStartDate}
              onChange={(e) => setCustomStartDate(e.target.value)}
              className="px-2 py-1.5 text-sm border border-gray-300 rounded-md"
            />
            <span className="text-gray-500">to</span>
            <input
              type="date"
              value={customEndDate}
              onChange={(e) => setCustomEndDate(e.target.value)}
              className="px-2 py-1.5 text-sm border border-gray-300 rounded-md"
            />
            <button
              onClick={applyCustomRange}
              className="px-3 py-1.5 text-sm bg-blue-600 text-white rounded-md hover:bg-blue-700"
            >
              Apply
            </button>
          </div>
        </div>
      </div>

      {/* Stats overview */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
        <div className="bg-white shadow-sm rounded-lg border border-gray-200 p-4">
          <h3 className="text-sm text-gray-500 mb-1">Total Events</h3>
          <p className="text-2xl font-bold text-gray-900">{formatNumber(totalEvents)}</p>
        </div>
        <div className="bg-white shadow-sm rounded-lg border border-gray-200 p-4">
          <h3 className="text-sm text-gray-500 mb-1">Page Views</h3>
          <p className="text-2xl font-bold text-gray-900">{formatNumber(totalPageViews)}</p>
        </div>
        <div className="bg-white shadow-sm rounded-lg border border-gray-200 p-4">
          <h3 className="text-sm text-gray-500 mb-1">Unique Visitors</h3>
          <p className="text-2xl font-bold text-gray-900">{formatNumber(uniqueVisitors)}</p>
        </div>
        <div className="bg-white shadow-sm rounded-lg border border-gray-200 p-4">
          <h3 className="text-sm text-gray-500 mb-1">Countries</h3>
          <p className="text-2xl font-bold text-gray-900">{topCountries.length}</p>
        </div>
      </div>

      {/* Chart section */}
      <div className="bg-white shadow-sm rounded-lg border border-gray-200 p-6 mb-8">
        <h3 className="text-lg font-medium text-gray-900 mb-4">
          Page Views ({new Date(startDate).toLocaleDateString('en-US', { month: 'short', day: 'numeric' })} - {new Date(endDate).toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' })})
        </h3>

        {externalEvents.length > 0 && (
          <div className="mb-4 p-3 bg-gray-50 rounded-md">
            <p className="text-sm font-medium text-gray-700 mb-2">External Events:</p>
            <div className="flex flex-wrap gap-2">
              {externalEvents.map((event, index) => (
                <div
                  key={index}
                  className="inline-flex items-center gap-1 px-2 py-1 bg-white border border-gray-200 rounded text-xs"
                >
                  <span className="font-medium">
                    {new Date(event.date + 'T00:00:00').toLocaleDateString('en-US', { month: 'short', day: 'numeric' })}
                  </span>
                  <span className="text-gray-400">•</span>
                  <span>{event.type.replace(/_/g, ' ')}</span>
                  <span className="text-gray-400">-</span>
                  <span title={event.title}>{truncate(event.title, 30)}</span>
                  {event.url && (
                    <a
                      href={event.url}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="text-blue-500 hover:text-blue-700"
                    >
                      ↗
                    </a>
                  )}
                </div>
              ))}
            </div>
          </div>
        )}

        <PageViewsChart
          labels={chartLabels}
          data={chartData}
          externalEvents={externalEvents}
        />
      </div>

      {/* Data tables */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
        {/* Top Pages */}
        <div className="bg-white shadow-sm rounded-lg border border-gray-200 p-4">
          <h3 className="text-lg font-medium text-gray-900 mb-3">Top Pages</h3>
          {topPaths.length > 0 ? (
            <table className="w-full text-sm">
              <tbody>
                {topPaths.map(([path, count], index) => (
                  <tr key={index} className="border-b border-gray-100 last:border-0">
                    <td className="py-2 break-all text-gray-700">{path || '/'}</td>
                    <td className="py-2 text-right text-gray-600 w-16">{formatNumber(count)}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          ) : (
            <p className="text-gray-500 text-sm">No page data yet</p>
          )}
        </div>

        {/* Top Referrers */}
        <div className="bg-white shadow-sm rounded-lg border border-gray-200 p-4">
          <h3 className="text-lg font-medium text-gray-900 mb-3">Top Referrers</h3>
          {topReferrers.length > 0 ? (
            <table className="w-full text-sm">
              <tbody>
                {topReferrers.map(([domain, count], index) => (
                  <tr key={index} className="border-b border-gray-100 last:border-0">
                    <td className="py-2 break-all text-gray-700">{domain}</td>
                    <td className="py-2 text-right text-gray-600 w-16">{formatNumber(count)}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          ) : (
            <p className="text-gray-500 text-sm">No referrer data yet</p>
          )}
        </div>

        {/* Top Countries */}
        <div className="bg-white shadow-sm rounded-lg border border-gray-200 p-4">
          <h3 className="text-lg font-medium text-gray-900 mb-3">Top Countries</h3>
          {topCountries.length > 0 ? (
            <table className="w-full text-sm">
              <tbody>
                {topCountries.map(([country, count], index) => (
                  <tr key={index} className="border-b border-gray-100 last:border-0">
                    <td className="py-2 text-gray-700">{country}</td>
                    <td className="py-2 text-right text-gray-600 w-16">{formatNumber(count)}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          ) : (
            <p className="text-gray-500 text-sm">No country data yet</p>
          )}
        </div>
      </div>

      {/* Recent Events */}
      <div className="bg-white shadow-sm rounded-lg border border-gray-200 overflow-hidden">
        <div className="px-4 py-3 border-b border-gray-200">
          <h2 className="text-lg font-medium text-gray-900">Recent Events</h2>
        </div>

        {events.length > 0 ? (
          <>
            <div className="overflow-x-auto">
              <table className="min-w-full divide-y divide-gray-200">
                <thead className="bg-gray-50">
                  <tr>
                    <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Event</th>
                    <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Path</th>
                    <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Location</th>
                    <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Referrer</th>
                    <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Properties</th>
                    <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Time</th>
                  </tr>
                </thead>
                <tbody className="bg-white divide-y divide-gray-200">
                  {events.map((event) => {
                    const isExpanded = expandedEvents.has(event.id)
                    const hasProperties = event.properties && Object.keys(event.properties).length > 0
                    return (
                      <React.Fragment key={event.id}>
                        <tr className="hover:bg-gray-50">
                          <td className="px-4 py-3 text-sm text-gray-900">
                            {event.event_name.replace(/_/g, ' ')}
                            {event.is_bot && <span className="ml-1">🤖</span>}
                          </td>
                          <td className="px-4 py-3 text-sm text-gray-600 max-w-xs truncate" title={event.path}>
                            {event.path || '-'}
                          </td>
                          <td className="px-4 py-3 text-sm text-gray-600 max-w-xs truncate" title={event.location}>
                            {event.location || '-'}
                          </td>
                          <td className="px-4 py-3 text-sm text-gray-600 max-w-xs truncate" title={event.referrer}>
                            {event.referrer || 'No Referer'}
                          </td>
                          <td className="px-4 py-3 text-sm text-gray-600">
                            {hasProperties ? (
                              <button
                                onClick={() => toggleEventExpanded(event.id)}
                                className="text-blue-600 hover:text-blue-800"
                              >
                                {isExpanded ? '▼ Hide' : '▶ View'}
                              </button>
                            ) : (
                              '-'
                            )}
                          </td>
                          <td className="px-4 py-3 text-sm text-gray-600 whitespace-nowrap">
                            {formatDateTime(event.created_at, userTimezone)}
                          </td>
                        </tr>
                        {isExpanded && hasProperties && (
                          <tr className="bg-gray-50">
                            <td colSpan={6} className="px-4 py-3">
                              <pre className="p-3 bg-gray-100 rounded text-xs whitespace-pre-wrap break-all">
                                {JSON.stringify(event.properties, null, 2)}
                              </pre>
                            </td>
                          </tr>
                        )}
                      </React.Fragment>
                    )
                  })}
                </tbody>
              </table>
            </div>
            {events.length === 100 && (
              <div className="px-4 py-3 bg-gray-50 border-t border-gray-200 text-sm text-gray-500">
                Showing most recent 100 events
              </div>
            )}
          </>
        ) : (
          <div className="p-8 text-center">
            <p className="text-gray-500">No events recorded yet</p>
            <p className="text-sm text-gray-400 mt-1">Events will appear here once your site starts tracking user activity.</p>
          </div>
        )}
      </div>
    </div>
  )
}

SitesShow.layout = (page) => <Layout>{page}</Layout>

export default SitesShow
