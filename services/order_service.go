package services

import (
	"errors"

	"github.com/agrahafiz13/toku_store_backend/models"
	"github.com/agrahafiz13/toku_store_backend/repositories"
)

func Checkout(
	userID uint,
	shippingAddress string,
	notes string,
	paymentMethod string,
) (*models.Order, error) {

	// ================= AMBIL CART =================
	cartItems, err :=
		repositories.GetCartByUserID(userID)

	if err != nil {
		return nil, err
	}

	// ================= VALIDASI CART =================
	if len(cartItems) == 0 {
		return nil, errors.New("cart is empty")
	}

	// ================= HITUNG TOTAL =================
	var total float64 = 0

	for _, item := range cartItems {

		subtotal :=
			item.Product.Price *
				float64(item.Quantity)

		total += subtotal
	}

	// ================= BUAT ORDER =================
	order := &models.Order{
		UserID: userID,

		TotalAmount: total,

		Status: "pending",

		ShippingAddress: shippingAddress,

		Notes: notes,

		PaymentMethod: paymentMethod,
	}

	err = repositories.CreateOrder(order)

	if err != nil {
		return nil, err
	}

	// ================= BUAT ORDER ITEMS =================
	for _, cartItem := range cartItems {

		subtotal :=
			cartItem.Product.Price *
				float64(cartItem.Quantity)

		orderItem := &models.OrderItem{
			OrderID: order.ID,

			ProductID: cartItem.ProductID,

			Quantity: cartItem.Quantity,

			Price: cartItem.Product.Price,

			Subtotal: subtotal,
		}

		err := repositories.CreateOrderItem(orderItem)

		if err != nil {
			return nil, err
		}
	}

	// ================= CLEAR CART =================
	err = repositories.ClearCartByUserID(userID)

	if err != nil {
		return nil, err
	}

	return order, nil
}
