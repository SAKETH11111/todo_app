import { Controller } from "@hotwired/stimulus"

// Simple dark/light theme toggle using the `dark` class on <html>.
// Persists preference in localStorage and respects system preference.
export default class extends Controller {
  connect() {
    const stored = localStorage.getItem("theme")
    const prefersDark = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches
    // Default to dark if no stored preference
    const useDark = stored ? stored === 'dark' : true || prefersDark
    document.documentElement.classList.toggle('dark', useDark)
  }

  toggle() {
    const isDark = document.documentElement.classList.toggle('dark')
    localStorage.setItem('theme', isDark ? 'dark' : 'light')
  }
}
