;; IoT Data Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))

;; Data Variables
(define-data-var last-data-id uint u0)

;; Maps
(define-map iot-data
  { data-id: uint }
  {
    product-id: uint,
    timestamp: uint,
    temperature: int,
    humidity: int,
    pressure: int,
    quality-score: uint
  }
)

;; Public Functions
(define-public (add-iot-data (product-id uint) (temperature int) (humidity int) (pressure int))
  (let
    (
      (data-id (+ (var-get last-data-id) u1))
      (quality-score (calculate-quality-score temperature humidity pressure))
    )
    (map-set iot-data
      { data-id: data-id }
      {
        product-id: product-id,
        timestamp: block-height,
        temperature: temperature,
        humidity: humidity,
        pressure: pressure,
        quality-score: quality-score
      }
    )
    (var-set last-data-id data-id)
    (ok data-id)
  )
)

;; Private Functions
(define-private (calculate-quality-score (temperature int) (humidity int) (pressure int))
  (let
    (
      (temp-diff (if (> temperature 20) (- temperature 20) (- 20 temperature)))
      (humidity-diff (if (> humidity 50) (- humidity 50) (- 50 humidity)))
      (pressure-diff (if (> pressure 1000) (- pressure 1000) (- 1000 pressure)))
      (temp-score (- u100 (to-uint temp-diff)))
      (humidity-score (- u100 (to-uint humidity-diff)))
      (pressure-score (- u100 (to-uint pressure-diff)))
    )
    (/ (+ temp-score humidity-score pressure-score) u3)
  )
)

;; Read-only Functions
(define-read-only (get-iot-data (data-id uint))
  (map-get? iot-data { data-id: data-id })
)

(define-read-only (get-last-data-id)
  (ok (var-get last-data-id))
)

