import { useEffect, useRef } from 'react'
import { Chart, registerables } from 'chart.js'
import annotationPlugin from 'chartjs-plugin-annotation'

Chart.register(...registerables)
Chart.register(annotationPlugin)

export default function PageViewsChart({ labels, data, externalEvents = [] }) {
  const canvasRef = useRef(null)
  const chartRef = useRef(null)

  useEffect(() => {
    if (!canvasRef.current) return

    const ctx = canvasRef.current.getContext('2d')

    // Process external events for point annotations
    const annotations = {}
    if (externalEvents.length > 0) {
      externalEvents.forEach((event, index) => {
        const eventDateIndex = labels.findIndex(label => {
          const eventDate = new Date(event.date + 'T00:00:00')
          const eventLabel = eventDate.toLocaleDateString('en-US', { month: 'short', day: 'numeric' })
          return label === eventLabel
        })

        if (eventDateIndex !== -1) {
          const yValue = data[eventDateIndex] || 0

          annotations[`event${index}`] = {
            type: 'point',
            xValue: labels[eventDateIndex],
            yValue: yValue,
            backgroundColor: 'rgba(239, 68, 68, 0.8)',
            borderColor: 'rgba(239, 68, 68, 1)',
            borderWidth: 2,
            radius: 6,
            label: {
              display: true,
              content: event.type.charAt(0).toUpperCase(),
              position: 'top',
              backgroundColor: 'rgba(239, 68, 68, 0.9)',
              color: 'white',
              font: {
                size: 10,
                weight: 'bold'
              },
              padding: 2
            }
          }
        }
      })
    }

    chartRef.current = new Chart(ctx, {
      type: 'line',
      data: {
        labels: labels,
        datasets: [{
          label: 'Page Views',
          data: data,
          borderColor: 'rgb(75, 192, 192)',
          backgroundColor: 'rgba(75, 192, 192, 0.1)',
          tension: 0.1,
          fill: true
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            display: false
          },
          tooltip: {
            mode: 'index',
            intersect: false,
            callbacks: {
              afterBody: (context) => {
                const index = context[0].dataIndex
                const label = labels[index]

                const eventsForDate = externalEvents.filter(event => {
                  const eventDate = new Date(event.date + 'T00:00:00')
                  const eventLabel = eventDate.toLocaleDateString('en-US', { month: 'short', day: 'numeric' })
                  return label === eventLabel
                })

                if (eventsForDate.length > 0) {
                  const lines = ['', 'External Events:']
                  eventsForDate.forEach(event => {
                    lines.push(`• ${event.type}: ${event.title}`)
                  })
                  return lines
                }

                return []
              }
            }
          },
          annotation: {
            annotations: annotations
          }
        },
        scales: {
          x: {
            display: true,
            grid: {
              display: false
            }
          },
          y: {
            display: true,
            beginAtZero: true,
            ticks: {
              stepSize: 1,
              precision: 0
            }
          }
        }
      }
    })

    return () => {
      if (chartRef.current) {
        chartRef.current.destroy()
      }
    }
  }, [labels, data, externalEvents])

  return (
    <div style={{ position: 'relative', height: '300px' }}>
      <canvas ref={canvasRef}></canvas>
    </div>
  )
}
