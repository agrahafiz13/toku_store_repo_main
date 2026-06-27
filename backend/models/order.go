package models

import "gorm.io/gorm"

type Order struct {
	gorm.Model

	UserID uint `json:"user_id"`

	TotalAmount float64 `json:"total_amount"`

	Status string `json:"status"`

	ShippingAddress string `json:"shipping_address"`

	Notes string `json:"notes"`

	PaymentMethod string `json:"payment_method"`

	Items []OrderItem `json:"items" gorm:"foreignKey:OrderID"`
}
