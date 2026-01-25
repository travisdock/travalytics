import { Link, usePage } from '@inertiajs/react'
import { useEffect, useState } from 'react'

export default function Layout({ children }) {
  const { currentUser, signedIn, flash } = usePage().props
  const [showFlash, setShowFlash] = useState(false)

  useEffect(() => {
    if (flash?.notice || flash?.alert) {
      setShowFlash(true)
      const timer = setTimeout(() => setShowFlash(false), 5000)
      return () => clearTimeout(timer)
    }
  }, [flash])

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Navigation */}
      <nav className="bg-white shadow-sm border-b border-gray-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between h-16">
            <div className="flex items-center space-x-8">
              <a href="/dashboard" className="text-xl font-semibold text-gray-900">
                Travalytics
              </a>
              {signedIn && (
                <div className="flex space-x-4">
                  <a href="/dashboard" className="text-gray-600 hover:text-gray-900 px-3 py-2 text-sm font-medium">
                    Dashboard
                  </a>
                  <Link href="/sites" className="text-gray-600 hover:text-gray-900 px-3 py-2 text-sm font-medium">
                    Sites
                  </Link>
                  <a href="/external_events" className="text-gray-600 hover:text-gray-900 px-3 py-2 text-sm font-medium">
                    External Events
                  </a>
                </div>
              )}
            </div>
            {signedIn && currentUser && (
              <div className="flex items-center space-x-4">
                <span className="text-gray-600 text-sm">{currentUser.email}</span>
                <a
                  href="/session"
                  data-turbo-method="delete"
                  className="text-gray-600 hover:text-gray-900 text-sm font-medium"
                >
                  Sign out
                </a>
              </div>
            )}
          </div>
        </div>
      </nav>

      {/* Flash messages */}
      {showFlash && (flash?.notice || flash?.alert) && (
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 mt-4">
          {flash.notice && (
            <div className="bg-green-50 border border-green-200 text-green-800 px-4 py-3 rounded-md">
              {flash.notice}
            </div>
          )}
          {flash.alert && (
            <div className="bg-red-50 border border-red-200 text-red-800 px-4 py-3 rounded-md">
              {flash.alert}
            </div>
          )}
        </div>
      )}

      {/* Main content */}
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {children}
      </main>
    </div>
  )
}
