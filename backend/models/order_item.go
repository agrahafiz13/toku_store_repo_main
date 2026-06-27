package models

import "gorm.io/gorm"

type OrderItem struct {
	gorm.Model

	OrderID uint `json:"order_id"`

	ProductID uint `json:"product_id"`

	Product Product `json:"product" gorm:"foreignKey:ProductID"`

	Quantity int `json:"quantity"`

	Price float64 `json:"price"`

	Subtotal float64 `json:"subtotal"`
}
