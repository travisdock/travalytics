import { Link, router, usePage } from '@inertiajs/react'
import Layout from '../../components/Layout'
import { formatDate } from '../../utils/formatters'

function SitesIndex() {
  const { sites, userTimezone } = usePage().props
  const { csrfToken } = usePage().props

  const handleDelete = (siteId, siteName) => {
    if (confirm(`Are you sure you want to delete "${siteName}"?`)) {
      router.delete(`/sites/${siteId}`, {
        headers: {
          'X-CSRF-Token': csrfToken
        }
      })
    }
  }

  return (
    <div>
      {/* Page header */}
      <div className="flex justify-between items-start mb-8">
        <div>
          <h1 className="text-2xl font-semibold text-gray-900">Sites</h1>
          <p className="mt-1 text-gray-600">Manage your tracked websites</p>
        </div>
        <a
          href="/sites/new"
          className="inline-flex items-center px-4 py-2 bg-blue-600 text-white text-sm font-medium rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
        >
          Add Site
        </a>
      </div>

      {/* Sites table or empty state */}
      {sites.length > 0 ? (
        <div className="bg-white shadow-sm rounded-lg border border-gray-200 overflow-hidden">
          <table className="min-w-full divide-y divide-gray-200">
            <thead className="bg-gray-50">
              <tr>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Name
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Domain
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Tracking ID
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Created
                </th>
                <th className="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider w-48">
                  Actions
                </th>
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-200">
              {sites.map((site) => (
                <tr key={site.id} className="hover:bg-gray-50">
                  <td className="px-6 py-4 whitespace-nowrap">
                    <span className="font-medium text-gray-900">{site.name}</span>
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-gray-600">
                    {site.domain}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap">
                    <code className="bg-gray-100 px-2 py-1 rounded text-sm font-mono text-gray-700">
                      {site.tracking_id}
                    </code>
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-gray-600">
                    {formatDate(site.created_at, userTimezone)}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-right text-sm">
                    <a
                      href={`/sites/${site.id}`}
                      className="text-blue-600 hover:text-blue-800 font-medium mr-4"
                    >
                      View
                    </a>
                    <a
                      href={`/sites/${site.id}/edit`}
                      className="text-blue-600 hover:text-blue-800 font-medium mr-4"
                    >
                      Edit
                    </a>
                    <button
                      onClick={() => handleDelete(site.id, site.name)}
                      className="text-red-600 hover:text-red-800 font-medium"
                    >
                      Delete
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      ) : (
        <div className="bg-white shadow-sm rounded-lg border border-gray-200 p-12 text-center">
          <p className="text-gray-500 mb-4">No sites added yet</p>
          <a
            href="/sites/new"
            className="inline-flex items-center px-4 py-2 bg-gray-100 text-gray-700 text-sm font-medium rounded-md hover:bg-gray-200"
          >
            Add your first site
          </a>
        </div>
      )}
    </div>
  )
}

SitesIndex.layout = (page) => <Layout>{page}</Layout>

export default SitesIndex
