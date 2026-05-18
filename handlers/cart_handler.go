package handlers

import (
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"

	"github.com/agrahafiz13/toku_store_backend/services"
)

type AddCartRequest struct {
	ProductID uint `json:"product_id"`
	Quantity  int  `json:"quantity"`
}

func AddToCart(c *gin.Context) {

	var req AddCartRequest

	if err := c.ShouldBindJSON(&req); err != nil {

		c.JSON(http.StatusBadRequest, gin.H{
			"message": err.Error(),
		})

		return
	}

	userID := uint(1)

	err := services.AddToCart(
		userID,
		req.ProductID,
		req.Quantity,
	)

	if err != nil {

		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})

		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Added to cart",
	})
}

func GetCart(c *gin.Context) {

	userID := uint(1)

	items, err :=
		services.GetCart(userID)

	if err != nil {

		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})

		return
	}

	c.JSON(http.StatusOK, gin.H{
		"data": gin.H{
			"items": items,
		},
	})
}

func UpdateCart(c *gin.Context) {

	idParam := c.Param("id")

	var req AddCartRequest

	if err := c.ShouldBindJSON(&req); err != nil {

		c.JSON(http.StatusBadRequest, gin.H{
			"message": err.Error(),
		})

		return
	}

	var id uint

	fmt.Sscanf(idParam, "%d", &id)

	err := services.UpdateCartItem(
		id,
		req.Quantity,
	)

	if err != nil {

		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})

		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Cart updated",
	})
}

func RemoveCart(c *gin.Context) {

	idParam := c.Param("id")

	var id uint

	fmt.Sscanf(idParam, "%d", &id)

	err := services.RemoveCartItem(id)

	if err != nil {

		c.JSON(http.StatusInternalServerError, gin.H{
			"message": err.Error(),
		})

		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Cart removed",
	})
}
