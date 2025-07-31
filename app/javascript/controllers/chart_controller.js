import { Controller } from "@hotwired/stimulus"
import { Chart, registerables } from "chart.js"

Chart.register(...registerables)

export default class extends Controller {
  static values = { 
    labels: Array,
    data: Array,
    externalEvents: Array
  }

  connect() {
    const ctx = this.element.getContext('2d')
    
    // Process external events for annotations if they exist
    const annotations = {}
    if (this.hasExternalEventsValue && this.externalEventsValue.length > 0) {
      this.externalEventsValue.forEach((event, index) => {
        const eventDateIndex = this.labelsValue.findIndex(label => {
          const chartDate = new Date(Date.parse(label + ' ' + new Date().getFullYear()))
          const eventDate = new Date(event.date)
          return chartDate.toDateString() === eventDate.toDateString()
        })
        
        if (eventDateIndex !== -1) {
          annotations[`event${index}`] = {
            type: 'line',
            xMin: eventDateIndex,
            xMax: eventDateIndex,
            borderColor: 'rgba(239, 68, 68, 0.5)',
            borderWidth: 2,
            borderDash: [5, 5],
            label: {
              enabled: true,
              content: event.type.charAt(0).toUpperCase(),
              position: 'start',
              backgroundColor: 'rgba(239, 68, 68, 0.8)',
              color: 'white',
              font: {
                size: 10,
                weight: 'bold'
              }
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
