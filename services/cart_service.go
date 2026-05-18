package services

import (
	"github.com/agrahafiz13/toku_store_backend/models"
	"github.com/agrahafiz13/toku_store_backend/repositories"
)

func AddToCart(
	userID uint,
	productID uint,
	quantity int,
) error {

	existing, err :=
		repositories.FindCartItem(
			userID,
			productID,
		)

	if err == nil {

		existing.Quantity += quantity

		return repositories.UpdateCartItem(
			existing,
		)
	}

	item := &models.CartItem{
		UserID:    userID,
		ProductID: productID,
		Quantity:  quantity,
	}

	return repositories.AddToCart(item)
}

func GetCart(
	userID uint,
) ([]models.CartItem, error) {

	return repositories.GetCartByUserID(
		userID,
	)
}

func UpdateCartItem(
	id uint,
	quantity int,
) error {

	item, err :=
		repositories.FindCartItemByID(id)

	if err != nil {
		return err
	}

	item.Quantity = quantity

	return repositories.UpdateCartItem(item)
}

func RemoveCartItem(
	id uint,
) error {

	return repositories.DeleteCartItem(id)
}
