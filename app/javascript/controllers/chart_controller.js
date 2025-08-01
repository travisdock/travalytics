import { Controller } from "@hotwired/stimulus"
import { Chart, registerables } from "chart.js"
import annotationPlugin from "chartjs-plugin-annotation"

Chart.register(...registerables)
Chart.register(annotationPlugin)

export default class extends Controller {
  static values = { 
    labels: Array,
    data: Array,
    externalEvents: Array
  }

  connect() {
    const ctx = this.element.getContext('2d')
    
    // Process external events for point annotations
    const annotations = {}
    if (this.hasExternalEventsValue && this.externalEventsValue.length > 0) {
      this.externalEventsValue.forEach((event, index) => {
        const eventDateIndex = this.labelsValue.findIndex(label => {
          // Parse the event date (comes as YYYY-MM-DD string)
          const eventDate = new Date(event.date + 'T00:00:00')
          const eventLabel = eventDate.toLocaleDateString('en-US', { month: 'short', day: 'numeric' })
          return label === eventLabel
        })
        
        if (eventDateIndex !== -1) {
          // Find the y-value for this date
          const yValue = this.dataValue[eventDateIndex] || 0
          
          annotations[`event${index}`] = {
            type: 'point',
            xValue: this.labelsValue[eventDateIndex],
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
    
    this.chart = new Chart(ctx, {
      type: 'line',
      data: {
        labels: this.labelsValue,
        datasets: [{
          label: 'Page Views',
          data: this.dataValue,
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
                const label = this.labelsValue[index]
                
                // Find external events for this date
                const eventsForDate = []
                if (this.hasExternalEventsValue && this.externalEventsValue.length > 0) {
                  this.externalEventsValue.forEach(event => {
                    const eventDate = new Date(event.date + 'T00:00:00')
                    const eventLabel = eventDate.toLocaleDateString('en-US', { month: 'short', day: 'numeric' })
                    
                    if (label === eventLabel) {
                      eventsForDate.push(event)
                    }
                  })
                }
                
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
  }

  disconnect() {
    if (this.chart) {
      this.chart.destroy()
    }
  }
}
