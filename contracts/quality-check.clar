;; Quality Check Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))

;; Data Variables
(define-data-var quality-threshold uint u70)
(define-data-var last-check-id uint u0)

;; Maps
(define-map quality-checks
  { check-id: uint }
  {
    product-id: uint,
    quality-score: uint,
    passed: bool,
    timestamp: uint
  }
)

;; Public Functions
(define-public (perform-quality-check (product-id uint) (quality-score uint))
  (let
    (
      (check-id (+ (var-get last-check-id) u1))
      (passed (>= quality-score (var-get quality-threshold)))
    )
    (map-set quality-checks
      { check-id: check-id }
      {
        product-id: product-id,
        quality-score: quality-score,
        passed: passed,
        timestamp: block-height
      }
    )
    (var-set last-check-id check-id)
    (ok { check-id: check-id, passed: passed })
  )
)

(define-public (set-quality-threshold (new-threshold uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (var-set quality-threshold new-threshold)
    (ok true)
  )
)

;; Read-only Functions
(define-read-only (get-quality-check (check-id uint))
  (map-get? quality-checks { check-id: check-id })
)

(define-read-only (get-quality-threshold)
  (ok (var-get quality-threshold))
)

