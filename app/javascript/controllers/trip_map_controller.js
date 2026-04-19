import { Controller } from "@hotwired/stimulus"
import L from "leaflet"

const MARKER_STYLE = {
  radius: 9,
  color: "#1d4ed8",
  weight: 2,
  fillColor: "#3b82f6",
  fillOpacity: 0.85
}

const PICKER_MARKER_STYLE = {
  radius: 10,
  color: "#15803d",
  weight: 2,
  fillColor: "#22c55e",
  fillOpacity: 0.9
}

export default class extends Controller {
  static targets = ["map", "latitudeField", "longitudeField", "nameField", "idField", "locationSelect"]

  static values = {
    mode: { type: String, default: "markers" },
    markers: Array,
    locations: { type: Array, default: [] },
    geocodeUrl: { type: String, default: "" },
    defaultLat: { type: Number, default: 50.45 },
    defaultLng: { type: Number, default: 30.52 },
    defaultZoom: { type: Number, default: 6 }
  }

  connect () {
    this.nameTouched = false
    this.map = L.map(this.mapTarget).setView(
      [this.defaultLatValue, this.defaultLngValue],
      this.defaultZoomValue
    )

    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>'
    }).addTo(this.map)

    if (this.modeValue === "picker") {
      this.setupPicker()
    } else {
      this.setupMarkers()
    }

    requestAnimationFrame(() => this.map.invalidateSize())
  }

  setupMarkers () {
    const markers = this.markersValue
    if (!markers.length) {
      return
    }

    const bounds = L.latLngBounds([])
    markers.forEach((m) => {
      const layer = L.circleMarker([m.lat, m.lng], MARKER_STYLE).addTo(this.map)

      layer.bindTooltip(m.label, { sticky: true })
      layer.on("click", () => {
        if (window.Turbo) {
          window.Turbo.visit(m.url)
        } else {
          window.location.assign(m.url)
        }
      })
      bounds.extend([m.lat, m.lng])
    })

    this.map.fitBounds(bounds, { padding: [48, 48], maxZoom: 14 })
  }

  setupPicker () {
    this.pickerMarker = null

    const lat = parseFloat(this.latitudeFieldTarget.value)
    const lng = parseFloat(this.longitudeFieldTarget.value)

    if (this.validLatLng(lat, lng)) {
      this.map.setView([lat, lng], 12)
      this.setPickerMarker(lat, lng, false, false)
    }

    this.map.on("click", (e) => {
      const { lat: clat, lng: clng } = e.latlng
      this.setPickerMarker(clat, clng, true, true)
    })
  }

  syncFromLocationSelect () {
    if (!this.hasLocationSelectTarget) return

    const sel = this.locationSelectTarget
    const id = sel.value

    if (!id) {
      this.nameTouched = false
      if (this.hasIdFieldTarget) this.idFieldTarget.value = ""
      if (this.hasNameFieldTarget) this.nameFieldTarget.value = ""
      this.clearCoordinateFields()
      this.clearPickerMarker()
      this.map.setView([this.defaultLatValue, this.defaultLngValue], this.defaultZoomValue)
      return
    }

    const loc = this.locationsValue.find((l) => String(l.id) === String(id))
    if (!loc) return

    this.nameTouched = false
    if (this.hasIdFieldTarget) this.idFieldTarget.value = String(loc.id)
    if (this.hasNameFieldTarget) this.nameFieldTarget.value = loc.name || ""

    const lat = loc.lat
    const lng = loc.lng
    if (this.validLatLng(lat, lng)) {
      this.map.setView([lat, lng], 12)
      this.setPickerMarker(lat, lng, false, false)
    } else {
      this.clearCoordinateFields()
      this.clearPickerMarker()
      this.map.setView([this.defaultLatValue, this.defaultLngValue], this.defaultZoomValue)
    }
  }

  onNameInput () {
    this.nameTouched = true
  }

  syncFromInputs () {
    if (this.modeValue !== "picker") return

    const lat = parseFloat(this.latitudeFieldTarget.value)
    const lng = parseFloat(this.longitudeFieldTarget.value)

    if (!this.validLatLng(lat, lng)) {
      this.clearPickerMarker()
      return
    }

    this.setPickerMarker(lat, lng, false, false)
    this.map.panTo([lat, lng])
  }

  clearCoordinateFields () {
    this.latitudeFieldTarget.value = ""
    this.longitudeFieldTarget.value = ""
  }

  clearPickerMarker () {
    if (this.pickerMarker) {
      this.map.removeLayer(this.pickerMarker)
      this.pickerMarker = null
    }
  }

  setPickerMarker (lat, lng, writeInputs, fetchName) {
    if (writeInputs) {
      this.latitudeFieldTarget.value = lat.toFixed(6)
      this.longitudeFieldTarget.value = lng.toFixed(6)
    }

    if (this.pickerMarker) {
      this.pickerMarker.setLatLng([lat, lng])
    } else {
      this.pickerMarker = L.circleMarker([lat, lng], PICKER_MARKER_STYLE).addTo(this.map)
    }

    if (fetchName && this.geocodeUrlValue && this.hasNameFieldTarget && !this.nameTouched) {
      const nameEmpty = !this.nameFieldTarget.value || !this.nameFieldTarget.value.trim()
      if (nameEmpty) {
        this.reverseGeocode(lat, lng)
      }
    }
  }

  async reverseGeocode (lat, lng) {
    if (!this.geocodeUrlValue) return

    const url = `${this.geocodeUrlValue}?lat=${encodeURIComponent(lat)}&lng=${encodeURIComponent(lng)}`
    try {
      const res = await fetch(url, {
        headers: { Accept: "application/json" },
        credentials: "same-origin"
      })
      if (!res.ok) return
      const data = await res.json()
      if (data.name && this.hasNameFieldTarget && !this.nameTouched) {
        this.nameFieldTarget.value = data.name
      }
    } catch (_) {
      /* ignore */
    }
  }

  validLatLng (lat, lng) {
    return Number.isFinite(lat) && Number.isFinite(lng) &&
      lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180
  }

  disconnect () {
    if (this.map) {
      this.map.remove()
      this.map = null
    }
    this.pickerMarker = null
  }
}
