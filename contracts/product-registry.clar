;; Product Registry Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))

;; Data Variables
(define-data-var last-product-id uint u0)

;; Maps
(define-map products
  { product-id: uint }
  {
    name: (string-ascii 50),
    manufacturer: principal,
    creation-date: uint,
    last-check-id: uint
  }
)

;; Public Functions
(define-public (register-product (name (string-ascii 50)))
  (let
    (
      (product-id (+ (var-get last-product-id) u1))
    )
    (map-set products
      { product-id: product-id }
      {
        name: name,
        manufacturer: tx-sender,
        creation-date: block-height,
        last-check-id: u0
      }
    )
    (var-set last-product-id product-id)
    (ok product-id)
  )
)

(define-public (update-last-check (product-id uint) (check-id uint))
  (let
    (
      (product (unwrap! (map-get? products { product-id: product-id }) err-not-found))
    )
    (asserts! (is-eq tx-sender (get manufacturer product)) err-owner-only)
    (map-set products
      { product-id: product-id }
      (merge product { last-check-id: check-id })
    )
    (ok true)
  )
)

;; Read-only Functions
(define-read-only (get-product (product-id uint))
  (map-get? products { product-id: product-id })
)

(define-read-only (get-last-product-id)
  (ok (var-get last-product-id))
)

