;; Incentive Token Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))

;; Token definition
(define-fungible-token quality-token)

;; Public Functions
(define-public (mint (recipient principal) (amount uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (ft-mint? quality-token amount recipient)
  )
)

(define-public (transfer (amount uint) (sender principal) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender sender) err-owner-only)
    (ft-transfer? quality-token amount sender recipient)
  )
)

;; Read-only Functions
(define-read-only (get-balance (account principal))
  (ok (ft-get-balance quality-token account))
)

(define-read-only (get-total-supply)
  (ok (ft-get-supply quality-token))
)

