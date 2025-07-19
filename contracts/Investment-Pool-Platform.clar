;; Digital Art Auction House: Decentralized platform for digital art auctions
;; Artists create auctions, collectors place bids, curators validate authenticity

(define-data-var chief-curator principal tx-sender)

(define-map auction-registry
  { auction-id: uint }
  {
    artist: principal,
    reserve-price: uint,
    artwork-title: (string-ascii 50),
    artwork-description: (string-ascii 500),
    auction-duration: uint,
    authenticated: bool
  })

(define-map bid-history
  { auction-id: uint, bid-id: uint }
  {
    bidder: principal,
    bid-timestamp: uint,
    bid-status: (string-ascii 20)
  })

(define-data-var next-auction-id uint u1)

(define-map bid-tracker
  { auction-id: uint }
  { total-bids: uint })

;; Create a new art auction
(define-public (create-auction (title-input (string-ascii 50)) (description-input (string-ascii 500)) (duration-input uint) (reserve-input uint))
  (let
    (
      (auction-id (var-get next-auction-id))
      (bid-id u0)
      (title title-input)
      (description description-input)
      (duration duration-input)
      (reserve reserve-input)
    )
    ;; Input validation
    (asserts! (> reserve u0) (err u1))
    (asserts! (> (len title) u0) (err u5))
    (asserts! (> (len description) u0) (err u6))
    (asserts! (> duration u0) (err u7))
    
    (map-set auction-registry
      { auction-id: auction-id }
      {
        artist: tx-sender,
        reserve-price: reserve,
        artwork-title: title,
        artwork-description: description,
        auction-duration: duration,
        authenticated: false
      }
    )
    (map-set bid-history
      { auction-id: auction-id, bid-id: bid-id }
      {
        bidder: tx-sender,
        bid-timestamp: auction-id,
        bid-status: "auction-created"
      }
    )
    (map-set bid-tracker
      { auction-id: auction-id }
      { total-bids: u1 }
    )
    (var-set next-auction-id (+ auction-id u1))
    (ok auction-id)
  ))

;; Place a bid on artwork
(define-public (place-bid (auction-id-input uint))
  (let
    (
      (auction-id auction-id-input)
      (auction-info (unwrap! (map-get? auction-registry { auction-id: auction-id }) (err u2)))
      (reserve (get reserve-price auction-info))
      (artist (get artist auction-info))
      (bid-data (default-to { total-bids: u0 } (map-get? bid-tracker { auction-id: auction-id })))
      (bid-id (get total-bids bid-data))
      (new-bid-id (+ bid-id u1))
    )
    ;; Input validation
    (asserts! (> auction-id u0) (err u8))
    (asserts! (not (is-eq tx-sender artist)) (err u3))
    
    (try! (stx-transfer? reserve tx-sender artist))
    (map-set bid-history
      { auction-id: auction-id, bid-id: bid-id }
      {
        bidder: tx-sender,
        bid-timestamp: (var-get next-auction-id),
        bid-status: "bid-placed"
      }
    )
    (map-set bid-tracker
      { auction-id: auction-id }
      { total-bids: new-bid-id }
    )
    (ok true)
  ))

;; Authenticate artwork (chief curator only)
(define-public (authenticate-artwork (auction-id-input uint))
  (let
    (
      (auction-id auction-id-input)
      (auction-info (unwrap! (map-get? auction-registry { auction-id: auction-id }) (err u2)))
      (bid-data (default-to { total-bids: u0 } (map-get? bid-tracker { auction-id: auction-id })))
      (bid-id (get total-bids bid-data))
      (new-bid-id (+ bid-id u1))
    )
    ;; Input validation
    (asserts! (> auction-id u0) (err u8))
    (asserts! (is-eq tx-sender (var-get chief-curator)) (err u4))
    
    (map-set auction-registry
      { auction-id: auction-id }
      (merge auction-info { authenticated: true })
    )
    (map-set bid-history
      { auction-id: auction-id, bid-id: bid-id }
      {
        bidder: (get artist auction-info),
        bid-timestamp: (var-get next-auction-id),
        bid-status: "authenticated"
      }
    )
    (map-set bid-tracker
      { auction-id: auction-id }
      { total-bids: new-bid-id }
    )
    (ok true)
  ))

;; Get auction details
(define-read-only (get-auction (auction-id uint))
  (map-get? auction-registry { auction-id: auction-id }))

;; Get bid history entry
(define-read-only (get-bid-history (auction-id uint) (bid-id uint))
  (map-get? bid-history { auction-id: auction-id, bid-id: bid-id }))

;; Get total bids for an auction
(define-read-only (get-bid-count (auction-id uint))
  (let
    (
      (bid-data (default-to { total-bids: u0 } (map-get? bid-tracker { auction-id: auction-id })))
    )
    (get total-bids bid-data)
  ))
