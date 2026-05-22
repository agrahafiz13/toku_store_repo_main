package handlers

import (
	"net/http"

	"github.com/gin-gonic/gin"

	"github.com/agrahafiz13/toku_store_backend/services"
)

// ================= REQUEST MODEL =================

type CheckoutRequest struct {
	ShippingAddress string `json:"shipping_address"`

	Notes string `json:"notes"`

	PaymentMethod string `json:"payment_method"`
}

// ================= CHECKOUT HANDLER =================

func Checkout(c *gin.Context) {

	var req CheckoutRequest

	// bind JSON request
	if err := c.ShouldBindJSON(&req); err != nil {

		c.JSON(http.StatusBadRequest, gin.H{
			"message": err.Error(),
		})

		return
	}

	// sementara pakai user dummy
	userID := uint(1)

	order, err := services.Checkout(
		userID,
		req.ShippingAddress,
		req.Notes,
		req.PaymentMethod,
	)

	if err != nil {

		c.JSON(http.StatusBadRequest, gin.H{
			"message": err.Error(),
		})

		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Checkout success",
		"data":    order,
	})
}
