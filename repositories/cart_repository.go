package repositories

import (
	"github.com/agrahafiz13/toku_store_backend/config"
	"github.com/agrahafiz13/toku_store_backend/models"
)

func AddToCart(item *models.CartItem) error {
	return config.DB.Create(item).Error
}

func GetCartByUserID(
	userID uint,
) ([]models.CartItem, error) {

	var items []models.CartItem

	err := config.DB.
		Preload("Product").
		Where("user_id = ?", userID).
		Find(&items).Error

	return items, err
}

func FindCartItem(
	userID uint,
	productID uint,
) (*models.CartItem, error) {

	var item models.CartItem

	err := config.DB.
		Where(
			"user_id = ? AND product_id = ?",
			userID,
			productID,
		).
		First(&item).Error

	return &item, err
}

func UpdateCartItem(
	item *models.CartItem,
) error {

	return config.DB.Save(item).Error
}

func DeleteCartItem(
	id uint,
) error {

	return config.DB.
		Delete(
			&models.CartItem{},
			id,
		).Error
}

func FindCartItemByID(
	id uint,
) (*models.CartItem, error) {

	var item models.CartItem

	err := config.DB.
		First(&item, id).Error

	return &item, err
}

// ================= CLEAR CART =================

func ClearCartByUserID(
	userID uint,
) error {

	return config.DB.
		Where("user_id = ?", userID).
		Delete(&models.CartItem{}).Error
}
