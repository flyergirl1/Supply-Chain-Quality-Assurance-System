;; Consumer Interface Contract

;; Constants
(define-constant err-not-found (err u101))

;; Maps
(define-map product-quality-history
  { product-id: uint }
  {
    checks: (list 10 {
      check-id: uint,
      quality-score: uint,
      passed: bool,
      timestamp: uint
    })
  }
)

;; Public Functions
(define-public (add-quality-check (product-id uint) (quality-score uint) (passed bool))
  (let
    (
      (current-history (default-to { checks: (list) } (map-get? product-quality-history { product-id: product-id })))
      (new-check {
        check-id: (+ u1 (len (get checks current-history))),
        quality-score: quality-score,
        passed: passed,
        timestamp: block-height
      })
    )
    (ok (map-set product-quality-history
      { product-id: product-id }
      {
        checks: (unwrap! (as-max-len? (concat (get checks current-history) (list new-check)) u10) err-not-found)
      }
    ))
  )
)

;; Read-only Functions
(define-read-only (get-product-quality-history (product-id uint))
  (ok (default-to
    { checks: (list) }
    (map-get? product-quality-history { product-id: product-id })
  ))
)

